import Foundation

protocol Storage {
    associatedtype PersistantContainer
    associatedtype ManagedContext
    var mainContext: ManagedContext { get }
    var taskContext: ManagedContext { get }
    func saveContext() throws
    func saveContext(_ context: ManagedContext) throws
    
    init(isInMemoryStore: Bool)
}
