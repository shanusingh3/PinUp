//
//  AutoSuggestionProtocol.swift
//  PinUp
//
//  Created by Shanu Singh on 16/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation


protocol CoreDataErrorProtocol {
    func showErrorMessage(erroeMessage: String)
}

//Save Data Protocol could have many save data options like save by id, save by name etc.
protocol SaveProtocol {
    func saveLatestSuccessQuery(query: String)
}

//protocol DeleteProtocol {
//    func deleteLastFromList()
//}

//protocol CountProtocol {
//    func countTotalItemsInEntity() -> Int?
//}

protocol FetchProtocol {
    func getAllEntries(completion : @escaping (_ list :[String]?) -> ())
}

