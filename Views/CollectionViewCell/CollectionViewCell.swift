//
//  CollectionViewCell.swift
//  SmartMoney
//
//  Created by Shuyao Li on 6/6/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let array = ["Dylan", "Shuyao", "Shi Han", "Bernice", "Ana", "Jiang En"]
    
    static let identifier = "CollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(_ name: String) {
        self.label.text = name
    }
}
