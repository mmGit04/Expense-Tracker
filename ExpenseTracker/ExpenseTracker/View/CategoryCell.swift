//
//  CategoryCell.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/12/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    public func setupCategory(title: String) {
        titleLabel.text = title
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
  
}
