//
//  TransactionsVC.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/6/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import CoreData

class TransactionsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Outlets
    
    @IBOutlet weak var currentBalanceLbl: UILabel!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var expenseLbl: UILabel!
    @IBOutlet weak var transTableView: UITableView!
    
    // Variables
    var sortedTransactions: [Int:[Transaction]] = [:]
    var keyArray: [Int] = []
    var startOfCurrentMonth: Date {
        let startDate = Date()
        let components = NSCalendar.current.dateComponents([.year, .month], from: startDate)
        let startOfMonth = NSCalendar.current.date(from: components)!
        return startOfMonth
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transTableView.delegate = self
        transTableView.dataSource = self
        transTableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTransactions()
        setupTopBarInfo()
        transTableView.reloadData()
    }
    
    
    func setupTopBarInfo() {
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
        
        incomeLbl.text = "$ " + String(format: "%.2f", income)
        expenseLbl.text = "$ " + String(format: "%.2f", expense)
        currentBalanceLbl.text = String(format: "%.2f", income - expense)
    }
    
    // Fetchin current's month transactions
    func fetchTransactions() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        
        
        // Define endOfMonth
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = NSCalendar.current.date(byAdding: comps2, to: startOfCurrentMonth)!
        
        
        let datePredicate = NSPredicate(format: "date >=%@ && date <= %@", startOfCurrentMonth as NSDate, endOfMonth as NSDate )
        
        fetchRequest.predicate = datePredicate
        do {
            let transactions = try managedContext.fetch(fetchRequest)
            sortTransactions(transactions: transactions)
            print("Successfully fetched data.")
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
    }
    
    // Sort transactions
    private func sortTransactions(transactions: [Transaction]) {
        // Empty out the variables
        keyArray = []
        sortedTransactions = [:]
        
        // Setup sortedTransactions
        for trans in transactions {
            let dayComponent = NSCalendar.current.dateComponents([.day], from: trans.date!)
            if let day = dayComponent.day {
                if sortedTransactions[day] != nil {
                    sortedTransactions[day]?.append(contentsOf: [trans])
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
    
    
    // MARK: Table Data Source and Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTransactions[keyArray[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = transTableView.dequeueReusableCell(withIdentifier: "transactionCell") as? TransactionCell {
            let transactions = sortedTransactions[keyArray[indexPath.section]] ?? []
            let transaction = transactions[indexPath.row]
            cell.setupCell(amount: transaction.amount, note: transaction.note, type: TransactionType.init(rawValue: transaction.type!)!, category: transaction.categoryId?.title ?? "")
            return cell
            
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = transTableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? SectionHeaderView {
            
            let sumIncome = getSumForSection(for: section, type: TransactionType.income)
            let sumExpense = getSumForSection(for: section, type: TransactionType.expense)
            headerView.setupHeaderDetails(dateValue: getDateForSection(for: section),sectionIncome: sumIncome, sectionExpense: sumExpense )
            return headerView
        }
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keyArray.count
    }
    
    // MARK: Helpers
    
    private func getDateForSection(for section: Int) -> String {
        var dateComp = DateComponents()
        dateComp.day = keyArray[section]
        let dateSection = NSCalendar.current.date(byAdding: dateComp, to: startOfCurrentMonth)!
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
    
    
    // Implement the footer for section devision
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return CGFloat(integerLiteral: 15)
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //        footerView.backgroundColor = .white
    //        return footerView
    //    }
    //
    
    
}
