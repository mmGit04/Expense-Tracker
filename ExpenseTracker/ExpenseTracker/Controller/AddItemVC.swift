//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/6/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import CoreData

class AddItemVC: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    @IBOutlet weak var noteTxtField: UITextField!
    @IBOutlet weak var amountTxtField: UITextField!
    
    @IBOutlet weak var dateTxtField: UITextField!
    
    // Variables
    private var datePicker: UIDatePicker?
    private var dateFormatter: DateFormatter = {
        let dateF = DateFormatter()
        dateF.dateFormat = "MM/dd/yyyy"
        return dateF
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        setupDateField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noteTxtField.text = nil
        amountTxtField.text = nil
        dateTxtField.text = dateFormatter.string(from: Date())
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
    
        transaction.amount = Double(value)!
        transaction.note = noteTxtField.text
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
}

