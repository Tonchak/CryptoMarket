import Foundation
import CoreData

protocol CoreDataStorable {
    var id: String { get set }
}

class CoreDataDAO<Entity: CoreDataStorable, T: NSManagedObject>: BaseDAO {
    typealias Storage = CoreDataStorage
    
    var storage: Storage
    
    required init(storage: Storage = CoreDataStorage.shared) {
        self.storage = storage
    }
    
    func getEntities() async throws -> [Entity] {
        let context = storage.taskContext
        var result: [Entity]!
        try await context.perform {
            do {
                result = try context.fetch(self.generateArrayRequest()).map {
                    self.decode(object: $0)
                }
            } catch {
                CoreDataError.readingError("Data Could Not Be Read")
            }
        }
        return result
    }
    
    func deleteAllEntities() async throws {
        let c = self.storage.mainContext
        try await withCheckedThrowingContinuation { continuation in
            do {
                try self.deleteAllEntities(in: c)
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func addReplacing(_ entity: Entity) async -> Entity {
        let backgroundContext = self.storage.taskContext
        var updatedEntity: Entity!
        await backgroundContext.perform {
            let results = try? backgroundContext.fetch(self.generateElements(entity))
            var coreDataObj: T
            if results?.count == 0 {
                coreDataObj = T(context: backgroundContext)
            } else {
                coreDataObj = results!.first!
            }
            self.encode(entity: entity, into:&coreDataObj)
            do {
                try self.storage.saveContext(backgroundContext)
            } catch {
                print(error.localizedDescription)
            }
            updatedEntity = self.decode(object: coreDataObj)
        }
        return updatedEntity
    }
    
    func generateElements(_ entity: Entity) throws -> NSFetchRequest<T> {
        let request = T.fetchRequest() as! NSFetchRequest<T>
        return request
    }
    
    func generateArrayRequest() -> NSFetchRequest<T> {
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        return request
    }
    
    func encode(entity: Entity, into object: inout T) {
        fatalError("""
                    no encoding provided \(String(describing: Entity.self)) - \(String(describing: T.self))
                    """)
    }
    
    func decode(object: T) -> Entity {
        fatalError("""
                   no decoding provided between core data entity:
                   \(String(describing: T.self))
                   and domain entity: \(String(describing: Entity.self))
                   """)
    }
}

enum CoreDataError: Error, Equatable {
    case writingError(String)
    case savingError(String)
    case readingError(String)
    case deletingErorr(String)
}
