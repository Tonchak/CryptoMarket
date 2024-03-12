import Foundation
import CoreData

final class DataStorageImplementation: DataStorage {
    var context: NSManagedObjectContext
    static let shared = DataStorageImplementation()
    
    init(inMemory: Bool = false) {
        let databaseName = "CryptoMarketTest"
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: DataStorageImplementation.self)])
        guard let managedObjectModel else {
            fatalError("Failed to create a ManagedObjectModel")
        }
        
        let persistentContainer = NSPersistentContainer(name: databaseName, managedObjectModel: managedObjectModel)
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        self.context = persistentContainer.viewContext
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if inMemory {
            setupInMemory(persistentContainer)
        }
        
        loadPersistentStores(persistentContainer)
    }
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    private func setupInMemory(_ container: NSPersistentContainer) {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
    }
    
    private func loadPersistentStores(_ container: NSPersistentContainer) {
        container.loadPersistentStores { storeDescription, error in
            if error != nil {
                fatalError("Failure to load persistant store")
            }
        }
    }
}
