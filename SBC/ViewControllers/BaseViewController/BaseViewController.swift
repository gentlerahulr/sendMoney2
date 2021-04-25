//
//  BaseViewController.swift
//  SBC
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

var topViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIDevice.current.hasNotch ? 94 : 74)

class BaseViewController: UIViewController, CustomTopViewDelegate {
    private var baseViewModel: BaseViewModel = BaseViewModel()
    lazy var IBViewTop: NPCustomTopView = NPCustomTopView()
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupViewModel()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewModel()
    }
    
    func setupViewModel() {
        //Need to override in child class
    }
    
    //------------------------------------------------------------------
    // MARK: UIView Life Cycle Method
    //------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopUI()
    }
    
    //------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if disablesAutomaticKeyboardHandling {
            IQKeyboardManager.shared.enable = false
        }
    }
    
    //------------------------------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if disablesAutomaticKeyboardHandling {
            IQKeyboardManager.shared.enable = true
        }
    }
    
    //------------------------------------------------------------------
    // MARK: UI Setup
    //------------------------------------------------------------------

    var disablesAutomaticKeyboardHandling: Bool = false {
        willSet {
            if disablesAutomaticKeyboardHandling && viewIfLoaded?.window != nil {
                IQKeyboardManager.shared.enable = false
            }
        }
    }

    func showScreenTitle(screenTitle: String?, screenTitleFont: UIFont? = UIFont.boldFontWithSize(size: 16), screenTitleColor: String? = nil, headerBGColor: UIColor? = nil) {
        let navigationTitleColor = screenTitleColor ?? baseViewModel.navigationTitleColor()
        let navigationTitleFont = (screenTitleFont ?? baseViewModel.titleFont())!
        IBViewTop.showHeaderWithTitle(title: screenTitle, titleFont: navigationTitleFont, titleTextColor: UIColor(navigationTitleColor!))
        if let headerColor = headerBGColor {
            IBViewTop.backgroundColor = headerColor
        }
    }
    
    //------------------------------------------------------------------
    
    func showScreenTitleWithLeftBarButton(screenTitle: String? = nil, leftButtonImage: String = ImageConstants.IMG_BACK, screenTitleFont: UIFont? = UIFont.boldFontWithSize(size: 16), screenTitleColor: String? = nil, headerBGColor: UIColor? = nil) {
        let navigationTitleColor = screenTitleColor ?? baseViewModel.navigationTitleColor()
        let navigationTitleFont = (screenTitleFont ?? baseViewModel.titleFont())!
        IBViewTop.showHeaderWithTitle(title: screenTitle, titleFont: navigationTitleFont, titleTextColor: UIColor(navigationTitleColor!))
        
        var topBackButtonFrame = CGRect.zero
        if leftButtonImage == ImageConstants.IMG_BACK || leftButtonImage == ImageConstants.IMG_BACK_WHITE {
            topBackButtonFrame = CGRect(x: 10, y: UIDevice.current.hasNotch ? 44 : 24, width: 40, height: 50)
            
        } else {
            topBackButtonFrame = CGRect(x: 34, y: 20, width: 30, height: 30)
        }
        let leftButtonConfig = NavButtonConfig(
            font: nil,
            textColor: nil,
            backgroundColor: nil,
            borderColor: nil,
            cornerRadius: 0,
            image: UIImage(named: leftButtonImage),
            imageTintColor: UIColor(colorConfig.navigation_header_icon_color!),
            title: nil,
            frame: topBackButtonFrame
        )
        IBViewTop.showLeftButtonWithTitle(leftButtonConfig: leftButtonConfig)
        if let headerColor = headerBGColor {
            IBViewTop.backgroundColor = headerColor
        }
    }
    
    //------------------------------------------------------------------
    
    func showRightBarButton(arrOfRightButtonConfig: [NavButtonConfig]) {
        IBViewTop.showRightButtonWithTitle(arrRightButtonConfig: arrOfRightButtonConfig)
    }
    
    //------------------------------------------------------------------
    // MARK: override
    //------------------------------------------------------------------
    
    private func setupTopUI() {
        IBViewTop.delegate = self
        IBViewTop.frame = topViewFrame
        IBViewTop.backgroundColor = .clear
        self.view.addSubview(IBViewTop)
    }
    
    //------------------------------------------------------------------
    
    func showTopView() {
        IBViewTop.frame.size.height = UIDevice.current.hasNotch ? 94 : 74
    }
    
    //------------------------------------------------------------------
    
    func hideTopView() {
        IBViewTop.frame.size.height = 0
    }
    
    //------------------------------------------------------------------
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //------------------------------------------------------------------
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //------------------------------------------------------------------
    
    public func rightButtonAction(button: UIButton) {
        
    }
    
    //------------------------------------------------------------------
    
    public func leftButtonAction(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------------------
    
    //---- Check the State of the texField
    @discardableResult func applyStateOnTextfield(textfield: CustomTextfieldView, state: ValidationState, tableView: UITableView) -> ValidationState {
        switch state {
        case .valid:
            let state = textfield.textfield.isFirstResponder ? CustomTextfieldView.FieldState.editing :  CustomTextfieldView.FieldState.normal
            textfield.setState(state: state)
        case .inValid(let error):
            textfield.setState(state: CustomTextfieldView.FieldState.error)
            textfield.configureError(error: error)
        }
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        return state
    }
}
