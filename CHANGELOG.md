## 0.5.0

##### Breaking

* Update `SWIFT_VERSION` to `5.0`
  - https://github.com/toshi0383/HorizontalStickyHeaderLayout/pull/13 by [@airspeed](https://github.com/airspeed)
  - https://github.com/toshi0383/HorizontalStickyHeaderLayout/pull/14

## 0.4.0
##### Breaking
* [tvOS] Pop header using container view, not HeaderView itself [#10](https://github.com/toshi0383/HorizontalStickyHeaderLayout/pull/10) [@toshi0383](https://github.com/toshi0383)

##### Bugfix
* [tvOS] Unwanted moving header on fast scroll [#5](https://github.com/toshi0383/HorizontalStickyHeaderLayout/issues/5)
* [tvOS] Cell's sometimes not displayed when popping header is enabled [#9](https://github.com/toshi0383/HorizontalStickyHeaderLayout/issues/9)
* [tvOS] Notify on poppingHeaderIndexPaths change on scroll [#11](https://github.com/toshi0383/HorizontalStickyHeaderLayout/pull/11) [@toshi0383](https://github.com/toshi0383)

## 0.3.3
##### Bugfix
* [tvOS] Fix unwanted popping header 2 [#7](https://github.com/toshi0383/HorizontalStickyHeaderLayout/pull/7) [@toshi0383](https://github.com/toshi0383)

## 0.3.2
##### Bugfix
* [tvOS] Fix unwanted popping header [#6](https://github.com/toshi0383/HorizontalStickyHeaderLayout/pull/6) [@toshi0383](https://github.com/toshi0383)

## 0.3.1
##### Bugfix
* [tvOS] Fix unwanted scrolling header [#3](https://github.com/toshi0383/HorizontalStickyHeaderLayout/pull/3) [@toshi0383](https://github.com/toshi0383)

## 0.3.0
##### Feature
* [tvOS] Animate Header PositionY for tvOS Focus [#2](https://github.com/toshi0383/HorizontalStickyHeaderLayout/pull/2) [@toshi0383](https://github.com/toshi0383)

## 0.2.0
##### Bugfix
* Layout was not treating `collectionView.contentInset` collectly.  
  Use custom field for contentInset, not collectionView.contentInset.  
  `collectionView.contentInset` changes before layout.

## 0.1.3
##### Bugfix
* Fixed wrong header insets

## 0.1.2
##### Bugfix
* Fixed wrong spacing between headers

