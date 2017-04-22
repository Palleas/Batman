import UIKit

final class ProjectsHeader: UIView {
    
    private let title: UILabel = {
        let l = UILabel()
        l.text = "Pick\nA Project".uppercased()
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.textColor = .white
        l.font = .btmProjectHeaderTitleFont()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: 25)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
