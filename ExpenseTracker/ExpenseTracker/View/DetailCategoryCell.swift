//
//  DetailCategoryCell.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/15/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class DetailCategoryCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCategory(for title: String, amount: Double, percent: Int, color: UIColor) {
        percentLbl.layer.cornerRadius = 6
        percentLbl.layer.borderWidth = 1.0
        percentLbl.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        percentLbl.clipsToBounds = true
        titleLbl.text = title
        amountLbl.text = "$ \(amount)"
        percentLbl.text = "\(percent)%"
        percentLbl.backgroundColor = color
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
