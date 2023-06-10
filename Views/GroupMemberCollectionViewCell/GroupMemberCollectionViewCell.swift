//
//  GroupMemberCollectionViewCell.swift
//  SmartMoney
//
//  Created by Shuyao Li on 9/6/23.
//

import UIKit

class GroupMemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "GroupMemberCollectionViewCell", bundle: nil)
    }
    
    public func configure(_ name: String) {
        nameLabel!.text = name
    }
}
