//
//  segmentControllerClass.swift
//  Music
//
//  Created by Sai Krishna Dubagunta on 12/10/16.
//  Copyright © 2016 Sai Krishna Dubagunta. All rights reserved.
//

import UIKit

@IBDesignable class segementControllerClass: UIControl {
    
    fileprivate var labels = [UILabel]()
    var thumbView = UIView()
    
    var items: [String] = ["Item 1", "Item 2", "Item 3","Item 4","Item 5","Item 6","Item 7"] {
        didSet {
            setupLabels()

        }
    }
    
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    @IBInspectable var selectedLabelColor : UIColor = UIColor.black {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var font : UIFont! = UIFont.systemFont(ofSize: 12) {
        didSet {
            setFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        layer.borderWidth = 2
        backgroundColor = UIColor.clear
        
        setupLabels()
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels(){
        
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            let itemAtIndex = items[index-1];
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: (CGFloat(itemAtIndex.lengthOfBytes(using: String.Encoding.ascii))*font.pointSize), height: 40))
            label.text = items[index - 1]
            label.backgroundColor = uicolorFromHex(rgbValue: 0xEE8624)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth

        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.borderColor = UIColor.clear.cgColor;
        
        displayNewSelectedIndex()
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        var calculatedIndex : Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex(){
        for (_, item) in labels.enumerated() {
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .allowUserInteraction, animations: {
            self.bringSubview(toFront: self.thumbView)
            self.thumbView.frame = CGRect.init(origin: CGPoint.init(x: label.frame.origin.x, y: label.frame.origin.y + 40), size: CGSize.init(width: label.frame.width, height: 4))
            
        }, completion: nil)
    }
    
    func addIndividualItemConstraints(_ items: [UIView], mainView: UIView, padding: CGFloat) {
        
        _ = mainView.constraints
        
        for (index, button) in items.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -padding)
                
            }else{
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: nextButton, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: prevButton, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setSelectedColors(){
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    func setFont(){
        for item in labels {
            item.font = font
        }
    }
}
