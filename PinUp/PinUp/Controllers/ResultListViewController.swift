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

class ResultListViewController: UIViewController{
    
    
    @IBOutlet weak var searchResultImageCollectionView: UICollectionView!
    
    
    var currentArray : [String] = []{
        didSet{
            self.searchResultImageCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
}


extension ResultListViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ImageCellIdentifier, for: indexPath) as! ImageResultCell
        
        cell.backgroundColor = .red
        cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        cell.imageView.sd_setImage(with: Foundation.URL(string:""), placeholderImage: UIImage(named: "placeholdersImage"), completed: { (image, error, cacheType, url) in
//            if let image = image {
//                cell.imageView.image = image
//            }
       // })
        
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
        let height : CGFloat = 210
        return CGSize(width: width,height: height)
    }
}
