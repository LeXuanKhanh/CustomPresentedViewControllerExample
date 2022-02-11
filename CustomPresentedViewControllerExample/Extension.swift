//
//  Extension.swift
//  CustomPresentedViewControllerExample
//
//  Created by Le Xuan Khanh on 1/28/22.
//

import UIKit
public extension UITableView {
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func reusableCell<T>(_ type: T.Type, with identifier: String) -> T {
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

public extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}

public extension UITableViewCell {
    static var identifierString: String {
        return String(describing: self)
    }
}

public extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }
    
    func setBorder(borderWidth: CGFloat?=nil,
                   borderColor: UIColor?=nil,
                   cornerRadius: CGFloat?=nil){
        
        if let borderWidth = borderWidth{
            self.layer.borderWidth = borderWidth
        }
        
        if let borderColor = borderColor{
            self.layer.borderColor = borderColor.cgColor
        }
        
        if let cornerRadius = cornerRadius{
            //Fix ios 10
            self.layoutIfNeeded()
            self.layer.cornerRadius = cornerRadius
        }
        
        var safeArea: UIEdgeInsets {
            if #available(iOS 11.0, *) {
                return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }?.safeAreaInsets ?? .zero
            } else {
                return .zero
            }
        }
    }
}
