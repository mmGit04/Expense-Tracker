//
//  TransactionsVC.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/6/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import CoreData

class TransactionsVC: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var currentBalanceLbl: UILabel!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var expenseLbl: UILabel!
    
    var transactions: [Transaction] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupTopBarInfo()
    }
    
    
    func setupTopBarInfo() {
        fetchTransactions()
        var income = 0.0
        var expense = 0.0
        for t in transactions {
            if t.type == TransactionType.income.rawValue {
                income += t.amount
            } else {
                expense += t.amount
            }
        }
        incomeLbl.text = "$" + String(format: "%.2f", income)
        expenseLbl.text = "$" + String(format: "%.2f", expense)
        currentBalanceLbl.text = String(format: "%.2f", income - expense)
    }
    
    
    func fetchTransactions() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        
        do {
            transactions = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
    }
}
