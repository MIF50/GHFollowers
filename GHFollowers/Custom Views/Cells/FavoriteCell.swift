//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import UIKit

class FavoriteCell: UITableViewCell {

    static let reuseID = "FavoriteCell"
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let userNameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: Follower) {
        userNameLabel.text = favorite.login
        avatarImageView.downloadImage(fromURL: favorite.avatarUrl)
    }
    
    private func configure() {
        addSubviews(avatarImageView, userNameLabel)
        
        // Tappable
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        avatarImageView.centerYInSuperview()
        avatarImageView.anchor(leading: self.leadingAnchor,left: padding)
        avatarImageView.size(width: 60, height: 60)
        
        userNameLabel.centerYInSuperview()
        userNameLabel.anchor(leading: avatarImageView.trailingAnchor, trailing: self.trailingAnchor,left: 24,right: padding)
        userNameLabel.constrainHeight(constant: 40)
        
    }
}

