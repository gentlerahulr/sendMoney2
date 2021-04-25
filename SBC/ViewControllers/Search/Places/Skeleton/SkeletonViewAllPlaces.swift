//
//  SkeletonViewAllPlaces.swift
//  SBC
//

import UIKit

class SkeletonViewAllPlaces: UITableViewCell {
    
    static let nib = String(describing: SkeletonViewAllPlaces.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.showSkeleton()
    }
}
