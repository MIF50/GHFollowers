//
//  GFAlertVC.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import UIKit

class GFAlertVC: UIViewController {

    // MARK:- Views
    let containerView = GFContainerView()
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GFBodyLabel(textAlignment: .center)
    let actionButton = GFButton(backgroundColor: .systemPink, title: "Ok")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubviews(containerView, titleLabel, actionButton, messageLabel)
        
        configureContainerView()
        configureTitleLabel()
        configureMessageLabel()
        configureActionButton()
    }
    
    fileprivate func configureContainerView() {
        containerView.size(width: 280, height: 220)
        containerView.centerInSuperview()
    }
    
    fileprivate func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong"
        titleLabel.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: padding, left: padding, bottom: 0, right: padding),
            size: .init(width: 0, height: 28)
        )
    }
    
    fileprivate func configureMessageLabel() {
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        messageLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: actionButton.topAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 8, left: padding, bottom: 12, right: padding)
        )
    }
    
    fileprivate func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        actionButton.anchor(
            top: nil,
            leading: containerView.leadingAnchor,
            bottom: containerView.bottomAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 0, left: padding, bottom: padding, right: padding),
            size: .init(width: 0, height: 44)
        )
    }

    // MARK:- Actions
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
