//
//  UIView+Ext.swift
//  HabitMind
//
//  Created by Elnur Valizada on 07.08.25.
//

import UIKit


extension UIView {
    var topConstraint: NSLayoutConstraint? {
        get {
            allConstraints.filter {$0.firstAttribute == .top}.filter { $0.firstItem === self}.first
        }
    }
    
    var mainTopConstraint: NSLayoutConstraint? {
        get {
            constraints.filter {$0.firstAttribute == .top}.first
        }
    }
    
    var bottomConstraint: NSLayoutConstraint? {
        get {
            allConstraints.filter {$0.firstAttribute == .bottom}.first
        }
    }
    
    var leadingConstraint: NSLayoutConstraint? {
        get {
            allConstraints.filter {$0.firstAttribute == .leading}.first
        }
    }
    
    var trailingConstraint: NSLayoutConstraint? {
        get {
            allConstraints.filter {$0.firstAttribute == .trailing}.first
        }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            allConstraints.filter {$0.firstAttribute == .height}.first
        }
    }

    
    var centerYConstraint: NSLayoutConstraint? {
        get {
            allConstraints.filter {$0.firstAttribute == .centerY}.first
        }
    }
    
    var centerXConstraint: NSLayoutConstraint? {
        get {
            allConstraints.filter {$0.firstAttribute == .centerX}.first
        }
    }
    
    func setConstraints(topAnchor: NSLayoutYAxisAnchor? = nil, bottomAnchor: NSLayoutYAxisAnchor? = nil, leadingAnchor: NSLayoutXAxisAnchor? = nil, trailingAnchor: NSLayoutXAxisAnchor? = nil, centerYAnchor: NSLayoutYAxisAnchor? = nil, centerYConstant: CGFloat = 0, centerXAnchor: NSLayoutXAxisAnchor? = nil, centerXConstant: CGFloat = 0, topConstant: CGFloat = 0, bottomConstant: CGFloat = 0, leadingConstant: CGFloat = 0, trailingConstant: CGFloat = 0, width: CGFloat? = nil, widthAnchor: NSLayoutDimension? = nil, widthAnchorConstant: CGFloat? = nil, height: CGFloat? = nil, heightAnchor: NSLayoutDimension? = nil, heightAnchorConstant: CGFloat? = nil) {
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        }
        
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant).isActive = true
        }
        
        if let leadingAnchor = leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant).isActive = true
        }
        
        if let trailingAnchor = trailingAnchor {
            self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant).isActive = true
        }
        
        if let centerYAnchor = centerYAnchor {
            self.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYConstant).isActive = true
        }
        
        if let centerXAnchor = centerXAnchor {
            self.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXConstant).isActive = true
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let widthAnchor = widthAnchor {
            if let constant = widthAnchorConstant {
                self.widthAnchor.constraint(equalTo: widthAnchor, constant: constant).isActive = true
            } else {
                self.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            }
        }
        
        if let heightAnchor = heightAnchor {
            if let constant = heightAnchorConstant {
                self.heightAnchor.constraint(equalTo: heightAnchor, constant: constant).isActive = true
            } else {
                self.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            }
        }
    }
    
}




extension UIView {
    var allConstraints: [NSLayoutConstraint] {
        get {
            var views = [self]
            
            var view = self
            while let superview = view.superview {
                views.append(superview)
                view = superview
            }
            
            return views.flatMap({ $0.constraints }).filter { constraint in
                return constraint.firstItem as? UIView == self ||
                constraint.secondItem as? UIView == self
            }
        }
    }
}
