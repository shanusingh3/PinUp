//
//  AutoSuggestionProtocol.swift
//  PinUp
//
//  Created by Shanu Singh on 16/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation


protocol AutoSuggestionListProtocol{
    func addNewEntry(name: String)
    func removeLastEntry()
    func entryCount() -> Int?
    func getAllEntries() -> [String]?
}


