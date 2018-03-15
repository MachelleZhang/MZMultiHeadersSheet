//
//  MZMultiHeadersSheetLayout.h
//  MZMultiHeadersSheet
//
//  Created by zhangle on 16/4/6.
//  Copyright © 2018年 Machelle. All rights reserved.
//
/**
 * 多表头布局
 */
#import <UIKit/UIKit.h>
@protocol MZMultiHeadersSheetLayoutDelegate <NSObject>

@required
/**
 *  @brief 获取cell的size
 */
- (CGSize)mzCollectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief 次级表头的总层数
 */
- (NSInteger)levelOfMultiHeadersInCollectionView:(UICollectionView *)collectionView;

/**
 *  @brief 每层表头单个元素所占的格数
 */
- (NSArray *)mzCollectionView:(UICollectionView *)collectionView eachCellWidthOfLevel:(NSInteger)level;

@end

@interface MZMultiHeadersSheetLayout : UICollectionViewLayout

@property(nonatomic, weak) id<MZMultiHeadersSheetLayoutDelegate> delegate;

@end
