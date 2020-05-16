//
//  AutoSuggestionCD.swift
//  PinUp
//
//  Created by Shanu Singh on 16/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AutoSuggestionCD: NSObject, AutoSuggestionListProtocol {
    
    
    
    static let shared = AutoSuggestionCD()
    
    func getAllEntries() -> [String]? {
        var tempArray :[String] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AutoSuggestionList")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                tempArray.append(data.value(forKey: "query") as! String)
            }
            
        } catch {
            print("Failed")
        }
        return tempArray
    }
    
    func addNewEntry(name: String) {
        
        
        if let items = entryCount(){
            if items < 9{
                removeLastEntry()
            }else{
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let userEntity = NSEntityDescription.entity(forEntityName: "AutoSuggestionList", in: managedContext)!
                let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
                user.setValue(name, forKeyPath: "query")
                do {
                    try managedContext.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func removeLastEntry() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AutoSuggestionList")
        do
        {
            let result = try managedContext.fetch(fetchRequest)
            
            if result.count < 9{
                let objectToDelete = result[9] as! NSManagedObject
                managedContext.delete(objectToDelete)
            }
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    
    func entryCount() -> Int? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AutoSuggestionList")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0}
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            let count = try managedContext.count(for: fetchRequest)
            print(count)
        } catch {
            print(error.localizedDescription)
        }
        return 1
    }
    
}
