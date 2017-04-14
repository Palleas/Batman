import Foundation
import ReactiveSwift
import Unbox
import Result

extension URLRequest {
    
    static func create(_ endpoint: Client.Endpoint) -> URLRequest {
        let url = Client.gateway.appendingPathComponent(endpoint.path)
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!

        if let fields = endpoint.fields?.joined(separator: ",") {
            comps.queryItems = [URLQueryItem(name: "opt_fields", value: fields)]
        }
        
        return URLRequest(url: comps.url!)
    }
    
    static func create<T: Encodable>(_ endpoint: Client.Endpoint, object: T? = nil) -> URLRequest {
        var request = URLRequest.create(endpoint)
        
        if let body = object?.encode() {
            request.httpBody = body
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = ["Content-type": "application/x-www-form-urlencoded"]
        }

        return request
    }
    
}

final class Client {
    static let gateway = URL(string: "https://app.asana.com/api/1.0")!
    
    enum Endpoint {
        case projects
        case workspaces
        case tasks
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
    
    func workspaces() -> SignalProducer<[Workspace], ClientError> {
        return get(.workspaces)
    }
    
    func create<T: Encodable>(_ object: T, at: Endpoint) -> SignalProducer<T.Response, ClientError> {
        return .empty
    }
    
    func get<T: Unboxable>(_ endpoint: Endpoint) -> SignalProducer<T, ClientError> {
        let request = URLRequest.create(endpoint)
        
        return session.reactive.data(with: request)
            .mapError { _ in ClientError.requestError }
            .attemptMap { return decode(from: $0.0).mapError { _ in ClientError.decodingError } }
    }
    
    func get<T: Unboxable>(_ endpoint: Endpoint) -> SignalProducer<[T], ClientError> {
        let request = URLRequest.create(endpoint)
        
        return session.reactive.data(with: request)
            .mapError { _ in ClientError.requestError }
            .attemptMap { return decode(from: $0.0).mapError { _ in ClientError.decodingError } }
    }

}

extension Client.Endpoint {
    var path: String {
        switch self {
        case .projects: return "/projects"
        case .workspaces: return "/workspaces"
        case .tasks: return "/tasks"
        }
    }
    
    var fields: [String]? {
        switch self {
        case .projects:
            return ["name", "color"]
        case .workspaces:
            return ["id", "name", "is_organization"]
        default:
            return nil
        }
    }
}
