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
