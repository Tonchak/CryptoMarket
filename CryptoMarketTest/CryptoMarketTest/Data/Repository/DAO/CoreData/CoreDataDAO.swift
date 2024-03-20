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
    
    func getEntities() throws -> [T] {
        let context = storage.mainContext
        guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
            throw CoreDataError.readingError("CoreData entity can't de read!")
        }
        return try context.fetch(request)
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
}

enum CoreDataError: Error, Equatable {
    case writingError(String)
    case savingError(String)
    case readingError(String)
    case deletingErorr(String)
}
