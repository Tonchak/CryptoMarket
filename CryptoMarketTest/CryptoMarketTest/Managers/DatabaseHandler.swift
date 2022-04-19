//
//  DatabaseHandler.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 6/4/22.
//

import UIKit
import CoreData
import MagicalRecord

class DatabaseHandler {

    var items: [ListingLatest] = []
    var timer: Timer!
    let defaultTimeTick: TimeInterval = 1
    let timeoutTargetValue: TimeInterval = 300
    var progressTime: TimeInterval = 0
    
    static let shared: DatabaseHandler = {
        let instance = DatabaseHandler()
        NotificationCenter.default.addObserver(instance, selector: #selector(checkLaunchDate), name: UIApplication.didBecomeActiveNotification, object: nil)
        return instance
    }()
    
    private init() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    static func checkAPIManagerInstance() {
        let instance1 = MarketAPIManager.shared
        let instance2 = MarketAPIManager.shared

        if (instance1 === instance2) {
            print("APIManager works, both variables contain the same instance.")
        } else {
            print("APIManager failed, variables contain different instances.")
        }
    }
    
    public func fetchCurrenciesList() {
        fetchListWith { items in
            self.models = items
        }
    }
    
    public func updateList(completionBlock: @escaping () -> Void) {
        fetchListWith { items in
            self.models = items
            completionBlock()
        }
    }
    
    // MARK: -
    
    private func fetchListWith(block: @escaping (_ items: Array<ListingLatest>) -> Void ) {
        MarketAPIManager.shared.fetchList { items in
            self.updateLaunchDate()
            block(items)
        }
    }
    
    private func updateLaunchDate() {
        
        UserDefaults.standard.set(Date(), forKey: "date.launch")
        
        stopTimer()
        
        progressTime = 0
        
        timer = Timer.scheduledTimer(timeInterval: defaultTimeTick, target: self, selector: #selector(timeOutUpdate), userInfo: NSNumber.init(floatLiteral: timeoutTargetValue), repeats: true)
        
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func timeOutUpdate(tmr: Timer) {
        
        let progress: TimeInterval = tmr.userInfo as! TimeInterval
        
        progressTime += defaultTimeTick
        if (progress < 0 && progressTime <= timeoutTargetValue) || (progress > 0 && progressTime >= timeoutTargetValue) {
            updateList {}
        }
    }
    
    func stopTimer() {
        if (timer != nil) && timer.isValid {
            timer.invalidate()
            timer = nil
        }
    }
    
    @objc func checkLaunchDate () {
        
        if (UserDefaults.standard.value(forKey: "date.launch") != nil) {
            
            let started: Date = UserDefaults.standard.value(forKey: "date.launch") as! Date
            let now = Date()
            let diff = now.timeIntervalSince(started)
            
            if diff > timeoutTargetValue {
                UserDefaults.standard.set(now, forKey: "date.launch")
                updateList { }
                Swift.print(diff)
            }
            
        } else {
            
            UserDefaults.standard.set(Date(), forKey: "date.launch")
            updateList { }
            
        }
        
    }
}

extension DatabaseHandler: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

extension DatabaseHandler {
    var models: [ListingLatest]? {
        get {
            return items
        }
        set (newValue) {
            items = newValue!
            
            for item in self.items {
                
                MagicalRecord.save({ context in
                    
                    let predicate = NSPredicate(format: "identifier == %d", item.id)
                    
                    var currency = Currency.mr_findFirst(with: predicate, in: context)

                    if currency == nil {
                        currency = Currency.mr_createEntity(in: context)
                    }
                    
                    currency?.setValue(Int16(item.id), forKey: "identifier")
                    currency?.setValue(item.name, forKey: "name")
                    currency?.setValue(item.symbol, forKey: "symbol")
                    currency?.setValue(item.slug, forKey: "slug")
                    currency?.setValue(item.quote?.USD?.price, forKey: "price")
                    currency?.setValue(item.total_supply ?? 0, forKey: "totalSupply")
                    currency?.setValue(String(format: "%d", item.max_supply ?? 0), forKey: "maxSupply")
                    currency?.setValue((item.quote?.USD?.fully_diluted_market_cap) ?? 0, forKey: "fullyDilutedMarketCap")
                    currency?.setValue((item.quote?.USD?.percent_change_1h) ?? 0, forKey: "percentChange1h")
                    currency?.setValue((item.quote?.USD?.percent_change_24h) ?? 0, forKey: "percentChange24h")
                    currency?.setValue((item.quote?.USD?.percent_change_7d) ?? 0, forKey: "percentChange7d")
                })
            }
            
        }
    }
}
