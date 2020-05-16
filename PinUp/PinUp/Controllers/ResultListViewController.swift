//
//  ResultListViewController.swift
//  PinUp
//
//  Created by Shanu Singh on 15/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation


import Foundation
import UIKit
import SDWebImage


protocol NoRecordFound {
    func showDailougeBox(message: String)
}

protocol ResultFetchProtocol {
    //To get the 1st Page.
    func getCurrentPage(query: String)
    //To get the lastPage + 1 i.e next page.
    func getNextPage(query:String, page: Int)
}


class ResultListViewController: UIViewController{
    
    @IBOutlet weak var searchResultImageCollectionView: UICollectionView!
    
    var pageNumber : Int = 1 //Track the current page number
    
    var isWaiting : Bool = false //To get the current fetching request.
    
    //Getting the search bar text from this c
    var searchQueryString : String?{
        didSet{
            if let text = searchQueryString{
                getCurrentPage(query: text)
            }
        }
    }
    //Images Array to hold the return data and display it in CollectionView
    var imagesArray : PixabayModal?{
        didSet{
            if imagesArray != nil{
                DispatchQueue.main.async {
                    //Once data is added, it will refersh the collectionview.
                    self.searchResultImageCollectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //CollectionView FlowLayout is added progrmatically to avoid the bug that automatically adjust the imageSize and contentView while scrolling the collection View.
        let verticalFlowLayout = UICollectionViewFlowLayout()
        verticalFlowLayout.scrollDirection = .vertical
        verticalFlowLayout.minimumLineSpacing = 60
        verticalFlowLayout.minimumInteritemSpacing = 34
        verticalFlowLayout.sectionInset.left = 30
        verticalFlowLayout.sectionInset.right = 30
        verticalFlowLayout.sectionInset.top = 30
        searchResultImageCollectionView.collectionViewLayout = verticalFlowLayout
        
    }
    
}


extension ResultListViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray?.hits.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ImageCellIdentifier, for: indexPath) as! ImageResultCell
        
        cell.backgroundColor = .lightGray
        cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if let imagesName = imagesArray?.hits[indexPath.row].webformatURL{
            cell.imageView.sd_setImage(with: Foundation.URL(string: imagesName), placeholderImage: UIImage(named: "placeholdersImage"), completed: { (image, error, cacheType, url) in
                if let image = image {
                    cell.imageView.image = image
                }
            })
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("itemSelected \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let columns :CGFloat = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columns - 1)
        let sectionInset = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let adjustWidth = collectionViewWidth - spaceBetweenCells - sectionInset
        let width :CGFloat = floor(adjustWidth / columns)
        let height : CGFloat = 180
        return CGSize(width: width,height: height)
    }
    //This function is used for pagination purpose. Here when collection view is reached at the end of the screen, then the getNextPage() will get called and new page data is appened in the current variable.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == searchResultImageCollectionView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isWaiting{
                    isWaiting = true
                    self.pageNumber += 1
                    if let text = searchQueryString{
                        self.getNextPage(query: text, page: pageNumber)
                    }
                }
            }
        }
    }
    
}

extension ResultListViewController : NoRecordFound{
    func showDailougeBox(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OKAY", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension ResultListViewController : ResultFetchProtocol{
    
    //This method is fetching the current page which is 1st based on the user query provided in the search bar.
    func getCurrentPage(query: String) {
        let pixa = PixabayServices()
        pixa.getImageBy(name: query, page: 1) { [weak self](images, error) in
            if (images?.hits.count)! > 0{
                self?.imagesArray = images
                //Here Only Successfully Query Will get Saved to show on SuggestionList.
                CoreDataManager.shared.saveLatestSuccessQuery(query:query)
            }else{
                self?.showDailougeBox(message: "Image not available. Try with another name.")
            }
        }
    }
    //This method is taking the query and the currentPage + 1 to fetch the next page once reached at the end of the screen and appending the items in the current array instead of replacing it.
    func getNextPage(query: String, page: Int) {
        let pixa = PixabayServices()
        pixa.getImageBy(name: query, page: pageNumber) { [weak self](images, error) in
            self?.imagesArray?.hits.append(contentsOf: images!.hits)
        }
        self.isWaiting = false
    }
}
