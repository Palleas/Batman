import Foundation
import Result
import ReactiveSwift
import Unbox

final class ProjectsController {
    
    enum ProjectsError: Error, AutoEquatable {
        case noCache
        case fetchingError(Client.ClientError)
    }
    
    private let client: Client
    
    private lazy var store: URL = {
        // So many force-unwrap
        let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        return URL(fileURLWithPath: cache!.appending("/projects.json"))
    }()
    
    init(client: Client) {
        self.client = client
    }
    
    typealias Projects = SignalProducer<[Project], ProjectsError>

    func fetch() -> Projects {
        return fetchFromCache().flatMapError { error in
            guard error == ProjectsError.noCache else {
                return SignalProducer(error: error)
            }

            return self.fetchFromRemote()
        }
    }
    
    func fetchFromCache() -> Projects {
        return SignalProducer<Data, ProjectsError> { sink, _ in
            guard FileManager.default.fileExists(atPath: self.store.path) else {
                sink.send(error: .noCache)
                return
            }
            
            do {
                // TODO: Expiration date
                sink.send(value: try Data(contentsOf: self.store))
            } catch {
                sink.send(error: .noCache)
            }
        }
        .attemptMap { return decode(from: $0).mapError { _ in ProjectsError.noCache } }
    }
    
    func fetchFromRemote() -> Projects {
        return self.client.projects()
            .mapError(ProjectsError.fetchingError)
            .flatMap(.latest, transform: self.save)
    }
    
    func save(projects: [Project]) -> SignalProducer<[Project], NoError> {
        return SignalProducer { sink, _ in
            defer {
                // Sending projects anyway
                sink.send(value: projects)
                sink.sendCompleted()
            }
            
            do {
                let encoded = try projects.encode()
                try encoded.write(to: self.store)
                print("Cached to \(self.store)")
            } catch {
                print("Unable to cache projects")
            }
        }
    }
}
