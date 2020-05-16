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


protocol ResultFetchProtocol {
    func getCurrentPage(query: String)
    func getNextPage(query:String, page: Int)
}


class ResultListViewController: UIViewController{
    
    @IBOutlet weak var searchResultImageCollectionView: UICollectionView!
    
    var pageNumber : Int = 1
    var isWaiting : Bool = false
    
    var searchQueryString : String?{
        didSet{
            if let text = searchQueryString{
                getCurrentPage(query: text)
            }
        }
    }
    
    var imagesArray : PixabayModal?{
        didSet{
            DispatchQueue.main.async {
                self.searchResultImageCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
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


extension ResultListViewController : ResultFetchProtocol{
    
    func getCurrentPage(query: String) {
        let pixa = PixabayServices()
        pixa.getImageBy(name: query, page: 1) { [weak self](images, error) in
            self?.imagesArray = images
        }
    }
    
    func getNextPage(query: String, page: Int) {
        let pixa = PixabayServices()
        pixa.getImageBy(name: query, page: pageNumber) { [weak self](images, error) in
            self?.imagesArray?.hits.append(contentsOf: images!.hits)
        }
        self.isWaiting = false
    }
}
