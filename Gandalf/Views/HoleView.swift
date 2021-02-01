//
//  HoleView.swift
//
//  Created by Sean Hart on 9/2/17.
//  Copyright © 2017 TangoJ Labs, LLC. All rights reserved.
//

import UIKit

// Create a protocol with functions declared in other View Controllers implementing this protocol (delegate)
protocol HoleViewDelegate
{
    func holeViewRemoved(removingViewAtPosition: Int)
}

class HoleView: UIView
{
    var className = "HoleView"
    // Add a delegate variable which the parent view controller can pass its own delegate instance to and have access to the protocol
    // (and have its own functions called that are listed in the protocol)
    var holeViewDelegate: HoleViewDelegate?
    
    // Indicate the order of the Hole Views (start at 1)
    var holeViewPosition: Int!
    
//    var viewFrame : CGRect!
    var circleOffsetX: CGFloat!
    var circleOffsetY: CGFloat!
    var circleRadius: CGFloat!
    var textOffsetX: CGFloat!
    var textOffsetY: CGFloat!
    var textWidth: CGFloat!
    var textFontSize: CGFloat!
    var text: String!
    
    
    // MARK: -Initialization
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    required init(holeViewPosition: Int, frame : CGRect, circleOffsetX: CGFloat, circleOffsetY: CGFloat, circleRadius: CGFloat, textOffsetX: CGFloat, textOffsetY: CGFloat, textWidth: CGFloat, textFontSize: CGFloat, text: String)
    {
        self.holeViewPosition = holeViewPosition
//        self.viewFrame = frame
        self.circleOffsetX = circleOffsetX
        self.circleOffsetY = circleOffsetY
        self.circleRadius = circleRadius
        self.textOffsetX = textOffsetX
        self.textOffsetY = textOffsetY
        self.textWidth = textWidth
        self.textFontSize = textFontSize
        self.text = text
        
        super.init(frame: frame)
        
        createView()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    
    // MARK: -Drawing
    
    func createView()
    {
        print("\(className) - FRAME: \(frame)")
        let overlayView = UIView(frame: frame)
        overlayView.alpha = 0.85
        overlayView.backgroundColor = UIColor.black
        self.addSubview(overlayView)
        
        // Create a path with the rectangle in it.
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: circleOffsetX, y: circleOffsetY), radius: circleRadius, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
        path.addRect(CGRect(x: 0, y: 0, width: overlayView.frame.width, height: overlayView.frame.height))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path;
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // Release the path since it's not covered by ARC.
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        let overlayTextView = UITextView(frame: CGRect(x: textOffsetX, y: textOffsetY, width: textWidth, height: overlayView.frame.height - textOffsetY))
        overlayTextView.backgroundColor = UIColor.clear
        overlayTextView.isEditable = false
        overlayTextView.isScrollEnabled = false
        overlayTextView.font = UIFont(name: Assets.Fonts.Default.bold, size: textFontSize)
        overlayTextView.textAlignment = .center
        overlayTextView.textColor = UIColor.white
        overlayTextView.text = text
        overlayTextView.isUserInteractionEnabled = false
        overlayView.addSubview(overlayTextView)
        
        let overlayViewTap = UITapGestureRecognizer(target: self, action: #selector(okViewTapGesture))
        overlayViewTap.numberOfTapsRequired = 1  // add single tap
        overlayView.addGestureRecognizer(overlayViewTap)
        
//        let okViewBackground = UIView(frame: CGRect(x: 0, y: overlayView.frame.height - 150, width: overlayView.frame.width, height: 50))
//        okViewBackground.backgroundColor = UIColor.darkGray
//        okViewBackground.alpha = 0.8
////        overlayView.addSubview(okViewBackground)
//
//        let okViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: okViewBackground.frame.width, height: okViewBackground.frame.height))
//        okViewLabel.font = UIFont(name: Constants.Strings.fontAlt, size: 22)
//        okViewLabel.textColor = UIColor.white
//        okViewLabel.textAlignment = NSTextAlignment.center
//        okViewLabel.numberOfLines = 1
//        okViewLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//        okViewLabel.text = "Got it."
//        okViewBackground.addSubview(okViewLabel)
//
//        let okViewTap = UITapGestureRecognizer(target: self, action: #selector(HoleView.okViewTapGesture(_:)))
//        okViewTap.numberOfTapsRequired = 1  // add single tap
//        okViewBackground.addGestureRecognizer(okViewTap)
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func okViewTapGesture(_ sender: UITapGestureRecognizer)
    {
        self.removeFromSuperview()
        
        // Call the parent VC to notify the view has been removed
        if let parentVC = self.holeViewDelegate
        {
            parentVC.holeViewRemoved(removingViewAtPosition: self.holeViewPosition)
        }
    }
}
