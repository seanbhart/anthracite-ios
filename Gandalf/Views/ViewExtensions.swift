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

class TriangleView : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()

        context.setFillColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.60)
        context.fillPath()
    }
}

class CustomTableViewCell: UITableViewCell {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.endEditing(true)
    }
}
