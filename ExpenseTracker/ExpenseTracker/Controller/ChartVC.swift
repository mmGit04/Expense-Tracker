//
//  ChartVC.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/14/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import Charts

class ChartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var typeSegCtrl: UISegmentedControl!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    
    // Variables
    private var categoryAmount: [Category: Double] = [:]
    private var keyArray: [Category] = []
    private var currentSetOfColors: [UIColor] = []
    private var categoryTransactions: [Category:[Transaction]] = [:]
    
    private var fullAmount: Double {
        get {
            var sum = 0.0
            for amount in categoryAmount.values {
                sum += amount
            }
            return sum
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Setup data
        fetchTransactionsByCategory()
        setupCategoryAmount()
        
        // Update view
        setupChartData()
        categoriesTableView.reloadData()
    }
    
    @IBAction func typeChanged(_ sender: UISegmentedControl) {
        setupCategoryAmount()
        
        // Update view
        setupChartData()
        categoriesTableView.reloadData()
    }
    
    private func fetchTransactionsByCategory(){
        let transactions = CoreDataManager.instance.fetchTransactions()
        sortTransactionByCategory(for: transactions)
    }
    
    
    func setupChartData() {
        pieChartView.usePercentValuesEnabled = true
        pieChartView.entryLabelColor = UIColor.black
        pieChartView.legend.enabled = false
        generateRandomColors(numbersOfColor: categoryAmount.count)
        
        var dataEntries: [ChartDataEntry] = []
        for category in categoryAmount.keys {
            let sum = categoryAmount[category]!
            if sum != 0.0 {
                let dataEntry = PieChartDataEntry(value: sum, label: category.title, data: category.title as AnyObject)
                dataEntries.append(dataEntry)
            }
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = currentSetOfColors
        // 3. Set ChartData
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        pieChartView.data = pieChartData
        print("Success")
    }
    
    private func generateRandomColors(numbersOfColor: Int) {
        currentSetOfColors = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            currentSetOfColors.append(color)
        }
    }
    
    func sumOfTransactionsByCategory(transactions: [Transaction], for type: TransactionType) -> Double {
        var sum = 0.0
        for transaction in transactions {
            if transaction.type == type.rawValue {
                sum += transaction.amount
            }
        }
        
        return sum
    }
    
    private func getPercentForAmount(amount: Double) -> Int{
        return Int((amount * 100) / fullAmount)
        
    }
    
    func setupCategoryAmount() {
        categoryAmount = [:]
        keyArray = []
        var type = TransactionType.income
        if typeSegCtrl.selectedSegmentIndex == 1 {
            type = TransactionType.expense
        }
        for cat in categoryTransactions.keys {
            let sum = sumOfTransactionsByCategory(transactions: categoryTransactions[cat]!, for: type)
            if sum != 0.0 {
                categoryAmount[cat] = sum
            }
        }
        for key in categoryAmount.keys {
            keyArray.append(key)
        }
    }
    
    func sortTransactionByCategory(for transactions: [Transaction]){
        
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
    
    // MARK: Table View data source and delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryAmount.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "DetailCategoryCell") as? DetailCategoryCell {
            let category = keyArray[indexPath.row]
            cell.setupCategory(for: category.title!, amount: categoryAmount[category]!, percent: getPercentForAmount(amount: categoryAmount[category]!), color: currentSetOfColors[indexPath.row])
            return cell
        }
        return UITableViewCell()
        
    }
}
