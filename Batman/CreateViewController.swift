import UIKit

protocol CreateViewControllerDelegate: class {
    func didTapSelectProject()
}

final class CreateViewController: UIViewController {

    weak var delegate: CreateViewControllerDelegate?
    
    @IBOutlet weak var taskContent: UITextView!
    @IBOutlet weak var projectButton: UIButton!
    @IBOutlet weak var pullToSaveLabel: UILabel! { didSet { pullToSaveLabel.alpha = 0 } }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskContent.isUserInteractionEnabled = true
        taskContent.alwaysBounceVertical = true
        automaticallyAdjustsScrollViewInsets = false
    }
    
    @IBAction func didTapProject(_ sender: Any) {
        delegate?.didTapSelectProject()
    }
}

extension CreateViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pullToSaveLabel.alpha = min(abs(scrollView.contentOffset.y), 100) / 100
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("Save ?")
    }
}
