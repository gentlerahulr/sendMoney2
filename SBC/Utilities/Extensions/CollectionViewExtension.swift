//
//  FeedModel.swift
//  iOSBoilerPlate

import Foundation
import UIKit
 
// Now all UICollectionViewCells have the nibName variable
// you can also apply this to UICollectionViewCells if you have those
// Note that if you have some cells that DO NOT load from a Nib vs some that do,
// extend the cells individually vs all of them as below!
// In my project, all cells load from a Nib.
extension UICollectionViewCell: NibLoadableView { }

extension UICollectionViewCell: ReusableView { }

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ : T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
