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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
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
}


extension SearchViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.QueryCellIdentifier, for: indexPath)
        cell.textLabel?.text = "SHANU SINGH"
        return cell
    }
    
    
}
