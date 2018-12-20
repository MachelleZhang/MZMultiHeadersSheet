# MZMultiHeadersSheet

[![CI Status](http://img.shields.io/travis/machellezhang/MZMultiHeadersSheet.svg?style=flat)](https://travis-ci.org/machellezhang/MZMultiHeadersSheet)
[![Version](https://img.shields.io/cocoapods/v/MZMultiHeadersSheet.svg?style=flat)](http://cocoapods.org/pods/MZMultiHeadersSheet)

## Abstract

自定义UICollectionView的Layout，实现类似Excel的功能。<br>
1.MZMultiHeadersSheetLayout<br>
仅第一行为多表头的布局。可实现普通的带冻结效果的滚动表格<br>
2.MZFreeLayout<br>
类似Excel表格的自由布局。可实现第一种布局的效果。<br>
![Multi_Headers.gif](/Pictures/multi_header.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0+

## Installation

MZMultiHeadersSheet is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MZMultiHeadersSheet', '~> 0.2.1'
```

## Usage<br>
#### MZMultiHeadersSheetLayout<br>
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

#### MZFreeSheetLayout<br>
e.g.<br>
![free_layout.png](/Pictures/free_layout.png)<br>
在已知表格样式的前提下，按从左到右，从上到下，依次添加索引，已编号的掠过，参考上图的索引规则<br>

1.引入头文件

```Objective-C
#import "MZFreeSheetLayout.h"
```

2.设置代理

```Objective-C
MZFreeSheetLayout *freeLayout = [[MZFreeSheetLayout alloc] init];
freeLayout = self;
```

3.需要实现的主要代理方法

```Objective-C
#pragma mark - MZFreeSheetLayoutDelegate
/**
 *  表格的基本宽度，1个单位长度实际的像素值，格式(float, float)，例：(50, 50)
 */
- (CGSize)baseSizeOfCollectionView:(UICollectionView *)collectionView {
    return CGSizeMake(100, 200);
}

/**
 *  表格的规模大小，格式(int, int)，例：(4, 5)，表示表格总体宽4个单位，高5个单位
 */
- (CGSize)scaleOfCollectionView:(UICollectionView *)collectionView {
    return CGSizeMake(5, 5);
}

/**
 *  每个cell的大小，用单位个数表示，格式(int, int)，例：(2, 1)，表示当前索引的元素宽2个单位，高1个单位
 */
- (CGSize)mzCollectionView:(UICollectionView *)collectionView cellSizeOfIndex:(NSInteger)index {
    NSArray *cellSize = self.datas[index];
    NSInteger width = ((NSNumber *)cellSize[0]).integerValue;
    NSInteger height = ((NSNumber *)cellSize[1]).integerValue;
    return CGSizeMake(width, height);
}

/**
 *  需要冻结的行列，格式(int, int)，例：(1,0)，表示第1列被冻结，可参照Excel的冻结规则
 */
- (CGSize)frozenUnitOfCollection:(UICollectionView *)collectionView {
    return CGSizeMake(1, 0);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}
```

## Author

machellezhang, 407916482@qq.com

## License

MZMultiHeadersSheet is available under the MIT license. See the LICENSE file for more info.
