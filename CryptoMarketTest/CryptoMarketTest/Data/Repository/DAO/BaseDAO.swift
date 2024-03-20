import Foundation
import CoreData

protocol BaseDAO {
    associatedtype T
    associatedtype Storage
    
    var storage: Storage { get }
    init(storage: Storage)
    
    func deleteAllEntities() async throws
    func deleteAllEntities(in context: NSManagedObjectContext) throws
    func getEntities() throws -> [T]
}

extension BaseDAO {
    func deleteAllEntities() async throws {}
    func deleteAllEntities(in context: NSManagedObjectContext) throws {}
    func getEntities() throws -> [T] {[]}
}
