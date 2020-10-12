//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/6/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import CoreData

class AddItemVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
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
        setupDateField()
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        myView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteTxtField.text = nil
        amountTxtField.text = nil
        dateTxtField.text = dateFormatter.string(from: Date())
        fetchCategories()
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
        save()
        tabBarController?.selectedIndex = 0
    }
    
    func save() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let transaction = Transaction(context: managedContext)
        
        guard let value = amountTxtField.text, amountTxtField.text != "" else  {
            return
        }
        
        guard let note = noteTxtField.text, noteTxtField.text != "" else  {
            return
        }
        
        transaction.amount = Double(value)!
        transaction.note = note
        transaction.date = dateFormatter.date(from: dateTxtField!.text!)
        
        
        if typeSegControl.selectedSegmentIndex == 0 {
            transaction.type = TransactionType.income.rawValue
        } else {
            transaction.type = TransactionType.expense.rawValue
        }
        do {
            try managedContext.save()
            print("Succcesfully saved data.")
        } catch {
            debugPrint("Could not save transaction.")
        }
        
    }
    
    // MARK: Collection View Data Source and Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {
            cell.setupCategory(title: categories[indexPath.row].title!)
            if let _ = selectedCategory, selectedCategory == categories[indexPath.row] {
                cell.titleLbl.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            }
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
    }

    
  
    
    // MARK: Core Data functions
    
    private func fetchCategories() {
        categories.removeAll()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            categories = try managedContext.fetch(fetchRequest)
            print("Successfully fetched categories.")
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
    }
    
    private func addNewCategory(title: String) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let entity =
          NSEntityDescription.entity(forEntityName: "Category",
                                     in: managedContext)!
        
        let category = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        category.setValue(title, forKeyPath: "title")
        
        do {
          try managedContext.save()
          categories.append(category as! Category)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

