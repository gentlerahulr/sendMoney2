//
//  DropDown.swift
//  SBC
//

import UIKit

public typealias Index = Int
public typealias Closure = () -> Void
public typealias SelectionClosure = (Index, String) -> Void
public typealias MultiSelectionClosure = ([Index], [String]) -> Void
public typealias ConfigurationClosure = (Index, String) -> String
public typealias CellConfigurationClosure = (Index, String, DropDownCell) -> Void
private typealias ComputeLayoutTuple = (x: CGFloat, y: CGFloat, width: CGFloat, offscreenHeight: CGFloat)

@objc
public protocol AnchorView: class {

	var plainView: UIView { get }

}

extension UIView: AnchorView {

	public var plainView: UIView {
		return self
	}

}

extension UIBarButtonItem: AnchorView {

	public var plainView: UIView {
		return value(forKey: "view") as! UIView
	}
}

public final class DropDown: UIView {

    struct Layout {
        let x: CGFloat
        let y: CGFloat
        let width: CGFloat
        let offscreenHeight: CGFloat
        let visibleHeight: CGFloat
        let canBeDisplayed: Bool
        let Direction: Direction
    }
    
	public enum DismissMode {
		case onTap
		case automatic
		case manual

	}

	public enum Direction {
		case any
		case top
		case bottom

	}

	// MARK: Properties
	public static weak var VisibleDropDown: DropDown?

