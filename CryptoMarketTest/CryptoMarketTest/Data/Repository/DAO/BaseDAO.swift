import Foundation
import CoreData

protocol BaseDAO {
    associatedtype Entity
    associatedtype Storage
    
    var storage: Storage { get }
    init(storage: Storage)
    
    func deleteAllEntities() async throws
    func deleteAllEntities(in context: NSManagedObjectContext) throws
    func getEntities() async throws -> [Entity]
    func addReplacing(_ entity: Entity) async -> Entity
}

extension BaseDAO {
    func deleteAllEntities() async throws {}
    func deleteAllEntities(in context: NSManagedObjectContext) throws {}
    func getEntities() throws -> [Entity] {[]}
}
