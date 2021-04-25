//
//  LoaderViewController.swift
//  SBC

import UIKit

class LoaderViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView_Loader: UIImageView!
    @IBOutlet weak var labelLoader: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadGIF()
    }

    func loadGIF() {
        contentView.layer.cornerRadius = 20
//        let  gifImg = UIImage.gifImageWithName("gifLoader")
        let  gifImg = UIImage.gifImageWithName("ONZ_Loader_Icon")
        imageView_Loader.image = gifImg
    }
}
