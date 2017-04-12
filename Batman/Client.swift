import Foundation
import ReactiveSwift

struct Token {
    let value: String
}

protocol Mappable {
    static func map(from payload: Any) -> Self
}

struct Project: Mappable {
    let name: String
    
    static func map(from payload: Any) {
        return
    }
}

final class Batman {
    private static let gateway = URL(string: "https://app.asana.com/api/1.0")!
    
    enum Endpoint {
        case projects
    }
    
    enum ClientError: Error {
        
    }
    
    private let session: URLSession
    
    init(token: Token) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": "Bearer \(token.value)"]
        self.session = URLSession(configuration: config)
    }
    
    func projects() -> SignalProducer<[Project], ClientError> {
//        return session.
    }
    
    func get<T: Mappable>(_ endpoint: Endpoint) -> SignalProducer<T, ClientError> {
        return .empty
    }
}
//
//extension Batman.Endpoint: Hashable {
//    
//}
