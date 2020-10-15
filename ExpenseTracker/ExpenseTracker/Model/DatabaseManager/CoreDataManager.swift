//
//  CoreDataManager.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/15/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import CoreData


class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    // Create a singleton
    private init() {
    }
    
    private var dateFormatter: DateFormatter = {
        let dateF = DateFormatter()
        dateF.dateFormat = "MM/dd/yyyy"
        return dateF
    }()
    
    var startOfCurrentMonth: Date {
        let startDate = Date()
        let components = NSCalendar.current.dateComponents([.year, .month], from: startDate)
        let startOfMonth = NSCalendar.current.date(from: components)!
        return startOfMonth
    }
    
    public func fetchTransactions() -> [Transaction] {
        var transactions : [Transaction] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return transactions
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
            transactions = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        return transactions
    }
    
    
    func save(_ value: String,_ note: String,_ date: String,_ category: Category?,_ type: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let transaction = Transaction(context: managedContext)
        
        
        transaction.amount = Double(value)!
        transaction.note = note
        transaction.date = dateFormatter.date(from: date)
        transaction.type = type
        transaction.categoryId = category
        
        do {
            try managedContext.save()
            print("Succcesfully saved data.")
        } catch {
            debugPrint("Could not save transaction.")
        }
        
    }
    
    public func fetchCategories() -> [Category] {
        var categories: [Category] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return categories
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            categories = try managedContext.fetch(fetchRequest)
            print("Successfully fetched categories.")
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        return categories
    }
    
    private func addNewCategory(title: String)  {
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
            print("Category item added.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
