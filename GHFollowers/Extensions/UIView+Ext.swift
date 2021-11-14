//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView ...) {
        for view in views { addSubview(view) }
    }
    
    func pinToEdges(of superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
    ])
    }
    
    // MARK:- Anchor View
    var topAnchor: NSLayoutYAxisAnchor {
        get {
            return safeAreaLayoutGuide.topAnchor
        }
    }
    
    var bottomAnchor: NSLayoutYAxisAnchor {
        get {
            return safeAreaLayoutGuide.bottomAnchor
        }
    }
    
    var leadingAnchor: NSLayoutXAxisAnchor {
        get {
            return safeAreaLayoutGuide.leadingAnchor
        }
    }
    
    var trailingAnchor: NSLayoutXAxisAnchor {
        get {
            return safeAreaLayoutGuide.trailingAnchor
        }
    }
}
