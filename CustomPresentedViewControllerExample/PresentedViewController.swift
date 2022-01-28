//
//  PresentedViewController.swift
//  CustomPresentedViewControllerExample
//
//  Created by Le Xuan Khanh on 1/28/22.
//

import UIKit

struct User {
    let name: String
}

class PresentedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: [Int] = Array<Int>(0...100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = NSLocalizedString("PresentedViewController", comment: "")
        
        if isBeingPresented || (navigationController?.isBeingPresented ?? false && (navigationController?.viewControllers.count ?? 0) == 1) {
            let buttonItem = UIBarButtonItem(image: UIImage.init(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(onDismissButtonTapped(_:)))
            navigationItem.leftBarButtonItems = [buttonItem]
        }
        
        tableView.estimatedRowHeight = 80.0;
        tableView.separatorStyle = .none
        tableView.registerCellNib(Cell.self)
    }
    
    @objc func onDismissButtonTapped(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PresentedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(Cell.self, with: Cell.identifierString)
        cell.reload(data: data[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


