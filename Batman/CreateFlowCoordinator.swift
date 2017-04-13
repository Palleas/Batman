import Foundation
import UIKit

final class CreateFlowCoordinator: Coordinator {

    fileprivate let client: Client
    
    private(set) lazy var controller = UINavigationController()
    
    init(client: Client) {
        self.client = client
    }
    
    func start() {
        let root = StoryboardScene.Main.instantiateCreate()
        root.delegate = self
        
        controller.viewControllers = [root]
    }
}

extension CreateFlowCoordinator: CreateViewControllerDelegate {
    func didTapSelectProject() {
        let project = SelectProjectFlowCoordinator(client: client)
        project.start()
        
        self.children.append(project)
        
        controller.pushViewController(project.controller, animated: true)
        
        project.selected.producer.skipNil().startWithValues { [weak self] project in
            self?.controller.popViewController(animated: true)
            print("Selected project \(project.name)")
        }
    }
}
