import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

protocol CreateViewControllerDelegate: class {
    func didTapSelectProject()
    func didTapCreate()
}

final class CreateViewController: UIViewController {

    weak var delegate: CreateViewControllerDelegate?
    
    let taskContent: UITextView = TaskTextView()
    
    let tint = MutableProperty(UIColor.red)
    
    let projectName = MutableProperty("Select a project")

    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    override func loadView() {
        super.loadView()
        
        automaticallyAdjustsScrollViewInsets = false

        view.insertSubview(taskContent, at: 0)

        taskContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskContent.topAnchor.constraint(equalTo: view.topAnchor),
            taskContent.leftAnchor.constraint(equalTo: view.leftAnchor),
            taskContent.rightAnchor.constraint(equalTo: view.rightAnchor),
            taskContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46)
        ])
        
        let center = NotificationCenter.default
        center.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: .main) { note in
            guard let infos = parse(keyboardNotification: note) else { return }

            UIView.animate(withDuration: infos.1, delay: 0, options: infos.2, animations: {
                self.bottomConstant.constant = infos.0
                self.view.layoutIfNeeded()
            }, completion: nil)

        }
        
        center.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: .main) { note in
            guard let infos = parse(keyboardNotification: note) else { return }
            
            UIView.animate(withDuration: infos.1, delay: 0, options: infos.2, animations: {
                self.bottomConstant.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func didTapProject(_ sender: Any) {
        delegate?.didTapSelectProject()
    }
    
    func reset() {
        taskContent.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let destination = segue.destination as? ToolbarViewController else { return }
        
        _ = destination.view
        
        destination.selectProject.addTarget(self, action: #selector(didTapSelectProject), for: .touchUpInside)
        destination.selectProject.reactive.title <~ projectName

        destination.createTask.isEnabled = false
        destination.createTask.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        destination.createTask.reactive.isEnabled <~ taskContent.reactive.continuousTextValues.map { !($0 ?? "").isEmpty }
        
        tint.producer.observe(on: UIScheduler()).startWithValues { color in
            destination.view.backgroundColor = color

            let tintColor: UIColor = color.isDark ? .white : .black
            destination.createTask.tintColor = tintColor
            destination.selectProject.tintColor = tintColor
        }
    }
    
    @objc func didTapSelectProject() {
        delegate?.didTapSelectProject()
    }
    
    @objc func didTapCreate() {
        delegate?.didTapCreate()
    }

}
