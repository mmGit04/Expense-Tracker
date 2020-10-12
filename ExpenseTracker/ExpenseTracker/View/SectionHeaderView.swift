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

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContents() {
       date.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(date)
       // self.contentView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0.3725490196, alpha: 0.9)
        NSLayoutConstraint.activate([
        date.heightAnchor.constraint(equalToConstant: 30),
        date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        date.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        
    }
   
    public func setupHeaderDetails(dateValue: String) {
        date.text = dateValue
        
    }
}
