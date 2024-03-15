import Foundation
import CoreData

protocol DataStorage {
    var mainContext: NSManagedObjectContext { get }
    func saveContext() throws
}
