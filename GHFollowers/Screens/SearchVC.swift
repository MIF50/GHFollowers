//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/11/20.
//

import UIKit

class SearchVC: UIViewController {
    
    // MARK:- views
    let logoImageView = UIImageView()
    let userNameTextField = GFTextField()
    let getFollowersButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUserNameEntered: Bool {
        return !userNameTextField.unwrappedText.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configureLogoImageView()
        configureTextField()
        configureGetFollowersButton()
        closeKeyboardOnTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    private func initView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView,userNameTextField,getFollowersButton)
    }
    
    fileprivate func configureLogoImageView() {
        logoImageView.image = Images.ghLogo
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        let padding = UIEdgeInsets.init(top: topConstraintConstant, left: 0, bottom: 0, right: 0)
        logoImageView.centerXInSuperview()
        logoImageView.anchor(
            top: view.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: nil,
            padding: padding,
            size: .init(width: 200, height: 200) )
    }
    
    fileprivate func configureTextField() {
        userNameTextField.delegate = self
        let padding = UIEdgeInsets.init(top: 48, left: 50, bottom: 0, right: 50)
        userNameTextField.anchor(
            top: logoImageView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: padding,
            size: .init(width: 0, height: 50)
            )
    }
    
    fileprivate func configureGetFollowersButton() {
        getFollowersButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        let padding = UIEdgeInsets.init(top: 0, left: 50, bottom: 50, right: 50)
        getFollowersButton.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: padding,
            size: .init(width: 0, height: 50)
        )
    }
    
    // MARK:- Actions
    @objc func pushFollowerListVC() {
        if !isUserNameEntered {
            presentGFAlertOnMainThread(
                title: "Empty Username",
                message: "Please enter a username. We need to know who to look for 😊.",
                buttonTitle: "OK"
            )
            return
        }
        
        userNameTextField.resignFirstResponder()
        
        let followerListVC = FollowerListVC(userName: userNameTextField.unwrappedText)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}

extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}

// MARK:- create UINavigationController for SearchVC
extension SearchVC {
    
    static func create()-> SearchVC {
        let vc = SearchVC()
        vc.title = "Search"
        return vc
    }
}
