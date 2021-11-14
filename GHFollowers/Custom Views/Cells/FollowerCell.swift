//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let reuseID = "FollowerCell"
    
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let userNameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        userNameLabel.text = follower.login
        avatarImageView.downloadImage(fromURL: follower.avatarUrl)
    }
    
    private func configure() {
        addSubviews(avatarImageView, userNameLabel)
        
        let padding: CGFloat = 8
        
        avatarImageView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: padding, left: padding, bottom: 0, right: padding)
        )
        avatarImageView.constrainHeight(anchor: avatarImageView.widthAnchor)
        
        userNameLabel.anchor(
            top: avatarImageView.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 12, left: padding, bottom: 0, right: padding)
        )
        userNameLabel.constrainHeight(constant: 20)
    }
    
}

