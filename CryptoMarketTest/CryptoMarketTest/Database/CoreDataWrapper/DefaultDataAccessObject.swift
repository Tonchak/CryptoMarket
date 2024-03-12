import Foundation
import CoreData

protocol DefaultDataAccessObject {
    associatedtype T
    var storage: DataStorage { get }
    init(storage: DataStorage)
    
    func deleteAllEntities() async throws
    func deleteAllEntities(in context: NSManagedObjectContext) throws
    func getEntities() throws -> [T]
}

extension DefaultDataAccessObject {
    func deleteAllEntities() async throws {}
    func deleteAllEntities(in context: NSManagedObjectContext) throws {}
    func getEntities() throws -> [T] {[]}
}
