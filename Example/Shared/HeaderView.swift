//
//  HeaderView.swift
//  HorizontalStickyHeaderLayout
//
//  Created by Toshihiro Suzuki on 2017/10/31.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    static let reuseID = "HeaderView"
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var container: UIView?
    @IBOutlet weak var containerTop: NSLayoutConstraint?

    func popHeader() {
        updateContainerTop(-20)
    }

    func unpopHeader() {
        updateContainerTop(0)
    }

    private func updateContainerTop(_ constant: CGFloat) {
        guard let containerTop = containerTop, containerTop.constant != constant else {
            return
        }

        containerTop.constant = constant
        self.layoutIfNeeded()
    }
}
