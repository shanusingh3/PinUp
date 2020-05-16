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


protocol ShowHideTableViewProtocol {
    func showSuggestionList()
    func hideSuggestionList()
}

extension SearchViewController: ShowHideTableViewProtocol{
    //To show the TableView according to the user behaviour.
    func showSuggestionList() {
        self.searchQueryTableView.isHidden = false
    }
    //To hide the TableView according to the user behaviour.
    func hideSuggestionList() {
        self.searchQueryTableView.isHidden = true
    }
}

extension SearchViewController : NoRecordFound{
    func showDailougeBox(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OKAY", style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

class SearchViewController: UIViewController{
    
    @IBOutlet weak var searchQueryTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var searchText : String?{
        didSet{
            if searchText != nil{
                performSegue(withIdentifier: Constants.ResultControllerSegue, sender: self) //Perform Segue When User Press Search Button on the keyboard.
            }
        }
    }
    
    var autoSuggestionArray: [String] = [] {
        didSet{
            self.searchQueryTableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        hideSuggestionList()
        
        CoreDataManager.shared.getAllEntries { [weak self](suggestionList) in
            if let suggestionList = suggestionList{
                if suggestionList.count == 0{
                    self?.showDailougeBox(message: "Top 10 search will get saved, and I forgot to add a delete button.")
                }else{
                    self?.autoSuggestionArray = suggestionList
                }
            }else{
                self?.showDailougeBox(message: "Something Went Wrong")
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.ResultControllerSegue{
            if let resultVC = segue.destination as? ResultListViewController{
                resultVC.searchQueryString = searchText
            }
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension SearchViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText != ""){
            hideSuggestionList()
            print(searchText)
        }else{
            showSuggestionList()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            self.searchText = text
        }
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSuggestionList()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        showSuggestionList()
    }
}


extension SearchViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.QueryCellIdentifier, for: indexPath)
        cell.textLabel?.text = autoSuggestionArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchText = autoSuggestionArray[indexPath.row]
    }
}
