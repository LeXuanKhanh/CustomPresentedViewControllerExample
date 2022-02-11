//
//  CustomPresentationController.swift
//  Ring
//
//  Created by Le Xuan Khanh on 1/10/22.
//  Copyright © 2022 RMD Operations Pte. Ltd. All rights reserved.
//

import UIKit
// Implementation Example: VideoCallViewController
/* how to use
- add UIViewControllerTransitioningDelegate delegate and delegate method to ParentViewController
 
 class ParentViewController: UIViewController, UIViewControllerTransitioningDelegate {
     func present() {
         let pvc = PresentViewController()
         pvc.modalPresentationStyle = .custom
         // set delegate to ViewController which you want to present halfsize
         pvc.transitioningDelegate = self
         present(pvc, animated: true)
     }
     
     func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
         return CustomPresentationController(presentedViewController: presented, presenting: presentingViewController)
     }
 }
 */

class CustomPresentationController: UIPresentationController {
    var dimmingView = UIView()
    let tapRecognizer = UITapGestureRecognizer()
    let panRecognizer = UIPanGestureRecognizer()
    
    var dismissHeight = (UIScreen.main.bounds.height / 2.0) / 2.0
    var presentHeight = UIScreen.main.bounds.height / 2.0
    var maxScaleParentVC = 0.9
    var isDimmingEnabled = false
    
    var dismissY: CGFloat {
        return UIScreen.main.bounds.height - dismissHeight
    }
    
    var presentY: CGFloat {
        return UIScreen.main.bounds.height - presentHeight
    }
    
    var isDismissWhenReachDismissHeight = true
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        self.panRecognizer.addTarget(self, action: #selector(onPan(_:)))
        presentedViewController.view.addGestureRecognizer(panRecognizer)
        presentedViewController.view.roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: presentY, width: bounds.width, height: presentHeight)
    }
    
    func setupDimmingView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView?.bounds.size.width ?? 0.0, height: containerView?.bounds.size.height ?? 0.0))

        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.frame

        blurEffectView.contentView.addSubview(vibrancyEffectView)
        
        self.tapRecognizer.addTarget(self, action: #selector(onTapped(_:)))
        view.addGestureRecognizer(tapRecognizer)
        view.isUserInteractionEnabled = true
        
        return view
    }
    
    @objc func onTapped(_ recognizer: UITapGestureRecognizer) {
        self.presentedViewController.dismiss(animated: true, completion: nil)
        
    }
    
    // different between translation
    var endPointY: CGFloat = -1
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        let endPoint = pan.translation(in: pan.view?.superview)
        //let velocity = pan.velocity(in: pan.view?.superview)
        //print("endPoint \(endPoint)")
        //print("velocity \(velocity)")
        //print("state \(pan.state.description)")
        
        switch pan.state {
        case .changed:
            guard var frame = self.presentedView?.frame else {
                return
            }
            
            // position start change
            if endPointY == -1 {
                endPointY = endPoint.y
                return
            }
            
            // position not change
            if endPointY == endPoint.y {
                return
            }
            
            let deltaY = endPoint.y - endPointY
            //print("deltaY \(deltaY)")
            endPointY = endPoint.y
            frame.origin.y = frame.origin.y + deltaY
            
            if frame.origin.y <= presentY {
                return
            }
            
            //print("frame.origin.y \(frame.origin.y)")
            self.presentedView?.frame = frame
            
            let screenHeight = UIScreen.main.bounds.height
            /*
             a*frame.origin.y + b = scale -> ax + b = y
             x = screenHeight -> y = 1 -> screenHeight*a + b = 1
             x = presentY -> y = maxScaleParentVC -> presentY*a + b = maxScale
             solved by Cramer method
             */
            let scale = ((1 - maxScaleParentVC) / (screenHeight - presentY)) * frame.origin.y + ((screenHeight * maxScaleParentVC) - presentY) / (screenHeight - presentY)
            self.presentingViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        case .ended:
            // reset position
            endPointY = -1
            guard let frame = self.presentedView?.frame else {
                return
            }
            
            let vcHeight = UIScreen.main.bounds.height - frame.origin.y
            if vcHeight <= dismissHeight && isDismissWhenReachDismissHeight {
                self.presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.presentedView?.frame.origin.y = strongSelf.presentY
                    strongSelf.presentingViewController.view.transform = CGAffineTransform(scaleX: strongSelf.maxScaleParentVC, y: strongSelf.maxScaleParentVC)
                }
            }
            
            break
        default:
            break
        }
    }
    
    override func presentationTransitionWillBegin() {
        // setup dimmingView here because container view frame will set in here
        dimmingView = setupDimmingView()
        dimmingView.alpha = 0.0
        containerView?.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.dimmingView.alpha = strongSelf.isDimmingEnabled ? 1 : 0.1
            strongSelf.presentingViewController.view.transform = CGAffineTransform(scaleX: strongSelf.maxScaleParentVC, y: strongSelf.maxScaleParentVC)
            strongSelf.presentingViewController.view.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        }) { context in
        }
        
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else {
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.dimmingView.alpha = 0.0
            strongSelf.presentingViewController.view.transform = .identity
            strongSelf.presentingViewController.view.roundCorners(corners: [.topLeft, .topRight], radius: 0)
        }) { context in
        }
    }
    
}

extension UIGestureRecognizer.State {
    var description: String {
        switch self {
        case .began:
            return "began"
        case .changed:
            return "changed"
        case .ended:
            return "ended"
        case .cancelled:
            return "cancelled"
        case .failed:
            return "failed"
        case .possible:
            return "possible"
        @unknown default:
            return "\(self.rawValue)"
        }
    }
}
