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

class CoreDataManager {
    static let shared = CoreDataManager()
}

extension CoreDataManager : CoreDataErrorProtocol{
    func showErrorMessage(erroeMessage: String) {
        print("Core Data Error:")
    }
}


extension CoreDataManager: SaveProtocol{
    func saveLatestSuccessQuery(query: String) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let userEntity = NSEntityDescription.entity(forEntityName: Constants.AutoSuggestionEntity, in: managedContext)!
            let entityObject = NSManagedObject(entity: userEntity, insertInto: managedContext)
            entityObject.setValue(query, forKeyPath: "query")
            let date = Date.init()
            entityObject.setValue(date, forKeyPath: "timestamp")
            do {
                try managedContext.save()
                print("SAVED IN COREDATA")
            } catch let error as NSError {
                self.showErrorMessage(erroeMessage: "Could not save: \(error.userInfo)")
            }
        }
        
    }
}


extension CoreDataManager : CountProtocol{
    
    func countTotalItemsInEntity() -> Int? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.AutoSuggestionEntity)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            let count = try managedContext.count(for: fetchRequest)
            return count
        } catch {
            showErrorMessage(erroeMessage: "Could not Count: \(error.localizedDescription)")
            return nil
        }
    }
    
    
}

extension CoreDataManager : DeleteProtocol{
    func deleteLastFromList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.AutoSuggestionEntity)
        do
        {
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 9{
                let objectToDelete = result[9] as! NSManagedObject
                managedContext.delete(objectToDelete)
            }
            do{
                try managedContext.save()
            }
            catch
            {
                showErrorMessage(erroeMessage: "Could not delete: \(error.localizedDescription)")
            }
            
        }
        catch
        {
            showErrorMessage(erroeMessage: "\(error.localizedDescription)")
        }
    }
}

extension CoreDataManager : FetchProtocol{
    
    func getAllEntries(completion: @escaping ([String]?) -> ()) {
        var tempArray :[String] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.AutoSuggestionEntity)
        let sortDescriptor = [NSSortDescriptor.init(key: "timestamp", ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptor
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                tempArray.append(data.value(forKey: "query") as! String)
            }
            completion(tempArray)
        } catch {
            showErrorMessage(erroeMessage: "\(error.localizedDescription)")
            completion(nil)
        }
    }
    
    
}
