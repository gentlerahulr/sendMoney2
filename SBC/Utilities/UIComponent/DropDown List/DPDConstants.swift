//
//  Constants.swift
//  SBC
//

import UIKit

internal struct DPDConstant {

	internal struct KeyPath {
		static let Frame = "frame"
	}

	internal struct ReusableIdentifier {
		static let DropDownCell = "DropDownCell"
	}
    // swiftlint:disable type_name
	internal struct UI {
		static let TextColor = UIColor.black
        static let SelectedTextColor = UIColor.black
		static let TextFont = UIFont.systemFont(ofSize: 15)
		static let BackgroundColor = UIColor(white: 0.94, alpha: 1)
		static let SelectionBackgroundColor = UIColor(white: 0.89, alpha: 1)
		static let SeparatorColor = UIColor.clear
		static let CornerRadius: CGFloat = 2
		static let RowHeight: CGFloat = 44
		static let HeightPadding: CGFloat = UIDevice.current.hasNotch ? 54 : 20
        static let BorderColor = UIColor.black
        static let WidthPadding: CGFloat = 28
        // swiftlint:disable nesting
		struct Shadow {
			static let Color = UIColor.darkGray
			static let Offset = CGSize.zero
			static let Opacity: Float = 0.4
			static let Radius: CGFloat = 8
		}
	}

	internal struct Animation {
		static let Duration = 0.15
		static let EntranceOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseOut]
		static let ExitOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseIn]
		static let DownScaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
	}
}