	// MARK: UI
	fileprivate let dismissableView = UIView()
	fileprivate let tableViewContainer = UIView()
	fileprivate let tableView = UITableView()
	fileprivate var templateCell: DropDownCell!
    fileprivate lazy var arrowIndication: UIImageView = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 10), false, 0)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: 20, y: 10))
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 10))
        UIColor.black.setFill()
        path.fill()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let tintImg = img?.withRenderingMode(.alwaysTemplate)
        let imgv = UIImageView(image: tintImg)
        imgv.frame = CGRect(x: 0, y: -10, width: 15, height: 10)
        return imgv
    }()

	public weak var anchorView: AnchorView? {
		didSet { setNeedsUpdateConstraints() }
	}

	public var direction = Direction.any

	public var topOffset: CGPoint = .zero {
		didSet { setNeedsUpdateConstraints() }
	}

	public var bottomOffset: CGPoint = .zero {
		didSet { setNeedsUpdateConstraints() }
	}

    public var offsetFromWindowBottom = CGFloat(0) {
        didSet { setNeedsUpdateConstraints() }
    }
    
	public var width: CGFloat? {
		didSet { setNeedsUpdateConstraints() }
	}

	public var arrowIndicationX: CGFloat? {
		didSet {
			if let arrowIndicationX = arrowIndicationX {
				tableViewContainer.addSubview(arrowIndication)
				arrowIndication.tintColor = tableViewBackgroundColor
				arrowIndication.frame.origin.x = arrowIndicationX
			} else {
				arrowIndication.removeFromSuperview()
			}
		}
	}

	// MARK: Constraints
	fileprivate var heightConstraint: NSLayoutConstraint!
	fileprivate var widthConstraint: NSLayoutConstraint!
	fileprivate var xConstraint: NSLayoutConstraint!
	fileprivate var yConstraint: NSLayoutConstraint!

	// MARK: Appearance
	@objc public dynamic var cellHeight = DPDConstant.UI.RowHeight {
		willSet { tableView.rowHeight = newValue }
		didSet { reloadAllComponents() }
	}

	@objc fileprivate dynamic var tableViewBackgroundColor = DPDConstant.UI.BackgroundColor {
		willSet {
            tableView.backgroundColor = newValue
            if arrowIndicationX != nil { arrowIndication.tintColor = newValue }
        }
	}

	public override var backgroundColor: UIColor? {
		get { return tableViewBackgroundColor }
		set { tableViewBackgroundColor = newValue! }
	}

	public var dimmedBackgroundColor = UIColor.clear {
		willSet { super.backgroundColor = newValue }
	}

	@objc public dynamic var selectionBackgroundColor = DPDConstant.UI.SelectionBackgroundColor

	@objc public dynamic var separatorColor = DPDConstant.UI.SeparatorColor {
		willSet { tableView.separatorColor = newValue }
		didSet { reloadAllComponents() }
	}

	@objc public dynamic var cornerRadius = DPDConstant.UI.CornerRadius {
		willSet {
			tableViewContainer.layer.cornerRadius = newValue
			tableView.layer.cornerRadius = newValue
		}
		didSet { reloadAllComponents() }
	}

	@objc public dynamic func setupCornerRadius(_ radius: CGFloat) {
		tableViewContainer.layer.cornerRadius = radius
		tableView.layer.cornerRadius = radius
		reloadAllComponents()
	}

	@available(iOS 11.0, *)
	@objc public dynamic func setupMaskedCorners(_ cornerMask: CACornerMask) {
		tableViewContainer.layer.maskedCorners = cornerMask
		tableView.layer.maskedCorners = cornerMask
		reloadAllComponents()
	}

	@objc public dynamic var shadowColor = DPDConstant.UI.Shadow.Color {
		willSet { tableViewContainer.layer.shadowColor = newValue.cgColor }
		didSet { reloadAllComponents() }
	}

    @objc public dynamic var borderColor = DPDConstant.UI.BorderColor {
        willSet {
            tableViewContainer.layer.borderColor = newValue.cgColor
            tableViewContainer.layer.borderWidth = 1
        }
        didSet { reloadAllComponents() }
    }
    
	@objc public dynamic var shadowOffset = DPDConstant.UI.Shadow.Offset {
		willSet { tableViewContainer.layer.shadowOffset = newValue }
		didSet { reloadAllComponents() }
	}

	@objc public dynamic var shadowOpacity = DPDConstant.UI.Shadow.Opacity {
		willSet { tableViewContainer.layer.shadowOpacity = newValue }
		didSet { reloadAllComponents() }
	}

	@objc public dynamic var shadowRadius = DPDConstant.UI.Shadow.Radius {
		willSet { tableViewContainer.layer.shadowRadius = newValue }
		didSet { reloadAllComponents() }
	}

	@objc public dynamic var animationduration = DPDConstant.Animation.Duration
	public static var animationEntranceOptions = DPDConstant.Animation.EntranceOptions
	public static var animationExitOptions = DPDConstant.Animation.ExitOptions
	public var animationEntranceOptions: UIView.AnimationOptions = DropDown.animationEntranceOptions
	public var animationExitOptions: UIView.AnimationOptions = DropDown.animationExitOptions
	public var downScaleTransform = DPDConstant.Animation.DownScaleTransform {
		willSet { tableViewContainer.transform = newValue }
	}

	@objc public dynamic var textColor = DPDConstant.UI.TextColor {
		didSet { reloadAllComponents() }
	}

    @objc public dynamic var selectedTextColor = DPDConstant.UI.SelectedTextColor {
        didSet { reloadAllComponents() }
    }
    
	@objc public dynamic var textFont = DPDConstant.UI.TextFont {
		didSet { reloadAllComponents() }
	}
    
    @objc public dynamic var selectedTextFont = DPDConstant.UI.TextFont {
        didSet { reloadAllComponents() }
    }
    
	public var cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self)) {
		didSet {
			tableView.register(cellNib, forCellReuseIdentifier: DPDConstant.ReusableIdentifier.DropDownCell)
			templateCell = nil
			reloadAllComponents()
		}
	}
    
    public var titleString: String? {
        didSet {
            if let string = titleString {
                let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 55))
                viewHeader.backgroundColor = .clear
                let labelHeader = UILabel()
                labelHeader.font = .regularFontWithSize(size: 16)
                labelHeader.textColor = .themeDarkBlue
                labelHeader.text = string
                labelHeader.sizeToFit()
                labelHeader.frame = CGRect(x: 15, y: 0, width: labelHeader.frame.width, height: 55)
                viewHeader.addSubview(labelHeader)
                self.tableView.tableHeaderView = viewHeader
            } else {
                self.tableView.tableHeaderView = nil
            }
            reloadAllComponents()
        }
    }
	
	public var dataSource = [String]() {
		didSet {
            deselectRows(at: selectedRowIndices)
			reloadAllComponents()
		}
	}

	public var localizationKeysDataSource = [String]() {
		didSet {
			dataSource = localizationKeysDataSource.map { NSLocalizedString($0, comment: "") }
		}
	}

	/// The indicies that have been selected
	fileprivate var selectedRowIndices = Set<Index>()

	public var cellConfiguration: ConfigurationClosure? {
		didSet { reloadAllComponents() }
	}
    
    public var customCellConfiguration: CellConfigurationClosure? {
        didSet { reloadAllComponents() }
    }

	/// The action to execute when the user selects a cell.
	public var selectionAction: SelectionClosure?
    
    public var multiSelectionAction: MultiSelectionClosure?

	/// The action to execute when the drop down will show.
	public var willShowAction: Closure?

	/// The action to execute when the user cancels/hides the drop down.
	public var cancelAction: Closure?

	/// The dismiss mode of the drop down. Default is `OnTap`.
	public var dismissMode = DismissMode.automatic {
		willSet {
			if newValue == .onTap {
				let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissableViewTapped))
				dismissableView.addGestureRecognizer(gestureRecognizer)
			} else if let gestureRecognizer = dismissableView.gestureRecognizers?.first {
				dismissableView.removeGestureRecognizer(gestureRecognizer)
			}
		}
	}

	fileprivate var minHeight: CGFloat {
		return tableView.rowHeight
	}

	fileprivate var didSetupConstraints = false

	// MARK: - Init's

	deinit {
		stopListeningToNotifications()
	}

	public convenience init() {
		self.init(frame: .zero)
	}

	public convenience init(anchorView: AnchorView, selectionAction: SelectionClosure? = nil, dataSource: [String] = [], topOffset: CGPoint? = nil, bottomOffset: CGPoint? = nil, cellConfiguration: ConfigurationClosure? = nil, cancelAction: Closure? = nil) {
		self.init(frame: .zero)

		self.anchorView = anchorView
		self.selectionAction = selectionAction
		self.dataSource = dataSource
		self.topOffset = topOffset ?? CGPoint(x: 28, y: 0)
		self.bottomOffset = bottomOffset ?? .zero
		self.cellConfiguration = cellConfiguration
		self.cancelAction = cancelAction
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

}

