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

# Animated header position for tvOS for free!
![](https://github.com/toshi0383/assets/blob/master/HorizontalStickyHeaderLayout/sticky-animated-header-for-tvos.gif?raw=true)

Currently `invalidateLayout()` call is required. Call it and then `layoutIfNeeded()` inside coordinatedAnimation block to correctly trigger animate.

```swift
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
        coordinator.addCoordinatedAnimations({
            self.collectionView.layoutIfNeeded()
        }, completion: nil)
    }
```

Modify `headerYDeltaOnFocus` as you need.
```swift
    (collectionView.collectionViewLayout as? HorizontalStickyHeaderLayout)!.headerYDeltaOnFocus = -25
```

# Install
## Carthage
```
github "toshi0383/HorizontalStickyHeaderLayout"
```

# Development
- Xcode9
- Swift4

# License
MIT
