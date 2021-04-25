import UIKit
public protocol BottomSheetPresentable {
    var cornerRadius: CGFloat { get set }
    var animationTransitionDuration: TimeInterval { get set }
    var backgroundColor: UIColor { get set }
}

class BottomSheetViewController: UIViewController {
    
    //-----------------------------------------------------------------------------
    // MARK: - Outlets
    //-----------------------------------------------------------------------------
    
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var contentViewHeight: NSLayoutConstraint!
    
    //-----------------------------------------------------------------------------
    // MARK: - Private properties
    //-----------------------------------------------------------------------------
    
    private var childViewController: UIViewController
    private var originBeforeAnimation: CGRect = .zero
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization
    //-----------------------------------------------------------------------------
    
    public init(childViewController: UIViewController) {
        self.childViewController = childViewController
        super.init(
            nibName: String(describing: BottomSheetViewController.self),
            bundle: Bundle(for: BottomSheetViewController.self)
        )
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Lifecycle
    //-----------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.alpha = 1
        configureChild()
        
        contentViewBottomConstraint.constant = -childViewController.view.frame.height
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        contentViewHeight.isActive = false
        contentViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.themeDarkBlue.withAlphaComponent(0.8)
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        originBeforeAnimation = contentView.frame
    }
}

extension BottomSheetViewController {
    
    func dismissViewController() {
        contentViewBottomConstraint.constant = -childViewController.view.frame.height
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = .clear
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func navigateTo(viewController: UIViewController) {
        addChild(viewController)
        contentView.insertSubview(viewController.view, aboveSubview: childViewController.view)
        guard let childSuperView = viewController.view.superview else { return }
        
        NSLayoutConstraint.activate([
            viewController.view.bottomAnchor.constraint(equalTo: childSuperView.bottomAnchor),
            viewController.view.topAnchor.constraint(equalTo: childSuperView.topAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: childSuperView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: childSuperView.trailingAnchor)
        ])
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.transform = CGAffineTransform(translationX: 0, y: viewController.view.frame.size.height)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        viewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.childViewController.view.removeFromSuperview()
                        self.childViewController = viewController
                        self.childViewController.didMove(toParent: self)
        },
                       completion: { _ in
        })
    }
    
}
//-----------------------------------------------------------------------------
// MARK: - Private Methods
//-----------------------------------------------------------------------------

extension BottomSheetViewController {
    private func configureChild() {
        addChild(childViewController)
        contentView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        
        guard let childSuperView = childViewController.view.superview else { return }
        
        NSLayoutConstraint.activate([
            childViewController.view.bottomAnchor.constraint(equalTo: childSuperView.bottomAnchor),
            childViewController.view.topAnchor.constraint(equalTo: childSuperView.topAnchor),
            childViewController.view.leadingAnchor.constraint(equalTo: childSuperView.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: childSuperView.trailingAnchor)
        ])
        
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
//-----------------------------------------------------------------------------
// MARK: - Event handling
//-----------------------------------------------------------------------------

extension BottomSheetViewController: UIGestureRecognizerDelegate {
    
    @IBAction private func topViewTap(_ sender: Any) {
        dismissViewController()
    }
}
