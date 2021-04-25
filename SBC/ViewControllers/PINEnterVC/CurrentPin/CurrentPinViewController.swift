import UIKit

class CurrentPinViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var viewModel: CurrentPinViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPinCell()?.pinView.clearPin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupViewModel() {
        viewModel = CurrentPinViewModel()
        viewModel?.delegate = self
    }
    
    func setUpUi() {
        tableview.dataSource = self
        tableview.delegate = self
        registerNib()
        setUpHeader()
        self.tableview.contentInset = UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0)
        
    }
    
    private func setUpHeader() {
        showScreenTitleWithLeftBarButton(screenTitle: localizedStringForKey(key: "update.pin.screen.title"), leftButtonImage: ImageConstants.IMG_BACK_WHITE, screenTitleColor: colorConfig.dark_navigation_header_text_color, headerBGColor: .themeDarkBlue)
    }
    
    private func registerNib() {
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: "PinEnteryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PinEnteryTableViewCell")
    }
    
    private func getPinCell() -> PinEnteryTableViewCell? {
        return tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? PinEnteryTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PinEnteryTableViewCell", for: indexPath) as? PinEnteryTableViewCell {
            var config = PinEnteryTableViewCellConfig()
            config.strlabelTitle = localizedStringForKey(key: "update.pin.enter.current.pin.title")
            cell.configureCell(config: config)
            cell.didPinEntered = didPinEnteredVC(pin:)
            cell.lableShowError.isHidden = false
            cell.lableShowError.text = "  "
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func didPinEnteredVC(pin: String) {
        self.view.endEditing(true)
        viewModel?.callValidateCurrentPinAPI(mpinRequest: MpinRequest(mpin: pin))
    }
    
    func navigateToEnterPin() {
        let vc = EnterPinViewController.instantiateFromStoryboard(storyboardName: StoryboardName.WalletFlow, storyboardId: StoryboardId.EnterPinViewController)
        vc.viewModel?.mobileOTPType = viewModel?.mobileOTPType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CurrentPinViewController: CurrentPinDataPassingDelegate {
    func suceessHandler() {
        navigateToEnterPin()
    }
    
    func failureHandler(message: String) {
        let cell = getPinCell()
        cell?.pinView.clearPin()
        cell?.lableShowError.isHidden = false
        if message == "Invalid Mpin" {
            cell?.lableShowError.text = localizedStringForKey(key: "pin.invalid.pin.title")
        } else {
            cell?.lableShowError.text = message
        }
    }
}
