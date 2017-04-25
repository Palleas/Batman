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
    
    let selectedProject = MutableProperty<Project?>(nil)
    
    private let projectsPath: URL

    init(client: Client, cacheDirectory: URL) {
        self.client = client
        self.projectsPath = cacheDirectory.appendingPathComponent("projects.json")
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
            guard FileManager.default.fileExists(atPath: self.projectsPath.path) else {
                sink.send(error: .noCache)
                return
            }
            
            do {
                // TODO: Expiration date
                sink.send(value: try Data(contentsOf: self.projectsPath))
                sink.sendCompleted()
            } catch {
                sink.send(error: .noCache)
            }
        }
            .attemptMap { return decode(from: $0).mapError { print("error \($0)"); return ProjectsError.noCache } }
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
                try encoded.write(to: self.projectsPath)
                print("Cached to \(self.projectsPath)")
            } catch {
                print("Unable to cache projects")
            }
        }
    }
}
