import Foundation
import UIKit
import ReactiveSwift

protocol ProjectsViewControllerDelegate: class {
    func didSelect(project: Project)
}

final class ProjectsViewController: UITableViewController {
    
    let projects = MutableProperty<[Project]>([])
        
    weak var delegate: ProjectsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        projects.producer.observe(on: UIScheduler()).startWithValues { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects.value[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Project", for: indexPath) as! ProjectCell
        cell.configure(name: project.name, color: project.color?.raw ?? .white)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects.value[indexPath.row]
        delegate?.didSelect(project: project)
    }
}
