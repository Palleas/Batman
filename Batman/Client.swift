import Foundation
import ReactiveSwift
import Unbox
import Result

final class Client {
    private static let gateway = URL(string: "https://app.asana.com/api/1.0")!
    
    enum Endpoint {
        case projects
    }
    
    enum ClientError: Error {
        case requestError
        case decodingError
    }
    
    private let session: URLSession
    
    init(token: Token) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": "Bearer \(token.value)"]
        self.session = URLSession(configuration: config)
    }
    
    func projects() -> SignalProducer<[Project], ClientError> {
        return get(.projects)
    }
    
    func get<T: Unboxable>(_ endpoint: Endpoint) -> SignalProducer<T, ClientError> {
        let url = Client.gateway.appendingPathComponent(endpoint.path)
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        comps.queryItems = [URLQueryItem(name: "opt_fields", value: endpoint.fields.joined(separator: ","))]
        
        let request = URLRequest(url: comps.url!)
        
        return session.reactive.data(with: request)
            .mapError { _ in ClientError.requestError }
            .attemptMap { return decode(from: $0.0).mapError { _ in ClientError.decodingError } }
    }
    
    func get<T: Unboxable>(_ endpoint: Endpoint) -> SignalProducer<[T], ClientError> {
        let url = Client.gateway.appendingPathComponent(endpoint.path)
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        comps.queryItems = [URLQueryItem(name: "opt_fields", value: endpoint.fields.joined(separator: ","))]
        
        let request = URLRequest(url: comps.url!)
        
        return session.reactive.data(with: request)
            .mapError { _ in ClientError.requestError }
            .attemptMap { return decode(from: $0.0).mapError { _ in ClientError.decodingError } }
    }

}

extension Client.Endpoint {
    var path: String {
        switch self {
        case .projects: return "/projects"
        }
    }
    
    var fields: [String] {
        switch self {
        case .projects:
            return ["name", "color"]
        }
    }
}
