import Foundation
import UIKit

final class TimeLineCell: UITableViewCell {
    static var toString: String {
            return String(describing: self)
        }
    static let id = TimeLineCell.toString
    static func nib() -> UINib {
        return UINib(nibName: TimeLineCell.toString, bundle: nil)
    }
    var icon: UIImageView!
    var nameLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        icon = UIImageView()
        icon.clipsToBounds = true
        contentView.addSubview(icon)
        nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = CGRect(
            x: 15,
            y: 15,
            width: 45,
            height: 45
        )
        icon.layer.cornerRadius = icon.frame.size.width / 2
        
        nameLabel.frame = CGRect(
            x: icon.frame.maxX + 15,
            y: icon.frame.origin.y,
            width: contentView.frame.width - icon.frame.maxX - 15 * 2,
            height: 15
        )
    }
}
