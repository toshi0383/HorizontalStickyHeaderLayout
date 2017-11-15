# HorizontalStickyHeaderLayout

Horizontal UICollectionViewLayout with Sticky HeaderView

![](https://github.com/toshi0383/assets/blob/master/HorizontalStickyHeaderLayout/hshl-iphone7.gif?raw=true)

![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20tvOS-blue.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)](https://cocoapods.org)
[![pod](https://img.shields.io/cocoapods/v/HorizontalStickyHeaderLayout.svg?style=flat)](https://cocoapods.org/pods/HorizontalStickyHeaderLayout)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

# Requirements
- iOS9+
- tvOS9+

# How to use
Just implement these 5 required delegate methods.

```swift
extension ViewController: HorizontalStickyHeaderLayoutDelegate {
    private enum Const {
        static let headerSize = CGSize(width: 100, height: 38)
        static let itemSize0  = CGSize(width: 50, height: 50)
        static let itemSize1  = CGSize(width: 80, height: 80)
        static let headerLeft: CGFloat = 8
    }
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
    func collectionView(_ collectionView: UICollectionView, hshlHeaderInsetsAtSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Const.headerLeft, bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, hshlMinSpacingForCellsAtSection section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, hshlSectionInsetsAtSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: section == 4 ? 0 : 20)
    }
}
```

Optionally you can define `contentInset` for outer margin.

![](https://github.com/toshi0383/assets/raw/master/HorizontalStickyHeaderLayout/layout-definitions.png)

See [Example](Example) for detail.

# Animated header Y position for tvOS for free!
![](https://github.com/toshi0383/assets/blob/master/HorizontalStickyHeaderLayout/sticky-animated-header-for-tvos.gif?raw=true)

## How to implement
- On focus, call `updatePoppingHeaderIndexPaths()` to recalculate the popping header indexPaths to get the latest indexPaths.
- Listen to pop indexPaths change on scroll by implementing `collectionView(_:,hshlDidUpdatePoppingHeaderIndexPaths:)` delegate method.
- animate container view of your header view.

See [Example](Example) for recommended implementation.

```swift
    // Either in UICollectionViewDelegate or this override method.
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        layout.updatePoppingHeaderIndexPaths()
        let (pop, unpop) = self.getHeaders(poppingHeadersIndexPaths: self.layout.poppingHeaderIndexPaths)
        UIView.animate(withDuration: Const.unpopDuration, delay: 0, options: [.curveEaseOut], animations: {
            unpop.forEach { $0.unpopHeader() }
        }, completion: nil)
        coordinator.addCoordinatedAnimations({
            pop.forEach { $0.popHeader() }
        }, completion: nil)
        super.didUpdateFocus(in: context, with: coordinator)
    }

    func collectionView(_ collectionView: UICollectionView, hshlDidUpdatePoppingHeaderIndexPaths indexPaths: [IndexPath]) {
        let (pop, unpop) = self.getHeaders(poppingHeadersIndexPaths: self.layout.poppingHeaderIndexPaths)
        UIView.animate(withDuration: Const.unpopDuration, delay: 0, options: [.curveEaseOut], animations: {
            unpop.forEach { $0.unpopHeader() }
            pop.forEach { $0.popHeader() }
        }, completion: nil)
    }
```

# Install
## Carthage
```
github "toshi0383/HorizontalStickyHeaderLayout"
```

## CocoaPods
```
pod "HorizontalStickyHeaderLayout"
```

# Development
- Xcode9.1
- Swift4.0.2

# License
MIT
