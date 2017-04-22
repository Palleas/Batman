import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

protocol CreateViewControllerDelegate: class {
    func didTapSelectProject()
    func didReleaseToSave()
}

final class CreateViewController: UIViewController {

    enum State {
        case normal
        case saving
        case saved
        
        var title: String {
            switch self {
            case .normal: return "Pull to save"
            case .saving: return "Saving..."
            case .saved: return "Saved!"
            }
        }
    }
    
    static let alphaThreshold = CGFloat(100)
    static let savingThreshold = CGFloat(150)
    
    weak var delegate: CreateViewControllerDelegate?
    
    let taskContent: UITextView = TaskTextView()
    
    @IBOutlet weak var projectButton: UIButton!
    @IBOutlet weak var pullToSaveLabel: UILabel! { didSet { pullToSaveLabel.alpha = 0 } }

    let currentState = MutableProperty<State>(.normal)
    
    fileprivate let currentOffsetY = MutableProperty<CGFloat>(0)
    
    override func loadView() {
        super.loadView()
        
        view.insertSubview(taskContent, at: 0)

        taskContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskContent.topAnchor.constraint(equalTo: view.topAnchor),
            taskContent.leftAnchor.constraint(equalTo: view.leftAnchor),
            taskContent.rightAnchor.constraint(equalTo: view.rightAnchor),
            taskContent.bottomAnchor.constraint(equalTo: projectButton.topAnchor, constant: -2)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (taskContent as UIScrollView).delegate = self
        taskContent.isUserInteractionEnabled = true
        taskContent.alwaysBounceVertical = true
        automaticallyAdjustsScrollViewInsets = false
        
        let labelProducer: SignalProducer<String, NoError> = SignalProducer.combineLatest(currentState.producer, currentOffsetY.producer).map { state, offset in
            if abs(offset) >= CreateViewController.savingThreshold {
                return "Release to save"
            }
            
            return state.title
        }
        
        pullToSaveLabel.reactive.text <~ labelProducer
    }
    
    @IBAction func didTapProject(_ sender: Any) {
        delegate?.didTapSelectProject()
    }
}

extension CreateViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentOffsetY.swap(scrollView.contentOffset.y)
        
        pullToSaveLabel.alpha = min(abs(scrollView.contentOffset.y), CreateViewController.alphaThreshold) / CreateViewController.alphaThreshold
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if abs(scrollView.contentOffset.y) >= CreateViewController.savingThreshold {
            delegate?.didReleaseToSave()
        }
    }
}
