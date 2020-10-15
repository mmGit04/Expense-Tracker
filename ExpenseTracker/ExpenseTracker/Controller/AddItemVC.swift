//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/6/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    // Outlets
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    @IBOutlet weak var noteTxtField: UITextField!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    // Variables
    private var datePicker: UIDatePicker?
    private var dateFormatter: DateFormatter = {
        let dateF = DateFormatter()
        dateF.dateFormat = "MM/dd/yyyy"
        return dateF
    }()
    
    private var categories: [Category] = []
    private var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
        setupDateField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteTxtField.text = nil
        amountTxtField.text = nil
        dateTxtField.text = dateFormatter.string(from: Date())
        categories = CoreDataManager.instance.fetchCategories()
    }
    
    private func setupDateField() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTxtField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dateTapped(gestureRecognizer:)))
        view.addGestureRecognizer(dateTapGesture)
    }
    
    @objc func dateTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        dateTxtField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveItem()
        tabBarController?.selectedIndex = 0
    }
    
    private func saveItem() {
        guard let value = amountTxtField.text, amountTxtField.text != "" else  {
            return
        }
        guard let note = noteTxtField.text, noteTxtField.text != "" else  {
            return
        }
        
        let date = dateTxtField.text!
        let type: String
        if typeSegControl.selectedSegmentIndex == 0 {
            type = TransactionType.income.rawValue
        } else {
            type = TransactionType.expense.rawValue
        }
        CoreDataManager.instance.save(value, note, date, selectedCategory, type)
    }
    
    // MARK: Collection View Data Source and Delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {
            cell.setupCategory(title: categories[indexPath.row].title!)
            if let _ = selectedCategory, selectedCategory == categories[indexPath.row] {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.1482198536, green: 0.54377985, blue: 0.9333333333, alpha: 0.5)
            } else {
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("Highlighted")
        if selectedCategory == categories[indexPath.row] {
            selectedCategory = nil
        } else {
            selectedCategory = categories[indexPath.row]
        }
        categoryCollection.reloadData()
    }
}

