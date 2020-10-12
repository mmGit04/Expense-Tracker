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

        NSLayoutConstraint.activate([
        date.heightAnchor.constraint(equalToConstant: 30),
        date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        date.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        
    }
   
    public func setupHeaderDetails(dateValue: String) {
        date.text = dateValue
        
    }
}
