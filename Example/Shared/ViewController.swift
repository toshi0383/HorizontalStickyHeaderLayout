//
//  ViewController.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/10/06.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import UIKit
import HorizontalStickyHeaderLayout

class Section {
    var items: [Int]
    init(items: [Int]) {
        self.items = items
    }
}

class ViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            if #available(iOS 11.0, *) {
                collectionView.contentInsetAdjustmentBehavior = .never
            }
        }
    }
    private var sections: [Section] = (0..<5).map { _ in Section(items: (0..<1).map { $0 }) }
    @IBAction private func add() {
        let ips = (0..<5).map { IndexPath(item: sections[$0].items.count, section: $0) }
        for s in sections {
            s.items.append(s.items.count)
        }
        collectionView.insertItems(at: ips)
    }
    @IBAction private func delete() {
        let ips = (0..<5).map { IndexPath(item: sections[$0].items.count - 1, section: $0) }
        for s in sections {
            s.items.removeLast()
        }
        collectionView.deleteItems(at: ips)
    }
    @IBAction private func addSection() {
        sections.insert(Section(items: [0]), at: 0)
        collectionView.insertSections(IndexSet(integer: 0))
    }
    @IBAction private func deleteSection() {
        sections.remove(at: 0)
        collectionView.deleteSections(IndexSet(integer: 0))
    }
    @IBAction private func batchUpdate() {
        let deletes = (0..<sections.count).map { IndexPath(item: 2, section: $0) }
        for s in sections {
            s.items.remove(at: 2)
        }
        let add1 = (0..<sections.count).map { IndexPath(item: sections[$0].items.count, section: $0) }
        for s in sections {
            s.items.append(s.items.count)
        }
        let add2 = (0..<sections.count).map { IndexPath(item: sections[$0].items.count, section: $0) }
        for s in sections {
            s.items.append(s.items.count)
        }
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: deletes)
            self.collectionView.insertItems(at: add1 + add2)
        }, completion: nil)
    }
    @IBOutlet weak var layout: HorizontalStickyHeaderLayout! {
        didSet {
            layout.delegate = self
            #if os(tvOS)
                layout.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            #endif
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self // automatically detected if it conforms to HorizontalStickyHeaderLayoutDelegate
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let nib = UINib(nibName: "HeaderView", bundle: .main)
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.backgroundColor = .white
        #if os(tvOS)
            cell.thumbnailURL = URL(string: "https://github.com/toshi0383/assets/raw/master/images/Italy\(sections[indexPath.section].items[indexPath.item] % 5 + 1).jpg")!
        #endif
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
        v.backgroundColor = indexPath.section % 2 == 0 ? .orange : .green
        return v
    }
}

// MARK: HorizontalStickyHeaderLayoutDelegate
extension ViewController: HorizontalStickyHeaderLayoutDelegate {
    #if os(tvOS)
    private enum Const {
        static let headerSize = CGSize(width: 351, height: 38)
        static let itemSize0  = CGSize(width: 447, height: 454)
        static let itemSize1  = CGSize(width: 447, height: 322)
        static let spacingForItems: CGFloat = 60
    }
    #elseif os(iOS)
    private enum Const {
        static let headerSize = CGSize(width: 100, height: 38)
        static let itemSize0  = CGSize(width: 50, height: 50)
        static let itemSize1  = CGSize(width: 80, height: 80)
        static let spacingForItems: CGFloat = 30
    }
    #endif

    // Size
    func collectionView(_ collectionView: UICollectionView, hshlSizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if indexPath.section % 2 == 0 {
            return Const.itemSize0
        } else {
            return Const.itemSize1
        }
    }
    func collectionView(_ collectionView: UICollectionView, hshlSizeForHeaderAtSection section: Int) -> CGSize {
        return Const.headerSize
    }

    // Spacing
    func collectionView(_ collectionView: UICollectionView, hshlMinSpacingForCellsAtSection section: Int) -> CGFloat {
        return Const.spacingForItems
    }

    // Insets
    func collectionView(_ collectionView: UICollectionView, hshlHeaderInsetsAtSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: Const.spacingForItems, bottom: 20, right: Const.spacingForItems)
    }
    func collectionView(_ collectionView: UICollectionView, hshlSectionInsetsAtSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Const.spacingForItems, bottom: 0, right: section == 4 ? 0 : Const.spacingForItems)
    }
}

// MARK: Focus
extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard context.nextFocusedIndexPath != nil || context.previouslyFocusedIndexPath != nil else {
            return
        }
        self.collectionView.collectionViewLayout.invalidateLayout()
        coordinator.addCoordinatedAnimations({
            self.collectionView.layoutIfNeeded()
        }, completion: nil)
    }
}
