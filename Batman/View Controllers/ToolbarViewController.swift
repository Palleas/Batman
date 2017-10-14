import UIKit

final class ToolbarViewController: UIViewController {

    @IBOutlet weak var createTask: UIButton!

    @IBOutlet weak var selectProject: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        view.layer.shadowColor = UIColor(hexColor: "b2b2b2").cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 0.5
    }
}
