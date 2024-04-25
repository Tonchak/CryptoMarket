import Foundation

protocol Repository {
    associatedtype EntityDTO
    associatedtype Service
    
    var dao: QueryDAO { get set }
    var service: Service { get set }
    init(service: Service, dao: QueryDAO)
}
