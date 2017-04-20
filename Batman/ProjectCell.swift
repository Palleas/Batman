import UIKit

final class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var colorIndicator: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func configure(name: String, color: UIColor) {
        nameLabel.text = name
        colorIndicator.backgroundColor = color
    }
    
}
