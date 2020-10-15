//
//  ChartVC.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/14/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ChartVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var pieChartView: PieChartView!
    
    // Variables
    var categoryTransactions: [Category: [Transaction]] = [:]
    var startOfCurrentMonth: Date {
        let startDate = Date()
        let components = NSCalendar.current.dateComponents([.year, .month], from: startDate)
        let startOfMonth = NSCalendar.current.date(from: components)!
        return startOfMonth
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchTransactionsByCategory()
        setupChartData()
    }
    
    
    func setupChartData() {
        var dataEntries: [ChartDataEntry] = []
        for category in categoryTransactions.keys {
            let sum = sumOfTransactionsByCategory(transactions: categoryTransactions[category]!)
            if sum != 0.0 {
                let dataEntry = PieChartDataEntry(value: sum, label: category.title, data: category.title as AnyObject)
             dataEntries.append(dataEntry)
            }
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = generateRandomColors(numbersOfColor: categoryTransactions.count)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)

        pieChartView.data = pieChartData
        print("Success")
    }
    
    private func generateRandomColors(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
           let red = Double(arc4random_uniform(256))
           let green = Double(arc4random_uniform(256))
           let blue = Double(arc4random_uniform(256))
           let color = UIColor(red: CGFloat(red/255), green:   CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
           colors.append(color)
        }
        return colors
    }
    
    func sumOfTransactionsByCategory(transactions: [Transaction]) -> Double {
        var sum = 0.0
        for transaction in transactions {
            if transaction.type == TransactionType.income.rawValue {
                sum += transaction.amount
            }
        }
        return sum
    }
    
    // MARK: Core Data methods
    private func fetchTransactionsByCategory() {
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
            sortTransactionByCategory(for: transactions)
            print("Successfully fetched data.")
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
    }
    
    func sortTransactionByCategory(for transactions: [Transaction]) {
        categoryTransactions = [:]
        // Setup categoryTransactions
        for trans in transactions {
            let category = trans.categoryId
            if let cat = category {
                if categoryTransactions[cat] != nil {
                    categoryTransactions[cat]?.append(contentsOf: [trans])
                } else {
                    categoryTransactions[cat] = [trans]
                }
            }
        }
    }
    
}
