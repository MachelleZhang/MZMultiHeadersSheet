# MZMultiHeadersSheet

[![CI Status](http://img.shields.io/travis/machellezhang/MZMultiHeadersSheet.svg?style=flat)](https://travis-ci.org/machellezhang/MZMultiHeadersSheet)
[![Version](https://img.shields.io/cocoapods/v/MZMultiHeadersSheet.svg?style=flat)](http://cocoapods.org/pods/MZMultiHeadersSheet)

## Abstract

自定义UICollectionView的Layout，实现多表头的功能。<br>
![Multi_Headers.gif](/Pictures/multi_header.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0+

## Installation

MZMultiHeadersSheet is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MZMultiHeadersSheet'
```

## Usage<br>
e.g.<br>
![demo_sheet.png](/Pictures/demo_sheet.png)

1.引入头文件

```Objective-C
#import "MZMultiHeadersSheetLayout.h"
```

2.设置代理

```Objective-C
MZMultiHeadersSheetLayout *multiHeadersLayout = [[MZMultiHeadersSheetLayout alloc] init];
multiHeadersLayout.delegate = self;
```

3.需要实现的主要代理方法

```Objective-C
#pragma mark - MZMultiHeadersSheetLayoutDelegate
/**
 *  每个cell的大小，建议同section同高度。次级表头采用（section 0的高度 / 层级数），请适当调整
 */
- (CGSize)mzCollectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(80, 90);
    }
    return CGSizeMake(80, 40);
}

/**
 *  表头的层级
 */
- (NSInteger)levelOfMultiHeadersInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/**
 *  每层表头单个元素所占的格数
 */
- (NSArray *)mzCollectionView:(UICollectionView *)collectionView eachCellWidthOfLevel:(NSInteger)level {
    if (level == 0) {
        return @[@(3), @(6)];
    } else if (level == 1) {
        return @[@(1), @(3), @(2), @(3)];
    } else {
        return @[@(5), @(4)];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 20;
}

/**
 *  每个section元素的个数，注意section 0的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 9;
    }
    return 10;
}
```

## Author

machellezhang, 407916482@qq.com

## License

MZMultiHeadersSheet is available under the MIT license. See the LICENSE file for more info.
