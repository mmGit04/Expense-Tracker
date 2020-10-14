//
//  SectionHeaderView.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/12/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    public let date = UILabel()
    public let sumIncome = UILabel()
    public let sumExpense = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContents() {
        date.translatesAutoresizingMaskIntoConstraints = false
        sumIncome.translatesAutoresizingMaskIntoConstraints = false
        sumExpense.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(date)
        contentView.addSubview(sumIncome)
        contentView.addSubview(sumExpense)
        
        // self.contentView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0.3725490196, alpha: 0.9)
        // Setup date label
        NSLayoutConstraint.activate([
            date.heightAnchor.constraint(equalToConstant: 30),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            date.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        
        // Setup sumExpense label
        
        NSLayoutConstraint.activate([
            sumExpense.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            sumExpense.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        
        // Setup sumIncome label
        NSLayoutConstraint.activate([
            sumIncome.trailingAnchor.constraint(equalTo: sumExpense.leadingAnchor, constant: -20),
            sumIncome.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    public func setupHeaderDetails(dateValue: String, sectionIncome: Double, sectionExpense: Double) {
        date.text = dateValue
        sumIncome.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        sumIncome.text = "$ \(sectionIncome)"
        sumExpense.textColor = #colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0.3725490196, alpha: 1)
        sumExpense.text = "$ \(sectionExpense)"
    }
}
