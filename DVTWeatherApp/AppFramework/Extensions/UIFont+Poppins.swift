//
//  UIFont+Poppins.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 28/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import UIKit

// MARK: - Poppins Font Extension
extension UIFont {
    enum PoppinsFontName: String {
        case regular = "Poppins-Regular"
        case italic = "Poppins-Italic"
        case thin = "Poppins-Thin"
        case thinItalic = "Poppins-ThinItalic"
        case extraLight = "Poppins-ExtraLight"
        case extraLightItalic = "Poppins-ExtraLightItalic"
        case light = "Poppins-Light"
        case lightItalic = "Poppins-LightItalic"
        case medium = "Poppins-Medium"
        case mediumItalic = "Poppins-MediumItalic"
        case semiBold = "Poppins-SemiBold"
        case semiBoldItalic = "Poppins-SemiBoldItalic"
        case bold = "Poppins-Bold"
        case boldItalic = "Poppins-BoldItalic"
        case extraBold = "Poppins-ExtraBold"
        case extraBoldItalic = "Poppins-ExtraBoldItalic"
        case black = "Poppins-Black"
        case blackItalic = "Poppins-BlackItalic"
    }

    static func poppins(_ style: PoppinsFontName, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func poppinsRegular(size: CGFloat) -> UIFont {
        return poppins(.regular, size: size)
    }

    static func poppinsLight(size: CGFloat) -> UIFont {
        return poppins(.light, size: size)
    }

    static func poppinsMedium(size: CGFloat) -> UIFont {
        return poppins(.medium, size: size)
    }

    static func poppinsSemiBold(size: CGFloat) -> UIFont {
        return poppins(.semiBold, size: size)
    }

    static func poppinsBold(size: CGFloat) -> UIFont {
        return poppins(.bold, size: size)
    }

    static func poppinsExtraBold(size: CGFloat) -> UIFont {
        return poppins(.extraBold, size: size)
    }

    static func poppinsBlack(size: CGFloat) -> UIFont {
        return poppins(.black, size: size)
    }
}

extension UIFont {

    static var weatherTitle: UIFont {
        return poppinsBold(size: 18)
    }

    static var weatherTemperature: UIFont {
        return poppinsBold(size: 36)
    }

    static var weatherCardTitle: UIFont {
        return poppinsSemiBold(size: 16)
    }

    static var weatherBody: UIFont {
        return poppinsRegular(size: 14)
    }

    static var weatherSmall: UIFont {
        return poppinsRegular(size: 12)
    }
}
