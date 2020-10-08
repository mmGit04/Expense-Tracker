//
//  TransactionCell.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/8/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    
    // Outlets
    
    @IBOutlet weak var noteLabel: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
