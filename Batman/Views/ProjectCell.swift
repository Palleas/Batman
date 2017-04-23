import UIKit

final class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var colorIndicator: UIView!
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .btmProjectTitleFont()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        separatorInset = .zero
    }
    
    func configure(name: String, color: UIColor) {
        nameLabel.text = name
        colorIndicator.backgroundColor = color
    }
    
}
