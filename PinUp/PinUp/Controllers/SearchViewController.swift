//
//  SearchViewController.swift
//  PinUp
//
//  Created by Shanu Singh on 14/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class SearchViewController: UIViewController{
    
    @IBOutlet weak var searchQueryTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchText : String?{
        didSet{
            performSegue(withIdentifier: "resultSegue", sender: self)
        }
    }
    
    var autoSuggestionArray: [String] = [] {
        didSet{
            self.searchQueryTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        autoSuggestionArray = AutoSuggestionCD.shared.getAllEntries()!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue"{
            if let resultVC = segue.destination as? ResultListViewController{
                resultVC.searchQueryString = searchText
            }
        }
    }
}

extension SearchViewController : UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText != ""){
            print(searchText)
        }else{
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SEARCH BUTTON CLICKED")
        if let text = searchBar.text{
            self.searchText = text
        }
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("FINISH")
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("START")
        return true
    }
}


extension SearchViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoSuggestionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.QueryCellIdentifier, for: indexPath)
        cell.textLabel?.text = autoSuggestionArray[indexPath.row]
        return cell
    }
    
    
}
