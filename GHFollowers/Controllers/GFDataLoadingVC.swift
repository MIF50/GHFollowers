//
//  GFDataLoadingVC.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/11/20.
//

import UIKit

class GFDataLoadingVC: UIViewController {
    
    var containerView: UIView!
    
    // MARK:- showLoading
    func showLoadingView() {
        configureContainerView()
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
        configureActivityIndicator()
    }
    
    // MARK:- dismissLoading
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    // MARK:- showEmptyState
    func showEmptyStateView(with message: String, in view: UIView) {
        navigationItem.searchController = nil
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    fileprivate func configureContainerView() {
        containerView = UIView(frame: view.bounds)
        view.addSubviews(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0 // Tranparent
    }
    
    fileprivate func configureActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style:  .large)
        containerView.addSubviews(activityIndicator)
        activityIndicator.centerInSuperview()
        activityIndicator.startAnimating()
    }
}
