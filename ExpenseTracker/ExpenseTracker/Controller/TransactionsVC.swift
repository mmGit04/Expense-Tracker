//
//  TransactionsVC.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/6/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class TransactionsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Outlets
    @IBOutlet weak var currentBalanceLbl: UILabel!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var expenseLbl: UILabel!
    @IBOutlet weak var currentDateLbl: UILabel!
    @IBOutlet weak var transTableView: UITableView!
    
    // Variables
    private var sortedTransactions: [Int:[Transaction]] = [:]
    private var keyArray: [Int] = []
    
    
    // View Controller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transTableView.delegate = self
        transTableView.dataSource = self
        transTableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        transTableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchSortedTransactions()
        setupTopBarInfo()
        transTableView.reloadData()
    }
    
    
    private func fetchSortedTransactions() {
        let transactions = CoreDataManager.instance.fetchTransactions()
        sortTransactions(transactions)
    }
    
    // Sort transactions
    private func sortTransactions(_ transactions: [Transaction]) {
        // Empty out the variables
        keyArray = []
        sortedTransactions = [:]
        
        // Setup sortedTransactions
        for trans in transactions {
            let dayComponent = NSCalendar.current.dateComponents([.day], from: trans.date!)
            if let day = dayComponent.day {
                if sortedTransactions[day] != nil {
                    sortedTransactions[day]!.append(contentsOf: [trans])
                } else {
                    sortedTransactions[day] = [trans]
                }
            }
        }
        // Setup keyArray
        for key in sortedTransactions.keys {
            keyArray.append(Int(key))
        }
        keyArray.sort(by: >)
    }
    
    @IBAction func changeMonthArrowPressed(_ sender: UIButton) {
        var currentMonthDate = CoreDataManager.instance.startOfCurrentMonth
        var dateComponent = DateComponents()
        switch sender.tag {
        case 0:
            dateComponent.month = -1
        case 1:
            dateComponent.month = 1
        default:
            print("Wrong tag value")
        }
        CoreDataManager.instance.startOfCurrentMonth = Calendar.current.date(byAdding: dateComponent, to: currentMonthDate)!
        
        // Refresh the UIView
        fetchSortedTransactions()
        setupTopBarInfo()
        transTableView.reloadData()
    }
    
    
    // MARK: Setup View
    private func setupTopBarInfo() {
        var income = 0.0
        var expense = 0.0
        for day in sortedTransactions.keys {
            for t in sortedTransactions[day]! {
                if t.type == TransactionType.income.rawValue {
                    income += t.amount
                } else {
                    expense += t.amount
                }
            }
        }
        incomeLbl.text = "$ \(income)"
        expenseLbl.text = "$ \(expense)"
        currentBalanceLbl.text = String(income - expense)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy."
        
        let date = dateFormatter.string(from: CoreDataManager.instance.startOfCurrentMonth)
        currentDateLbl.text = date
    }
    
    // MARK: Table Data Source and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTransactions[keyArray[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transTableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionCell
        let transactions = sortedTransactions[keyArray[indexPath.section]]!
        let transaction = transactions[indexPath.row]
        cell.setupCell(amount: transaction.amount, note: transaction.note, type: TransactionType.init(rawValue: transaction.type!)!, category: transaction.categoryId?.title ?? "")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = transTableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! SectionHeaderView
        let sumIncome = getSumForSection(for: section, type: TransactionType.income)
        let sumExpense = getSumForSection(for: section, type: TransactionType.expense)
        headerView.setupHeaderDetails(dateValue: getDateForSection(for: section),sectionIncome: sumIncome, sectionExpense: sumExpense )
        return headerView
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keyArray.count
    }
    
    // MARK: Helpers
    private func getDateForSection(for section: Int) -> String {
        var dateComp = DateComponents()
        dateComp.day = keyArray[section]
        let dateSection = NSCalendar.current.date(byAdding: dateComp, to: CoreDataManager.instance.startOfCurrentMonth)!
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: dateSection)
    }
    
    private func getSumForSection(for section: Int, type: TransactionType) -> Double {
        let dateKey = keyArray[section]
        var sum = 0.0
        if let transactions = sortedTransactions[dateKey] {
            for transaction in transactions {
                if transaction.type == type.rawValue {
                    sum += transaction.amount
                }
            }
        }
        return sum
    }
    
    //
    ////     Implement the footer for section devision
    //        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //            return CGFloat(integerLiteral: 15)
    //        }
    //
    //        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //            footerView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.2)
    //            return footerView
    //        }
    //
    
    
}
