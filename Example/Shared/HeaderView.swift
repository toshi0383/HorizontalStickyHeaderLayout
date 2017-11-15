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
        // EaseOut + 0.5 duration for unpopping animation
        updateContainerTop(0, duration: 0.5)
    }
    private func updateContainerTop(_ constant: CGFloat, duration: Double? = nil) {
        guard let containerTop = containerTop, containerTop.constant != constant else {
            return
        }
        containerTop.constant = constant

        if let duration = duration {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.layoutIfNeeded()
        }
    }
}
