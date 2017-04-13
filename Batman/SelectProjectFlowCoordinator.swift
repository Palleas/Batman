import Foundation
import ReactiveSwift
import Result

final class SelectProjectFlowCoordinator: Coordinator {

    private(set) lazy var controller = StoryboardScene.Main.instantiateProjects()
    
    private let client: Client
    
    let selected = MutableProperty<Project?>(nil)
    
    init(client: Client) {
        self.client = client
    }
    
    func start() {
        let projects = client.projects()
            .flatMapError { _ in SignalProducer<[Project], NoError>.empty }
        
        controller.projects <~ projects
        controller.delegate = self
    }
}

extension SelectProjectFlowCoordinator: ProjectsViewControllerDelegate {
    func didSelect(project: Project) {
        selected.swap(project)
    }
}
