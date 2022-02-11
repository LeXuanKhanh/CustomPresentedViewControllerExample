//
//  ViewController.swift
//  CustomPresentedViewControllerExample
//
//  Created by Le Xuan Khanh on 1/28/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onButtonPresentTapped(_ sender: Any) {
        let vc = PresentedViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.transitioningDelegate = self
        navVC.modalPresentationStyle = .custom
        self.present(navVC, animated: true)
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let cpc = CustomPresentationController(presentedViewController: presented, presenting: presenting)
        cpc.presentHeight = 2 * UIScreen.main.bounds.height / 3
        cpc.dismissHeight = UIScreen.main.bounds.height / 3
        cpc.isDismissWhenReachDismissHeight = true
        // cpc.panRecognizer.isEnabled = false
        return cpc
    }
}
