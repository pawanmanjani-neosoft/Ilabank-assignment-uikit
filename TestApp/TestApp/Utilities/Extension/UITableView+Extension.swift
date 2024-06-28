//
//  UITableView+Extension.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import UIKit

extension UITableView {
    // MARK: Add empty message if no data in tableview
    func showEmptyMessage() {
        let lblMsg = UILabel(frame: self.frame)
        lblMsg.text = "No Data Available"
        lblMsg.textColor = .black
        lblMsg.textAlignment = .center
        lblMsg.tag = 990
        self.addSubview(lblMsg)
    }
    // MARK: removing empty message from tableview
    func removeEmptyMessage() {
        _ = self.subviews.filter({ $0.tag == 990 }).map({ $0.removeFromSuperview() })
    }
}
