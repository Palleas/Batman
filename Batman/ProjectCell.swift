import UIKit

final class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var colorIndicator: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(name: String, color: UIColor) {
        nameLabel.text = name
        colorIndicator.backgroundColor = color
    }
    
}