// MARK: - Setup

private extension DropDown {

	func setup() {
		tableView.register(cellNib, forCellReuseIdentifier: DPDConstant.ReusableIdentifier.DropDownCell)

		DispatchQueue.main.async {
			self.updateConstraintsIfNeeded()
			self.setupUI()
        }
        
		tableView.rowHeight = cellHeight
		setHiddentState()
		isHidden = true
		dismissMode = .onTap
		tableView.delegate = self
		tableView.dataSource = self
        startListeningToKeyboard()
		accessibilityIdentifier = "drop_down"
	}

	func setupUI() {
		super.backgroundColor = dimmedBackgroundColor

		tableViewContainer.layer.masksToBounds = false
		tableViewContainer.layer.cornerRadius = cornerRadius
		tableViewContainer.layer.shadowColor = shadowColor.cgColor
		tableViewContainer.layer.shadowOffset = shadowOffset
		tableViewContainer.layer.shadowOpacity = shadowOpacity
		tableViewContainer.layer.shadowRadius = shadowRadius
        tableViewContainer.layer.borderWidth = 1
        tableViewContainer.layer.borderColor = borderColor.cgColor
		tableView.backgroundColor = tableViewBackgroundColor
		tableView.separatorColor = separatorColor
		tableView.layer.cornerRadius = cornerRadius
		tableView.layer.masksToBounds = true
	}

}

extension DropDown {

	public override func updateConstraints() {
		if !didSetupConstraints {
			setupConstraints()
		}

		didSetupConstraints = true
		let layout = computeLayout()
		if !layout.canBeDisplayed {
			super.updateConstraints()
			hide()
			return
		}
		xConstraint.constant = layout.x
		yConstraint.constant = layout.y
		widthConstraint.constant = layout.width
		heightConstraint.constant = layout.visibleHeight
		tableView.isScrollEnabled = layout.offscreenHeight > 0
		DispatchQueue.main.async { [weak self] in
			self?.tableView.flashScrollIndicators()
		}
		super.updateConstraints()
	}

