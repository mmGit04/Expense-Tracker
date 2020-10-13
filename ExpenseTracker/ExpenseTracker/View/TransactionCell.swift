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
    

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(amount: Double, note: String?, type: TransactionType, category: String) {
        amountLabel.text = "$ " + (String(format: "%.2f", amount))
        noteLabel.text = note
        categoryLabel.text = category
        if type == TransactionType.expense {
            amountLabel.textColor = #colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0.3725490196, alpha: 1)
        } else {
            amountLabel.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        }
    }
}
