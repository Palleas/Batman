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
        case project(id: Int)
        case workspaces
        case tasks
    }
    
    enum ClientError: Error, AutoEquatable {
        case networkError(String?)
        case doesNotExist
        case requestError([AsanaError])
        case decodingError
    }
    
    let session: URLSession
    
    init(token: Token) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": "Bearer \(token.value)"]
        self.session = URLSession(configuration: config)
    }
    
    func projects() -> SignalProducer<[Project], ClientError> {
        return fetchMany(.projects)
    }
    
    func project(id: Int) -> SignalProducer<Project, ClientError> {
        return fetchOne(.project(id: id))
    }
    
    func workspaces() -> SignalProducer<[Workspace], ClientError> {
        return fetchMany(.workspaces)
    }
    
    func create(task: Task) -> SignalProducer<(CreatedTask), ClientError> {
        return create(task, at: .tasks)
    }
    
    private func create<T: Encodable>(_ object: T, at endpoint: Endpoint) -> SignalProducer<T.Response, ClientError> {
        let request = URLRequest.create(endpoint, object: object)
        
        return session.reactive.data(with: request)
            .mapError { ClientError.networkError($0.errorDescription) }
            .attemptMap { return decode(from: $0.0).mapError { _ in ClientError.decodingError } }
    }
    
    private func fetchOne<T: Unboxable>(_ endpoint: Endpoint) -> SignalProducer<T, ClientError> {
        return fetch(endpoint).attemptMap { data -> Result<T, Client.ClientError> in
            return decode(from: data).mapError { _ in ClientError.decodingError }
        }
    }

    private func fetchMany<T: Unboxable>(_ endpoint: Endpoint) -> SignalProducer<[T], ClientError> {
        return fetch(endpoint).attemptMap({ data -> Result<[T], Client.ClientError> in
            return decodeArray(from: data).mapError { _ in ClientError.decodingError }
        })
    }
    
    private func fetch(_ endpoint: Endpoint) -> SignalProducer<Data, ClientError> {
        let request = URLRequest.create(endpoint)

        return session.reactive.data(with: request)
            .mapError { ClientError.networkError($0.errorDescription) }
            .attemptMap { data, response in
                let response = response as! HTTPURLResponse
                if response.statusCode == 404 {
                    return .failure(.doesNotExist)
                }
                
                if response.statusCode >= 400 && response.statusCode <= 600 {
                    do {
                        let errors = try decodeErrors(from: data)
                        return .failure(.requestError(errors))
                    } catch {
                        return .failure(.decodingError)
                    }
                }
                
                return .success(data)
            }
    }

}

extension Client.Endpoint {
    var path: String {
        switch self {
        case .projects: return "/projects"
        case let .project(id): return "/projects/\(id)"
        case .workspaces: return "/workspaces"
        case .tasks: return "/tasks"
        }
    }
    
    var fields: [String]? {
        switch self {
        case .projects, .project:
            return ["name", "color"]
        case .workspaces:
            return ["id", "name", "is_organization"]
        default:
            return nil
        }
    }
}
