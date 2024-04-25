import UIKit
import CoreData

final class DatabaseHandler {
    var items: [ListingLatest]?
    var timer: Timer?
    let defaultTimeTick: TimeInterval = 1
    let timeoutTargetValue: TimeInterval = 300
    var progressTime: TimeInterval = 0
    
    static let shared: DatabaseHandler = {
        let instance = DatabaseHandler()
        NotificationCenter.default.addObserver(instance, selector: #selector(checkLaunchDate), name: UIApplication.didBecomeActiveNotification, object: nil)
        return instance
    }()
    
    private init(items: [ListingLatest]? = [], timer: Timer? = Timer(), progressTime: TimeInterval = 0) {
        self.items = items
        self.timer = timer
        self.progressTime = progressTime
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    static func checkAPIManagerInstance() {
        let instance1 = APIManager.shared
        let instance2 = APIManager.shared

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
    
    private func fetchListWith(block: @escaping (_ items: [ListingLatest]) -> Void ) {
        APIManager.shared.fetchList { items in
            self.updateLaunchDate()
            block(items)
        }
    }
    
    private func updateLaunchDate() {
        
        UserDefaults.standard.set(Date(), forKey: "date.launch")
        
        stopTimer()
        
        progressTime = 0
        
        timer = Timer.scheduledTimer(
            timeInterval: defaultTimeTick,
            target: self,
            selector: #selector(timeOutUpdate),
            userInfo: NSNumber.init(floatLiteral: timeoutTargetValue), 
            repeats: true
        )
        guard let timer = timer else { return }
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
        guard let timer = timer, timer.isValid else { return }
        timer.invalidate()
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
        set {
            guard let items = newValue else { return }
            self.items = items
            
            for item in items {
            }
        }
    }
}