	fileprivate func setupConstraints() {
		translatesAutoresizingMaskIntoConstraints = false

		// Dismissable view
		addSubview(dismissableView)
		dismissableView.translatesAutoresizingMaskIntoConstraints = false
		addUniversalConstraints(format: "|[dismissableView]|", views: ["dismissableView": dismissableView])
        
		// Table view container
		addSubview(tableViewContainer)
		tableViewContainer.translatesAutoresizingMaskIntoConstraints = false

		xConstraint = NSLayoutConstraint(
			item: tableViewContainer,
			attribute: .leading,
			relatedBy: .equal,
			toItem: self,
			attribute: .leading,
			multiplier: 1,
			constant: 0)
		addConstraint(xConstraint)

		yConstraint = NSLayoutConstraint(
			item: tableViewContainer,
			attribute: .top,
			relatedBy: .equal,
			toItem: self,
			attribute: .top,
			multiplier: 1,
			constant: 0)
		addConstraint(yConstraint)

		widthConstraint = NSLayoutConstraint(
			item: tableViewContainer,
			attribute: .width,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1,
			constant: 0)
		tableViewContainer.addConstraint(widthConstraint)

		heightConstraint = NSLayoutConstraint(
			item: tableViewContainer,
			attribute: .height,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1,
			constant: 0)
		tableViewContainer.addConstraint(heightConstraint)

		// Table view
		tableViewContainer.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false

		tableViewContainer.addUniversalConstraints(format: "|[tableView]|", views: ["tableView": tableView])
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		setNeedsUpdateConstraints()
		let shadowPath = UIBezierPath(roundedRect: tableViewContainer.bounds, cornerRadius: cornerRadius)
		tableViewContainer.layer.shadowPath = shadowPath.cgPath
	}

	fileprivate func computeLayout() -> Layout {
		var layout: ComputeLayoutTuple = (0, 0, 0, 0)
		var direction = self.direction

        guard let window = UIWindow.visibleWindow() else { return Layout(x: 0, y: 0, width: 0, offscreenHeight: 0, visibleHeight: 0, canBeDisplayed: false, Direction: direction) }

		barButtonItemCondition: if let anchorView = anchorView as? UIBarButtonItem {
			let isRightBarButtonItem = anchorView.plainView.frame.minX > window.frame.midX

			guard isRightBarButtonItem else { break barButtonItemCondition }

			let width = self.width ?? fittingWidth(window: window)
			let anchorViewWidth = anchorView.plainView.frame.width
			let x = -(width - anchorViewWidth)

			bottomOffset = CGPoint(x: x, y: 0)
		}
		
		if anchorView == nil {
			layout = computeLayoutBottomDisplay(window: window)
			direction = .any
		} else {
			switch direction {
			case .any:
				layout = computeLayoutBottomDisplay(window: window)
				direction = .bottom
			case .bottom:
				layout = computeLayoutBottomDisplay(window: window)
				direction = .bottom
			case .top:
				layout = computeLayoutForTopDisplay(window: window)
				direction = .top
			}
		}
		
		constraintWidthToFittingSizeIfNecessary(layout: &layout)
		constraintWidthToBoundsIfNecessary(layout: &layout, in: window)
		
		let visibleHeight = tableHeight - layout.offscreenHeight
        let canBeDisplayed = visibleHeight > 0 ? self.dataSource.count > 0 : visibleHeight >= minHeight

        return Layout(x: layout.x, y: layout.y, width: layout.width, offscreenHeight: layout.offscreenHeight, visibleHeight: visibleHeight, canBeDisplayed: canBeDisplayed, Direction: direction)
	}

