//
//  Extensions.swift
//
//  Created by Laurent Favard on 10/07/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//


import UIKit

public extension UIColor {

    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}

public extension String {
    
    static let empty = ""
    
    /**
     Return the translated string if any
     */
    var asLocalizable : String {
        
        return NSLocalizedString( self, comment:"")
    }

    var fromNumberLocalToInteger : Int? {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current
        
        return formatter.number(from: self)?.intValue

    }

    var fromNumberLocalToDouble : Double? {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        
        return formatter.number(from: self)?.doubleValue
        
    }

    var fromNumberLocalWithCurrencyToInt : Int? {
        
        let formatterInput = NumberFormatter()
        
        formatterInput.numberStyle = .currency
        formatterInput.usesGroupingSeparator = true
        formatterInput.minimumFractionDigits = 0
        formatterInput.maximumFractionDigits = 0
        formatterInput.locale = Locale.current
        
        return formatterInput.number(from: self)?.intValue
    }

    var asCurrencyWithDecimal : String? {

        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current

        return formatter.number(from: self)?.stringValue
    }

    var fromNumberLocalToCurrencyWithoutDecimal : String? {
        
        let formatterInput = NumberFormatter()
        
        formatterInput.numberStyle = .decimal
        formatterInput.usesGroupingSeparator = true
        formatterInput.minimumFractionDigits = 0
        formatterInput.maximumFractionDigits = 0
        formatterInput.locale = Locale.current
        
        let number = formatterInput.number(from: self)
        
        if let number = number {
            let formatterOutput = NumberFormatter()
            
            formatterOutput.numberStyle = .currency
            formatterOutput.usesGroupingSeparator = true
            formatterOutput.minimumFractionDigits = 0
            formatterOutput.maximumFractionDigits = 0
            formatterOutput.locale = Locale.current

            return formatterOutput.string(from: number)
        }
        else {
            return nil
        }
    }

    var fromNumberLocal : String? {
        
        let formatterInput = NumberFormatter()
        
        formatterInput.numberStyle = .decimal
        formatterInput.usesGroupingSeparator = true
        formatterInput.minimumFractionDigits = 0
        formatterInput.maximumFractionDigits = 0
        formatterInput.locale = Locale.current
        
        let number = formatterInput.number(from: self)
        
        if let number = number {
            let formatterOutput = NumberFormatter()
            
            formatterOutput.usesGroupingSeparator = true
            formatterOutput.minimumFractionDigits = 0
            formatterOutput.maximumFractionDigits = 0
            formatterOutput.locale = Locale.current
            
            return formatterOutput.string(from: number)
        }
        else {
            return nil
        }
    }

    var fromNumberLocalToPercentWithSymbol: String? {
        
        let formatterInput = NumberFormatter()
        
        formatterInput.numberStyle = .decimal
        formatterInput.usesGroupingSeparator = true
        formatterInput.minimumFractionDigits = 0
        formatterInput.maximumFractionDigits = 2
        formatterInput.locale = Locale.current
        
        let number = formatterInput.number(from: self)
        
        if let number = number {
            let formatterOutput = NumberFormatter()
            
            formatterOutput.numberStyle = .decimal
            formatterOutput.usesGroupingSeparator = true
            formatterOutput.minimumFractionDigits = 0
            formatterOutput.maximumFractionDigits = 2
            formatterOutput.locale = Locale.current
            
            return (formatterOutput.string(from: number) ?? "0") + "%"
        }
        else {
            return nil
        }
    }
}

extension Double {
    
    var asCurrencyWithDecimals : String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current

        return formatter.string(from: NSNumber(value: self)) ?? String.empty
    }

    var asCurrencyWithoutDecimal : String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current

        return formatter.string(from: NSNumber(value: self)) ?? String.empty
    }

    var asPercentWithSymbol: String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        
        return (formatter.string(from: NSNumber(value: self)) ?? String.empty) + "%"
    }

    var asPercentWithoutSymbol: String {

        let formatter = NumberFormatter()

        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current

        return formatter.string(from: NSNumber(value: self)) ?? String.empty
    }
}

extension Int {
    
    var asCurrencyWithSymbol : String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current
        
        return formatter.string(from: NSNumber(value: self)) ?? String.empty
    }
    
    var asCurrencyWithoutSymbol : String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current
        
        return formatter.string(from: NSNumber(value: self)) ?? String.empty
    }
}

extension UIImageView {
    
    override open var canBecomeFirstResponder: Bool {
        
        return true
    }
}

extension Date {
    
    /**
     Format and return the self date and time
     
     */
    var asDateTimeLocalized : String {
        
        //  Format the ouput now with a specific formatter regarding the current localization
        let dateOutputFormatter  = DateFormatter()
        dateOutputFormatter.dateStyle = .long
        dateOutputFormatter.timeStyle = .short
        dateOutputFormatter.locale = Locale.autoupdatingCurrent
        
        let outputDate = dateOutputFormatter.string(from: self)
        
        return outputDate
    }

    /**
     Format and return the self date only
     
     */
    var asDateLocalized : String {
        
        //  Format the ouput now with a specific formatter regarding the current localization
        let dateOutputFormatter  = DateFormatter()
        dateOutputFormatter.dateStyle = .long
        dateOutputFormatter.timeStyle = .none
        dateOutputFormatter.locale = Locale.autoupdatingCurrent
        
        let outputDate = dateOutputFormatter.string(from: self)
        
        return outputDate
    }

}
