import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

final class CreateFlowCoordinator: Coordinator {

    fileprivate let store = Store()
    
    fileprivate let client: Client
    
    fileprivate lazy var root = StoryboardScene.Main.instantiateCreate()

    private(set) lazy var controller: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        return navigationController
    }()
    
    fileprivate let project = MutableProperty<Project?>(nil)
    
    init(client: Client) {
        self.client = client
    }
    
    func start() {
        root.delegate = self
        _ = root.view
        
        let backgroundProducer = project.map { $0?.color?.raw ?? .white }
        root.taskContent.reactive.backgroundColor <~ backgroundProducer
        root.view.reactive.backgroundColor <~ backgroundProducer

        root.projectButton.reactive.title <~ project.map { $0?.name ?? "No-project" }
        
        controller.viewControllers = [root]
        
        project.producer.skipNil().map { $0.id }.startWithValues { [weak self] projectId in
            self?.store.selectedProjectId = projectId
        }
        
        if let projectId = store.selectedProjectId {
            project <~ client.project(id: projectId).flatMapError { _ in
                SignalProducer<Project, NoError>.empty
            }
        }
    }
}

extension CreateFlowCoordinator: CreateViewControllerDelegate {
    func didReleaseToSave() {
        guard let project = project.value else { return }
        
        let task = Task(name: root.taskContent.text, notes: "Notes", projects: [project])
        client.create(task: task).startWithResult { result in
            switch result {
            case let .success(createdTask):
                print("[Create task] Created task = \(createdTask)")
            case let .failure(error):
                print("[Create task] Got error = \(error)")
            }
        }
    }

    func didTapSelectProject() {
        let projectCoordinator = SelectProjectFlowCoordinator(client: client)
        projectCoordinator.start()
        
        self.children.append(projectCoordinator)
        
        controller.pushViewController(projectCoordinator.controller, animated: true)
        
        project <~ projectCoordinator.selected
        
        projectCoordinator.selected.producer.skipNil().startWithValues { [weak self] project in
            self?.controller.popViewController(animated: true)
            print("Selected project \(project.name)")
        }
    }
}