	fileprivate func computeLayoutBottomDisplay(window: UIWindow) -> ComputeLayoutTuple {
		var offscreenHeight: CGFloat = 0
		
        let width = self.width ?? (anchorView?.plainView.bounds.width ?? (window.frame.width - (DPDConstant.UI.WidthPadding*2.0)))
		
		let anchorViewX = anchorView?.plainView.windowFrame?.minX ?? window.frame.midX - (width / 2)
		let anchorViewY = anchorView?.plainView.windowFrame?.minY ?? window.frame.midY - (tableHeight / 2)
		
		let x = anchorViewX + bottomOffset.x
		let y = anchorViewY + bottomOffset.y
		
		let maxY = y + tableHeight
		let windowMaxY = window.bounds.maxY - DPDConstant.UI.HeightPadding - offsetFromWindowBottom
		
		let keyboardListener = KeyboardListener.sharedInstance
        let keyboardMinY = keyboardListener.keyboardFrame.minY - (keyboardListener.isVisible ? 5 : DPDConstant.UI.HeightPadding)
		
		if keyboardListener.isVisible && maxY > keyboardMinY {
			offscreenHeight = abs(maxY - keyboardMinY)
		} else if maxY > windowMaxY {
			offscreenHeight = abs(maxY - windowMaxY)
		}
		
		return (x, y, width, offscreenHeight)
	}

	fileprivate func computeLayoutForTopDisplay(window: UIWindow) -> ComputeLayoutTuple {
		var offscreenHeight: CGFloat = 0

		let anchorViewX = anchorView?.plainView.windowFrame?.minX ?? 0
		let anchorViewMaxY = anchorView?.plainView.windowFrame?.maxY ?? 0

		let x = anchorViewX + topOffset.x
		var y = (anchorViewMaxY + topOffset.y) - tableHeight

		let windowY = window.bounds.minY + DPDConstant.UI.HeightPadding

		if y < windowY {
			offscreenHeight = abs(y - windowY)
			y = windowY
		}
		
        let width = self.width ?? (anchorView?.plainView.bounds.width ?? fittingWidth(window: window)) - topOffset.x
		
		return (x, y, width, offscreenHeight)
	}
	
	fileprivate func fittingWidth(window: UIWindow?) -> CGFloat {
		if templateCell == nil {
			templateCell = (cellNib.instantiate(withOwner: nil, options: nil)[0] as! DropDownCell)
		}
		
		var maxWidth: CGFloat = 0
		
		for index in 0..<dataSource.count {
			configureCell(templateCell, at: index)
			templateCell.bounds.size.height = cellHeight
            
            
            var width: CGFloat = 0
            if let window = window {
                width = window.bounds.maxX - 56
            } else {
                width = anchorView?.plainView.frame.width ?? templateCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width - 56
            }
			
			if width > maxWidth {
				maxWidth = width
			}
		}
		
		return maxWidth
	}
	
	fileprivate func constraintWidthToBoundsIfNecessary(layout: inout ComputeLayoutTuple, in window: UIWindow) {
		let windowMaxX = window.bounds.maxX
		let maxX = layout.x + layout.width
		
		if maxX > windowMaxX {
			let delta = maxX - windowMaxX
			let newOrigin = layout.x - delta
			
			if newOrigin > 0 {
				layout.x = newOrigin
			} else {
				layout.x = 0
				layout.width += newOrigin
			}
		}
	}
	
	fileprivate func constraintWidthToFittingSizeIfNecessary(layout: inout ComputeLayoutTuple) {
		guard width == nil else { return }
		
        if layout.width < fittingWidth(window: nil) {
            layout.width = fittingWidth(window: nil)
		}
	}
	
}

extension DropDown {
    
    @objc(show)
    public func objc_show() -> NSDictionary {
        let (canBeDisplayed, offScreenHeight) = show()
        
        var info = [AnyHashable: Any]()
        info["canBeDisplayed"] = canBeDisplayed
        if let offScreenHeight = offScreenHeight {
            info["offScreenHeight"] = offScreenHeight
        }
        
        return NSDictionary(dictionary: info)
    }
	
