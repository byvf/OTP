//
//  Extension.swift
//  OTPView
//
//  Created by Vladylav Filippov on 18.11.2021.
//

import UIKit

// MARK: - Extension String
extension String {
    func substring(from: Int, to: Int) -> String {
        guard to < count else { return self }
        let start = index(startIndex, offsetBy: from)
        let end = index(startIndex, offsetBy: count - (count - to) + 1)
        let range = start ..< end
        return String(self[range])
    }
}

// MARK: - Extension UIView
extension UIView {
    /// Create border for all view
    func createBorder(_ width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// Create Round Corner for all view
    @objc func createRoundCorner(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

extension UIView {
    // MARK - Add Constraint for View
    /// Add basic constraint and add to subiew
    func addSubviewWithConstraints(_ view: UIView, insets: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }
    
}

// MARK: - Extension NSLayoutConstraint
extension NSLayoutConstraint {
    
    // Add Priority
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
}

// MARK: - Extension UIColor
extension UIColor {
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

