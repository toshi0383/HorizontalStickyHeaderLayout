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
    @IBOutlet private weak var imageview: UIImageView!
    private var task: URLSessionTask?

    var thumbnailURL: URL! {
        didSet {
            self.task?.cancel()
            self.imageview.image = nil
            let task = URLSession.shared.dataTask(with: thumbnailURL) { [weak self] data, _, _ in
                guard let me = self, let data = data else { return }
                DispatchQueue.main.async { [weak me] in
                    me?.imageview.image = UIImage(data: data)
                }
            }
            self.task = task
            task.resume()
        }
    }

    override var canBecomeFocused: Bool {
        return true
    }
    #endif
}
