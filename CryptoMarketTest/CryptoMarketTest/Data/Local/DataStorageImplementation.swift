import Foundation
import CoreData

final class DataStorageImplementation: DataStorage {
    
    static let shared = DataStorageImplementation()
    
    private let persistentContainer: NSPersistentContainer
    var mainContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    init(isInMemoryStore: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "CryptoMarketTest")
        
        if isInMemoryStore {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() throws {
        let context = mainContext
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            context.reset()
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext) throws {
        guard context != mainContext else {
            try saveContext()
            return
        }
        
        try context.performAndWait {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            try self.saveContext(self.mainContext)
        }
    }
}
