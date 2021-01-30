//
//  ViewExtensions.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import UIKit

extension UIViewController {
    func presentOnRoot(`with` viewController : UIViewController){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(navigationController, animated: false, completion: nil)
    }
    func presentSheet(`with` viewController : UIViewController){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        navigationController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(navigationController, animated: true, completion: nil)
    }
    func presentSheetFixed(`with` viewController : UIViewController){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        navigationController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        navigationController.isModalInPresentation = true
        self.present(navigationController, animated: true, completion: nil)
    }
}

class ProgressViewRoundedLeft: UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomLeft, .topLeft], radius: 0.0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

class ProgressViewRoundedRight: UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomRight, .topRight], radius: 0.0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
