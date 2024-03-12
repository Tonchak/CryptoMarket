import Foundation
import CoreData

class CoreDataAccessObject<T: NSManagedObject>: DefaultDataAccessObject {
    
    typealias LocalStorage = DataStorage
    var storage: LocalStorage
    
    required init(storage: LocalStorage = DataStorageImplementation.shared) {
        self.storage = storage
    }
    
    func getEntities() throws -> [T] {
        let context = storage.context
        guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
            throw DatabaseError.readingError("CoreData entity can't de read!")
        }
        return try context.fetch(request)
    }
    
    func deleteAllEntities() async throws {
        let c = self.storage.context
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

enum DatabaseError: Error, Equatable {
    case writingError(String)
    case savingError(String)
    case readingError(String)
    case deletingErorr(String)
}
