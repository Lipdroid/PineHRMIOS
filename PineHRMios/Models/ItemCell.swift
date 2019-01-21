//
//  ItemCell.swift
//  PineHRMios
//
//  Created by Md Munir Hossain on 1/21/19.
//  Copyright © 2019 Md Munir Hossain. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var itemObject: ItemObject!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configureCell(_ item: ItemObject){
        self.itemObject = item
        thumbImage.image = UIImage(named: "\(self.itemObject.icon)")
        nameLabel.text = self.itemObject.name.capitalized
    }
}
