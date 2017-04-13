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
        
        projects.producer.observe(on: UIScheduler()).startWithValues { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects.value[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Project", for: indexPath)
        cell.textLabel?.textColor = project.color?.raw
        cell.textLabel?.text = project.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects.value[indexPath.row]
        delegate?.didSelect(project: project)
    }
}
