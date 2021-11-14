//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread(){
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessCells(){
        tableFooterView = UIView(frame: .zero)
    }
}