	@discardableResult
    public func show(onTopOf window: UIWindow? = nil, beforeTransform transform: CGAffineTransform? = nil, anchorPoint: CGPoint? = nil) -> (canBeDisplayed: Bool, offscreenHeight: CGFloat?) {
		if self == DropDown.VisibleDropDown && DropDown.VisibleDropDown?.isHidden == false { 
			return (true, 0)
		}

		if let visibleDropDown = DropDown.VisibleDropDown {
			visibleDropDown.cancel()
		}

		willShowAction?()

		DropDown.VisibleDropDown = self

		setNeedsUpdateConstraints()

		let visibleWindow = window != nil ? window : UIWindow.visibleWindow()
		visibleWindow?.addSubview(self)
		visibleWindow?.bringSubviewToFront(self)

		self.translatesAutoresizingMaskIntoConstraints = false
		visibleWindow?.addUniversalConstraints(format: "|[dropDown]|", views: ["dropDown": self])

		let layout = computeLayout()

        if !layout.canBeDisplayed {
			hide()
			return (layout.canBeDisplayed, layout.offscreenHeight)
		}

		isHidden = false
        
        if anchorPoint != nil {
            tableViewContainer.layer.anchorPoint = anchorPoint!
        }
        
        if transform != nil {
            tableViewContainer.transform = transform!
        } else {
            tableViewContainer.transform = downScaleTransform
        }

		layoutIfNeeded()

		UIView.animate(
			withDuration: animationduration,
			delay: 0,
			options: animationEntranceOptions,
			animations: { [weak self] in
				self?.setShowedState()
			},
			completion: nil)

		accessibilityViewIsModal = true
		UIAccessibility.post(notification: .screenChanged, argument: self)

		//deselectRows(at: selectedRowIndices)
		selectRows(at: selectedRowIndices)

		return (layout.canBeDisplayed, layout.offscreenHeight)
	}

	public override func accessibilityPerformEscape() -> Bool {
		switch dismissMode {
		case .automatic, .onTap:
			cancel()
			return true
		case .manual:
			return false
		}
	}

	/// Hides the drop down.
	public func hide() {
		if self == DropDown.VisibleDropDown {
			DropDown.VisibleDropDown = nil
		}

		if isHidden {
			return
		}

		UIView.animate(
			withDuration: animationduration,
			delay: 0,
			options: animationExitOptions,
			animations: { [weak self] in
				self?.setHiddentState()
			},
			completion: { [weak self] _ in
				guard let `self` = self else { return }

				self.isHidden = true
				self.removeFromSuperview()
				UIAccessibility.post(notification: .screenChanged, argument: nil)
		})
	}

	fileprivate func cancel() {
		hide()
		cancelAction?()
	}

	fileprivate func setHiddentState() {
		alpha = 0
	}

	fileprivate func setShowedState() {
		alpha = 1
		tableViewContainer.transform = CGAffineTransform.identity
	}

}

// MARK: - UITableView

extension DropDown {

	public func reloadAllComponents() {
		DispatchQueue.executeOnMainThread {
			self.tableView.reloadData()
			self.setNeedsUpdateConstraints()
		}
	}

	/// (Pre)selects a row at a certain index.
	public func selectRow(at index: Index?, scrollPosition: UITableView.ScrollPosition = .none) {
		if let index = index {
            tableView.selectRow(
                at: IndexPath(row: index, section: 0), animated: true, scrollPosition: scrollPosition
            )
            selectedRowIndices.insert(index)
		} else {
			deselectRows(at: selectedRowIndices)
            selectedRowIndices.removeAll()
		}
	}
    
    public func selectRows(at indices: Set<Index>?) {
        indices?.forEach {
            selectRow(at: $0)
        }
        
        if multiSelectionAction != nil {
            tableView.reloadData()
        }
    }

	public func deselectRow(at index: Index?) {
		guard let index = index else { return }
        guard  index >= 0 else { return }
        if let selectedRowIndex = selectedRowIndices.firstIndex(where: { $0 == index  }) {
            selectedRowIndices.remove(at: selectedRowIndex)
        }

		tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
	}
    
    // de-selects the rows at the indices provided
    public func deselectRows(at indices: Set<Index>?) {
        indices?.forEach {
            deselectRow(at: $0)
        }
    }

	/// Returns the index of the selected row.
	public var indexForSelectedRow: Index? {
		return (tableView.indexPathForSelectedRow as NSIndexPath?)?.row
	}

	/// Returns the selected item.
	public var selectedItem: String? {
		guard let row = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row else { return nil }

		return dataSource[row]
	}

	/// Returns the height needed to display all cells.
	fileprivate var tableHeight: CGFloat {
        return tableView.rowHeight * CGFloat(dataSource.count)
	}

    // MARK: Objective-C methods for converting the Swift type Index
	@objc public func selectRow(_ index: Int, scrollPosition: UITableView.ScrollPosition = .none) {
        self.selectRow(at: Index(index), scrollPosition: scrollPosition)
    }
    
