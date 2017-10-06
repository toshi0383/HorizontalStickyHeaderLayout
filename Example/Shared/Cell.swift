//
//  Cell.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/10/06.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import UIKit

final class Cell: UICollectionViewCell {
    #if os(tvOS)
    override var canBecomeFocused: Bool {
        return true
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            self.backgroundColor = .yellow
        } else {
            self.backgroundColor = .white
        }
    }
    #endif
}
