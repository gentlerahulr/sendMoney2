import UIKit

class EditTransactionNotesViewController: BaseViewController {
    private var key: String?
    private var viewModel: EditTransactionNotesViewModelProtocol?

    @IBOutlet private var inputTextView: UITextView? {
        willSet {
            newValue?.textContainerInset = .zero
            newValue?.textContainer.lineFragmentPadding = 0
        }
    }
    @IBOutlet private var labelHeadline: UILabel? {
        willSet {
            newValue?.text = localizedStringForKey(key: "Add a note to keep track of your spending")
        }
    }
    @IBOutlet private var labelTextLimit: UILabel? {
        willSet {
            newValue?.text = nil
        }
    }
    @IBOutlet private var labelErrorMessage: UILabel? {
        willSet {
            newValue?.text = nil
        }
    }
    @IBOutlet private var buttonSave: UIButton? {
        willSet {
            newValue?.setTitle(localizedStringForKey(key: "transactiondetail.edit.save"), for: .normal)
            newValue?.setButtonConfig(
                btnConfig: .getBoldButtonConfig(
                    titleText: localizedStringForKey(key: "transactiondetail.edit.save"),
                    fontSize: 16,
                    textColor: .white,
                    backgroundColor: .themeDarkBlue,
                    cornerRadius: 8
                ),
                for: .normal
            )
            newValue?.setButtonConfig(
                btnConfig: .getBoldButtonConfig(
                    titleText: localizedStringForKey(key: "transactiondetail.edit.save"),
                    fontSize: 16,
                    textColor: .themeDarkBlueTint1,
                    backgroundColor: .themeDarkBlueTint2,
                    cornerRadius: 8
                ),
                for: .disabled
            )
        }
    }
    @IBOutlet private var constraintBottom: NSLayoutConstraint?

    private var observerKeyboardWillShow: NSObjectProtocol?
    private var observerKeyboardWillHide: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        disablesAutomaticKeyboardHandling = true
        showScreenTitleWithLeftBarButton(
            screenTitle: localizedStringForKey(key: "transactiondetail.button.notes")
        )
        if let key = key {
            viewModel?.loadTransactionNotes(of: key)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observerKeyboardWillShow = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main,
            using: keyboardWillShow
        )
        observerKeyboardWillHide = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main,
            using: keyboardWillHide
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(observerKeyboardWillShow as Any)
        NotificationCenter.default.removeObserver(observerKeyboardWillHide as Any)
    }

    override func setupViewModel() {
        viewModel = EditTransactionNotesViewModel()
        viewModel?.delegate = self
    }

    func configureWith(transactionKey: String) {
        key = transactionKey
    }
}

// MARK: - Event handlers

extension EditTransactionNotesViewController {
    @IBAction private func onTapSaveButton() {
        guard let key = key else { return }
        viewModel?.saveNotes(of: key, notes: inputTextView?.text ?? "")
    }

    private func keyboardWillShow(_ noti: Notification) {
        guard
            let keyboardFrame: NSValue = noti.userInfoValue(of: UIResponder.keyboardFrameEndUserInfoKey),
            let animationDuration: NSNumber = noti.userInfoValue(of: UIResponder.keyboardAnimationDurationUserInfoKey),
            let animationCurve: NSNumber = noti.userInfoValue(of: UIResponder.keyboardAnimationCurveUserInfoKey)
        else {
            return
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: animationCurve.intValue) ?? .easeInOut)
        UIView.setAnimationDuration(animationDuration.doubleValue)
        let keyboardRelativeFrame = view.subviews[0].convert(keyboardFrame.cgRectValue, from: nil)
        let keyboardHeight = view.subviews[0].frame.height - keyboardRelativeFrame.minY
        constraintBottom?.constant = keyboardHeight
        view.layoutIfNeeded()
        UIView.commitAnimations()
    }

    private func keyboardWillHide(_ noti: Notification) {
        guard
            let animationDuration: NSNumber = noti.userInfoValue(of: UIResponder.keyboardAnimationDurationUserInfoKey),
            let animationCurve: NSNumber = noti.userInfoValue(of: UIResponder.keyboardAnimationCurveUserInfoKey)
        else {
            return
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: animationCurve.intValue) ?? .easeInOut)
        UIView.setAnimationDuration(animationDuration.doubleValue)
        constraintBottom?.constant = 0
        view.layoutIfNeeded()
        UIView.commitAnimations()
    }
}

// MARK: - EditTransactionNotesDataPassingDelegate

extension EditTransactionNotesViewController: EditTransactionNotesDataPassingDelegate {
    func loadTransactionNotesDidComplete(notes: String?, maximumCharactorCount: Int) {
        inputTextView?.text = notes
        labelTextLimit?.text = String(
            format: localizedStringForKey(key: "transactiondetail.edit.charactercount"),
            maximumCharactorCount
        )
    }

    func updateInputState(_ state: EditTransactionNotesInputState) {
        buttonSave?.isEnabled = state.isCTAEnabled
        labelErrorMessage?.text = state.errorMessage
    }

    func updateNoteDidSucceed() {
        navigationController?.popViewController(animated: true)
    }

    func updateNoteDidFail(errorMessage: String) {
        CommonAlertHandler.showErrorResponseAlert(for: errorMessage)
    }

    func updateLoadingStatus(isLoading: Bool) {
        if isLoading {
            CommonUtil.sharedInstance.showLoader()
        } else {
            CommonUtil.sharedInstance.removeLoader()
        }
    }
}

// MARK: - UITextViewDelegate

extension EditTransactionNotesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel?.editNotes(textView.text ?? "")
    }
}

// MARK: - Helper

extension Notification {
    func userInfoValue<T>(of key: String) -> T? {
        userInfo?[key] as? T
    }
}