    @objc public func clearSelection() {
        self.selectRow(at: nil)
    }
    
    @objc public func deselectRow(_ index: Int) {
        tableView.deselectRow(at: IndexPath(row: Index(index), section: 0), animated: true)
    }

    @objc public var indexPathForSelectedRow: NSIndexPath? {
        return tableView.indexPathForSelectedRow as NSIndexPath?
    }
}

// MARK: - UITableViewDataSource - UITableViewDelegate

extension DropDown: UITableViewDataSource, UITableViewDelegate {

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: DPDConstant.ReusableIdentifier.DropDownCell, for: indexPath) as! DropDownCell
		let index = (indexPath as NSIndexPath).row

		configureCell(cell, at: index)

		return cell
	}
	
	fileprivate func configureCell(_ cell: DropDownCell, at index: Int) {
		if index >= 0 && index < localizationKeysDataSource.count {
			cell.accessibilityIdentifier = localizationKeysDataSource[index]
		}
		
		cell.optionLabel.textColor = textColor
        cell.normalFont = self.textFont
        cell.selectedFont = self.selectedTextFont
		cell.selectedBackgroundColor = selectionBackgroundColor
        cell.highlightTextColor = selectedTextColor
        cell.normalTextColor = textColor
        cell.separatorView.isHidden = index == dataSource.count-1
		
		if let cellConfiguration = cellConfiguration {
			cell.optionLabel.text = cellConfiguration(index, dataSource[index])
		} else {
			cell.optionLabel.text = dataSource[index]
		}
		
		customCellConfiguration?(index, dataSource[index], cell)
	}

	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isSelected = selectedRowIndices.first { $0 == (indexPath as NSIndexPath).row } != nil
	}

	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedRowIndex = (indexPath as NSIndexPath).row
        
        if let multiSelectionCallback = multiSelectionAction {
            if selectedRowIndices.first(where: { $0 == selectedRowIndex}) != nil {
                deselectRow(at: selectedRowIndex)

				let selectedRowIndicesArray = Array(selectedRowIndices)
                let selectedRows = selectedRowIndicesArray.map { dataSource[$0] }
                multiSelectionCallback(selectedRowIndicesArray, selectedRows)
                return
            } else {
                selectedRowIndices.insert(selectedRowIndex)

				let selectedRowIndicesArray = Array(selectedRowIndices)
				let selectedRows = selectedRowIndicesArray.map { dataSource[$0] }
                
                selectionAction?(selectedRowIndex, dataSource[selectedRowIndex])
                multiSelectionCallback(selectedRowIndicesArray, selectedRows)
                tableView.reloadData()
                return
            }
        }
        
        selectedRowIndices.removeAll()
        selectedRowIndices.insert(selectedRowIndex)
        selectionAction?(selectedRowIndex, dataSource[selectedRowIndex])
        
        if let _ = anchorView as? UIBarButtonItem {
            deselectRow(at: selectedRowIndex)
        }
        hide()
	}
}

// MARK: - Auto dismiss

extension DropDown {

	public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, with: event)

		if dismissMode == .automatic && view === dismissableView {
			cancel()
			return nil
		} else {
			return view
		}
	}

	@objc
	fileprivate func dismissableViewTapped() {
		cancel()
	}

}

// MARK: - Keyboard events

extension DropDown {

	@objc public static func startListeningToKeyboard() {
		KeyboardListener.sharedInstance.startListeningToKeyboard()
	}

	fileprivate func startListeningToKeyboard() {
		KeyboardListener.sharedInstance.startListeningToKeyboard()

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardUpdate),
			name: UIResponder.keyboardWillShowNotification,
			object: nil)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardUpdate),
			name: UIResponder.keyboardWillHideNotification,
			object: nil)
	}

	fileprivate func stopListeningToNotifications() {
		NotificationCenter.default.removeObserver(self)
	}

	@objc
	fileprivate func keyboardUpdate() {
		self.setNeedsUpdateConstraints()
	}

}

private extension DispatchQueue {
	static func executeOnMainThread(_ closure: @escaping Closure) {
		if Thread.isMainThread {
			closure()
		} else {
			main.async(execute: closure)
		}
	}
}
