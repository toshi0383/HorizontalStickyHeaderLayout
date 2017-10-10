//
//  CustomLayout.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/10/06.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import UIKit

private struct Layout {
    let indexPath: IndexPath
    let frame: CGRect
    var attributes: UICollectionViewLayoutAttributes {
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.frame = frame
        return attr
    }
}

public protocol HorizontalStickyHeaderLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, hshlSizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, hshlSectionInsetsAtSection section: Int) -> UIEdgeInsets
    func collectionView(_ collectionView: UICollectionView, hshlMinSpacingForCellsAtSection section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, hshlSizeForHeaderAtSection section: Int) -> CGSize
    func collectionView(_ collectionView: UICollectionView, hshlHeaderInsetsAtSection section: Int) -> UIEdgeInsets
}

public final class HorizontalStickyHeaderLayout: UICollectionViewLayout {
    private var cacheForItems = [Layout]()
    public weak var delegate: HorizontalStickyHeaderLayoutDelegate?

    // MARK: UICollectionViewLayout overrides
    public override func prepare() {
        super.prepare()

        // delegate
        if delegate == nil {
            if let d = collectionView?.delegate as? HorizontalStickyHeaderLayoutDelegate {
                delegate = d
            }
        }
        guard let delegate = delegate else {
            fatalError("Delegate is not set.")
        }
        guard let cv = collectionView else {
            fatalError("collectionView is not set.")
        }

        // reset
        cacheForItems.removeAll(keepingCapacity: true)

        // prepare layout for cells
        var x: CGFloat = 0
        for section in 0..<cv.numberOfSections {
            let headerHeight = delegate.collectionView(cv, hshlSizeForHeaderAtSection: section).height
            let headerInsets = delegate.collectionView(cv, hshlHeaderInsetsAtSection: section)
            let sectionInsets: UIEdgeInsets = delegate.collectionView(cv, hshlSectionInsetsAtSection: section)
            x += sectionInsets.left
            let y = headerInsets.top
                + headerHeight
                + headerInsets.bottom
            let minSpacingForCells: CGFloat = delegate.collectionView(cv, hshlMinSpacingForCellsAtSection: section)
            let numberOfItems = cv.numberOfItems(inSection: section)
            for i in 0..<numberOfItems {
                let ip = IndexPath(item: i, section: section)
                let itemSize: CGSize = delegate.collectionView(cv, hshlSizeForItemAtIndexPath: ip)
                let frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                cacheForItems.append(Layout(indexPath: ip, frame: frame))
                x += itemSize.width
                if i != numberOfItems - 1 {
                    x += minSpacingForCells
                }
            }
            x += sectionInsets.right
        }
    }
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let forItems = cacheForItems.filter { rect.intersects($0.frame) }.map { $0.attributes }
        let forHeaders = getAttributesForHeaders()
        return forItems + forHeaders
    }
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheForItems.first { $0.indexPath == indexPath }?.attributes
    }
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == UICollectionElementKindSectionHeader else {
            return nil
        }
        return getAttributesForHeaders().first { $0.indexPath == indexPath }
    }
    public override var collectionViewContentSize: CGSize {
        guard let cv = collectionView, let delegate = delegate else {
            fatalError()
        }
        let maxX = cacheForItems.last?.frame.maxX ?? 0
        let lastSection = cv.numberOfSections - 1
        let sectionInsets: UIEdgeInsets = delegate.collectionView(cv, hshlSectionInsetsAtSection: lastSection)
        let contentWidth = maxX + sectionInsets.right
        let contentHeight = cv.bounds.height - cv.contentInset.top - cv.contentInset.bottom
        return CGSize(width: contentWidth, height: contentHeight)
    }

    /////////////////////////////////////////////////
    // Note: Needed for sticky headers while scroling

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    open override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        guard let cv = collectionView else {
            fatalError()
        }

        let oldBounds = cv.bounds
        let sizeChanged = oldBounds.width != newBounds.width || oldBounds.height != newBounds.height

        let context = super.invalidationContext(forBoundsChange: newBounds)

        if !sizeChanged {
            context.invalidateSupplementaryElements(ofKind: UICollectionElementKindSectionHeader, at: getAttributesForHeaders().map { $0.indexPath })
        }
        return context
    }

    // MARK: Utilities

    /// Calculates sticky frame for header
    /// - returns: UICollectionViewLayoutAttributes for each sections
    private func getAttributesForHeaders() -> [UICollectionViewLayoutAttributes] {
        guard let delegate = delegate, let cv = collectionView else {
            fatalError()
        }
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in 0..<cv.numberOfSections {
            var x: CGFloat = 0
            let headerSize = delegate.collectionView(cv, hshlSizeForHeaderAtSection: section)
            let headerInsets = delegate.collectionView(cv, hshlHeaderInsetsAtSection: section)
            let itemsInsets = delegate.collectionView(cv, hshlSectionInsetsAtSection: section)
            do {
                let numberOfItems = cv.numberOfItems(inSection: section)
                if let firstItemAttributes = cacheForItems.first(where: { $0.indexPath == IndexPath(item: 0, section: section) }),
                    let lastItemAttributes = cacheForItems.first(where: { $0.indexPath == IndexPath(row: numberOfItems - 1, section: section) }) {

                    let edgeX = cv.contentOffset.x + cv.contentInset.left + headerInsets.left
                    let xByLeftBoundary = max(edgeX, firstItemAttributes.frame.minX - itemsInsets.left + headerInsets.left)

                    let xByRightBoundary = (lastItemAttributes.frame.maxX + itemsInsets.right) - headerSize.width - headerInsets.right
                    x += min(xByLeftBoundary, xByRightBoundary)
                }
            }
            let frame = CGRect(x: x,
                               y: headerInsets.top,
                               width: headerSize.width,
                               height: headerSize.height)
            let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                                        with: IndexPath(item: 0, section: section))
            attr.frame = frame
            attributes.append(attr)
            x += headerInsets.right
        }
        return attributes
    }
}
