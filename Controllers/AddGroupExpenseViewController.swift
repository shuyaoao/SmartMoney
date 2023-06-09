//
//  AddGroupExpenseViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 6/6/23.
//

import UIKit

class AddGroupExpenseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    @IBOutlet weak var whoPaidScrollView: UICollectionView!
    @IBOutlet weak var splitByWho: UICollectionView!
    
    let array = ["Dylan", "Shuyao", "Shi Han", "Bernice", "Ana", "Jiang En"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whoPaidScrollView.dataSource = self
        whoPaidScrollView.delegate = self
        splitByWho.dataSource = self
        splitByWho.delegate = self
        whoPaidScrollView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        splitByWho.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
       
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(array[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 50)
    }
}
