//
//  Cell.swift
//  CustomPresentedViewControllerExample
//
//  Created by Le Xuan Khanh on 1/28/22.
//

import UIKit
class Cell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel.layer.cornerRadius = numberLabel.bounds.height / 2
    }
    
    func reload(data: Int) {
        numberLabel.text = "\(data)"
        numberLabel.backgroundColor = .random
        
        contentLabel.text = "This is a cell \(data)"
    }
}
