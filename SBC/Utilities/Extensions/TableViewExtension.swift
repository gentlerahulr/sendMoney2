//
//  TableViewExtension.swift
//  iOSBoilerPlate
//

import Foundation
import UIKit

protocol NibLoadableView: class { }
 
extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
        // notice the new describing here
        // now only one place to refactor if describing is removed in the future
        return String(describing: self)
    }
}
 
// Now all UITableViewCells have the nibName variable
// you can also apply this to UICollectionViewCells if you have those
// Note that if you have some cells that DO NOT load from a Nib vs some that do,
// extend the cells individually vs all of them as below!
// In my project, all cells load from a Nib.
extension UITableViewCell: NibLoadableView { }

protocol ReusableView: class {}
 
extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
 
extension UITableViewCell: ReusableView { }

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UITableView {
    
    func showEmptyStateView(_ view: UIView) {
        view.frame = CGRect.zero
        self.backgroundView = view
        self.separatorStyle = .none
    }
    
    func removeEmptyState() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
