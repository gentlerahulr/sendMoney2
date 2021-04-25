//
//  SkeletonViewLanding.swift
//  SBC
//

import UIKit

class SkeletonViewLanding: UITableViewCell {
    
    static let nib = String(describing: SkeletonViewLanding.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.showSkeleton()
    }
}
