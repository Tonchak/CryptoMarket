import Foundation
import CoreData

protocol DataStorage {
    var context: NSManagedObjectContext { get }
    func saveContext() throws
}
