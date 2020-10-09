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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transTableView.delegate = self
        transTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        
        // Define startOfMonth
        let startDate = Date()
        let components = NSCalendar.current.dateComponents([.year, .month], from: startDate)
        let startOfMonth = NSCalendar.current.date(from: components)!
        
        // Define endOfMonth
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = NSCalendar.current.date(byAdding: comps2, to: startOfMonth)!
        
        
        let datePredicate = NSPredicate(format: "date >=%@ && date <= %@", startOfMonth as NSDate, endOfMonth as NSDate )
        
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
            cell.setupCell(amount: transaction.amount, note: transaction.note, type: TransactionType.init(rawValue: transaction.type!)!)
            return cell
            
        }
         return UITableViewCell()
     }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section Header"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
          return keyArray.count
    }
}
