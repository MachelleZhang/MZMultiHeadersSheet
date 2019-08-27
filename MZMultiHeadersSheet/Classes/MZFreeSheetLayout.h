//
//  MZFreeSheetLayout.h
//  MZMultiHeadersSheet
//
//  Created by zhangle on 16/4/6.
//  Copyright © 2018年 Machelle. All rights reserved.
//
/**
 * 自由表格布局
 */
#import <UIKit/UIKit.h>
@protocol MZFreeSheetLayoutDelegate <NSObject>

@required
/**
 *  表格的基本宽度，1个单位长度实际的像素值，格式(float, float)，例：(50, 50)
 */
- (CGSize)baseSizeOfCollectionView:(UICollectionView *)collectionView;

/**
 *  表格的规模大小，格式(int, int)，例：(4, 5)，表示表格总体宽4个单位，高5个单位
 */
- (CGSize)scaleOfCollectionView:(UICollectionView *)collectionView;

/**
 *  每个cell的大小，用单位个数表示，格式(int, int)，例：(2, 1)，表示当前索引的元素宽2个单位，高1个单位
 */
- (CGSize)mzCollectionView:(UICollectionView *)collectionView cellSizeOfIndex:(NSInteger)index;

@optional
/**
 *  需要冻结的行列，格式(int, int)，例：(1,1)，表示第0行和第0列被冻结，可参照Excel的冻结规则
 */
- (CGSize)frozenUnitOfCollection:(UICollectionView *)collectionView;

@end

@interface MZFreeSheetLayout : UICollectionViewLayout

@property(nonatomic, weak) id<MZFreeSheetLayoutDelegate> delegate;

/** 整个表格的边距 */
@property (nonatomic, assign) CGFloat itemMargin;

/** item之间的间隔 */
@property (nonatomic, assign) CGFloat itemSpacing;

@end
