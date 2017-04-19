import Foundation
import ReactiveSwift
import Result

final class SelectProjectFlowCoordinator: Coordinator {
    
    private(set) lazy var controller: ProjectsViewController = {
        let controller = StoryboardScene.Main.instantiateProjects()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        return controller
    }()
    
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

extension SelectProjectFlowCoordinator: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BlurPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
