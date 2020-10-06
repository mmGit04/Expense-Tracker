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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

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
        
        guard let value = amountTxtField.text, amountTxtField.text != nil else  {
            return
        }
        transaction.amount = Double(value)!
        transaction.note = noteTxtField.text
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

