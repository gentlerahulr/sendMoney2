//
//  NavigationController.swift
//  SBC
//

import UIKit

///Use this class as parent controller for navigation
class NavigationController: UIViewController {
    
    let backButton = UIButton(type: .custom)
    let rightButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarColor()
    }
    
    /// This fucntion is used to set Color for Navigation bar
    func setNavigationBarColor() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    /// This function is used to set title color and font for Navigation bar
    /// - Parameters:
    ///   - colorCode: color code
    ///   - fontName: font name
    ///   - size: font size
    func setNavBarTitleColor(colorCode: String, fontName: String, size: CGFloat) {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: fontName, size: size)!, NSAttributedString.Key.foregroundColor: UIColor.getUIColorFromHexCode(colorCode: colorCode, alpha: 1.0)]
    }
    
    /// This fucntion is used to set left button for navigation bar
    /// - Parameter image: image passed from controller
    func showLeftBarButtonWithImage(image: String) {
        navigationItem.leftBarButtonItems = [constructBackBtnForNavBar(imageName: image)]
    }
    
    /// This function is used to set right button for navigation bar
    /// - Parameter image: image passed from controller
    func showRightBarButton(image: String) {
        navigationItem.rightBarButtonItems = [configureRightButtonWithImage(imageName: image)]
    }
    
    /// This function is used to show/hide bar buttons for navigation bar
    func shouldHideBarBtnItem(isHidden: Bool) {
        self.navigationItem.rightBarButtonItem?.customView?.isHidden = isHidden
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = isHidden
    }
    
    /// This function is used to set title for navigation bar
    /// - Parameter title: title
    func setTitle(title: String) {
        self.navigationController?.navigationBar.topItem?.title = title
    }
    
    /// This function is used to set title for navigation bar
    /// - Parameter title: title
    func setBarHidden(status: Bool) {
        self.navigationController?.setNavigationBarHidden(status, animated: true)
    }
    
    //This function is used to configure back button on navigation bar
    func constructBackBtnForNavBar(imageName: String) -> UIBarButtonItem {
        backButton.addTarget(self, action: #selector(leftBarButtonPressed), for: .touchUpInside)
        backButton.setImage(UIImage.init(named: imageName), for: .normal)
        backButton.setImage(UIImage.init(named: imageName), for: .highlighted)
        backButton.clipsToBounds = true
        //Add back button to navigationBar as left Button
        let myCustomBackButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        return myCustomBackButtonItem
    }
    
    /// This function is used to configure right button on navigation bar
    /// - Parameter imageName: image paased from controller
    /// - Returns: UIBar button
    func configureRightButtonWithImage(imageName: String) -> UIBarButtonItem {
        
        rightButton.addTarget(self, action: #selector(rightBtnPressed), for: .touchUpInside)
        rightButton.setImage(UIImage.init(named: imageName), for: .normal)
        rightButton.setImage(UIImage.init(named: imageName), for: .highlighted)
        let barButton = UIBarButtonItem(customView: rightButton)
        return barButton
    }
    
    @objc func rightBtnPressed(sender: UIButton) {
        ///Method to be override in subclass
    }
    
    @objc func leftBarButtonPressed(sender: UIButton) {
        ///Method to be override in subclass
    }
    
    ///This function is used to push viewcontroller
    func push(viewController: UIViewController, animation: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animation)
    }
    
    ///This function is used to pop view controller
    func popVC(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
}
