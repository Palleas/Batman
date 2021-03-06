import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

final class CreateFlowCoordinator: Coordinator {

    fileprivate let store = Store()

    fileprivate let client: Client

    fileprivate lazy var root = StoryboardScene.Main.create.instantiate()

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

        root.tint <~ project.map { $0?.color?.raw ?? .white }
        root.projectName <~ project.map { $0?.name ?? "Select a project" }

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
    func didTapCreate() {
        guard let project = project.value else { return }

        guard case let .success(title, notes) = Builder.task(from: root.taskContent.text) else { return }

        let task = Task(name: title, notes: notes ?? "", projects: [project])
        client.create(task: task).observe(on: UIScheduler()).startWithResult { [weak self] result in
            switch result {
            case let .success(createdTask):
                let sharing = UIActivityViewController(activityItems: [createdTask.url()], applicationActivities: nil)
                sharing.popoverPresentationController?.sourceView = self?.root.view

                let sourcePoint = CGPoint(x: self?.root.view.frame.midX ?? 0, y: self?.root.view.frame.midY ?? 0)
                sharing.popoverPresentationController?.sourceRect = CGRect(origin: sourcePoint, size: .zero)

                sharing.completionWithItemsHandler = { activity, success, items, error in
                    self?.root.reset()
                }

                self?.controller.present(sharing, animated: true, completion: nil)
            case let .failure(error):
                print("[Create task] Got error = \(error)")
            }
        }
    }

    func didTapSelectProject() {
        let cacheDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!)
        let projectCoordinator = SelectProjectFlowCoordinator(projects: ProjectsController(client: client, cacheDirectory: cacheDirectory))
        projectCoordinator.start()

        self.children.append(projectCoordinator)

        controller.present(projectCoordinator.controller, animated: true, completion: nil)

        projectCoordinator.selected.producer.skipNil().startWithValues { [weak self] project in
            self?.project.swap(project)
            self?.controller.dismiss(animated: true, completion: nil)
            print("Selected project \(project.name)")
        }
    }
}
