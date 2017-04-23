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
    
    private let projects: ProjectsController
    
    let selected = MutableProperty<Project?>(nil)
    
    init(projects: ProjectsController) {
        self.projects = projects
    }
    
    func start() {
        let fetched = projects.fetch()
            .flatMapError { _ in SignalProducer<[Project], NoError>.empty }
        
        controller.projects <~ fetched
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
