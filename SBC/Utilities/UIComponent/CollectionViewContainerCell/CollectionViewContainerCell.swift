//
//  SmallVenueContainerCell.swift
//  SBC
//

import UIKit

class CollectionViewContainerCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //used to store the scroll position of the cells. This collectionview lives in a tableviewcell
    //which means that it can get recreated when the user scrolls. For this the last scroll position
    //must be known
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        set {
            collectionView.contentOffset.x = newValue
        }
    }

    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
}
