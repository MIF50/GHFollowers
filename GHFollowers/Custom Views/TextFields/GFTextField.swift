//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        placeholder = "Enter a username"
        shape()
        style()
        inputTextTraits()
    }
    
    fileprivate func shape() {
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    fileprivate func style() {
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        minimumFontSize = 12
        adjustsFontSizeToFitWidth = true
        backgroundColor = .tertiarySystemBackground
    }
    
    fileprivate func inputTextTraits() {
        autocorrectionType = .no
        returnKeyType = .go
        clearButtonMode = .whileEditing
    }
}

