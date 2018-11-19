//
//  MZMultiHeadersSheetLayout.m
//  MZMultiHeadersSheet
//
//  Created by zhangle on 16/4/6.
//  Copyright © 2018年 Machelle. All rights reserved.
//

#import "MZMultiHeadersSheetLayout.h"

@interface MZMultiHeadersSheetLayout ()

@property(strong, nonatomic) NSMutableArray *itemAttributes;
@property(nonatomic, assign) CGSize contentSize;

@end

@implementation MZMultiHeadersSheetLayout

/**
 *  自定义布局
 */
- (void)prepareLayout {
    // 有无数据都需要初始化，因为有复用
    self.itemAttributes = [NSMutableArray array];
    //没有元素，直接返回
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    //已经计算过属性后，可以不用再次计算，直接使用保存在itemAttributes里的布局属性，这里由于显示bug，没有复用，每次都进行计算

    CGFloat xOffset = 0.0;       //元素的x坐标
    CGFloat yOffset = 0.0;       //元素的y坐标
    CGFloat contentWidth = 0.0;  // content size的宽度
    CGFloat contentHeight = 0.0; // content size的高度
    
    NSInteger curS0Index = 0; //section 0 当前次级表头索引位置，用于表头坐标计算
    NSInteger curS0Level = 0; //section 0 当前次级表头的层级
    NSInteger curS0WidthStart = 1; //section 0 当前宽度计算的起始点
    NSInteger levelOfHeader = [self levelOfMultiHeadersInCollectionView:self.collectionView];
    CGFloat heightOfHeader = [self mzCollectionView:self.collectionView sizeForItemAtIndexPath:
                              [NSIndexPath indexPathForRow:0 inSection:0]].height / levelOfHeader;
    
    //设置每个cell的布局属性
    for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
        NSMutableArray *sectionAttributes = [NSMutableArray array];
        for (int index = 0; index < [self.collectionView numberOfItemsInSection:section]; index++) {
            //根据位置创建index path
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
            //section 0和其他行分开计算
            if (section == 0 && index != 0) {
                NSArray *curLevelHeader = [self mzCollectionView:self.collectionView eachCellWidthOfLevel:curS0Level];
                NSInteger curS0WidthCount = [[curLevelHeader objectAtIndex:curS0Index] integerValue]; //所占格数
                NSInteger curS0WidthEnd = curS0WidthStart + curS0WidthCount - 1;
                CGFloat curItemWidth = 0.0;
                for (; curS0WidthStart <= curS0WidthEnd; curS0WidthStart++) {
                    curItemWidth += [self mzCollectionView:self.collectionView sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:curS0WidthStart inSection:0]].width;
                }
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                //设置attributes
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, curItemWidth, heightOfHeader));
                attributes.zIndex = 1023;
                //冻结第一行，原理：元素的y值等于content的y偏移量
                if (self.collectionView.contentOffset.y >= 0) {
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y + curS0Level * heightOfHeader;
                    attributes.frame = frame;
                }
                //添加到属性数组中
                [sectionAttributes addObject:attributes];
                //同一行下一个cell的坐标
                curS0Index += 1;
                xOffset += curItemWidth;
                //一行结束时，重置x坐标，增加y坐标，开始下一行的属性设置
                if (curS0Index == curLevelHeader.count) {
                    //设置content的width
                    if (xOffset > contentWidth) {
                        contentWidth = xOffset;
                    }
                    curS0Index = 0;
                    curS0Level += 1;
                    //表头结束，恢复x坐标
                    if (curS0Level == levelOfHeader) {
                        xOffset = 0;
                    } else {
                        xOffset = [self mzCollectionView:self.collectionView sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].width;
                    }
                    yOffset += heightOfHeader;
                }
            } else {
                //取得cell的大小
                CGSize curItemSize = [self mzCollectionView:self.collectionView sizeForItemAtIndexPath:indexPath];
                //根据index path创建attributes
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                //设置attributes
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, curItemSize.width, curItemSize.height));
                //第一行和第一列的zIndex设置高一点，以免滚动时发生遮挡
                if (section == 0 && index == 0) {
                    attributes.zIndex = 1024;
                } else if (section == 0 || index == 0) {
                    attributes.zIndex = 1023;
                }
                //冻结第一行，原理：元素的y值等于content的y偏移量
                if (section == 0 && self.collectionView.contentOffset.y >= 0) {
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    attributes.frame = frame;
                }
                //冻结第一列，原理：元素的x值等于content的x偏移量
                if (index == 0 && self.collectionView.contentOffset.x >= 0) {
                    CGRect frame = attributes.frame;
                    frame.origin.x = self.collectionView.contentOffset.x;
                    attributes.frame = frame;
                }
                //添加到属性数组中
                [sectionAttributes addObject:attributes];
                //同一行下一个cell的坐标
                xOffset += curItemSize.width;
                if (section == 0 && index == 0) {
                    yOffset = 0.0;
                }
                //一行结束时，重置x坐标，增加y坐标，开始下一行的属性设置
                if (index + 1 == [self.collectionView numberOfItemsInSection:section]) {
                    //设置content的width
                    if (xOffset > contentWidth) {
                        contentWidth = xOffset;
                    }
                    xOffset = 0;
                    yOffset += curItemSize.height;
                }
            }
        }
        
        //将一行的属性数组加入总的数组中
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    //所有属性设置完成后，通过最后一个元素确定content的height
    UICollectionViewLayoutAttributes *lastAttributes = [[self.itemAttributes lastObject] lastObject];
    contentHeight = lastAttributes.frame.origin.y + lastAttributes.frame.size.height;
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
}

/**
 *  返回在指定rect内的布局属性
 *  这里是通过判断元素的frame和rect是否有交集来确定是否需要显示
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:
         [section filteredArrayUsingPredicate:
          [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            return CGRectIntersectsRect( rect, [evaluatedObject frame]);
        }]]];
    }
    return attributes;
}

/**
 *  返回每个位置的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemAttributes[indexPath.section][indexPath.row];
}

/**
 *  返回整个content size的大小
 */
- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

/**
 *  当边界值改变时，是否刷新
 *  返回yes则会在每次滚动时调用prepareLayout
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Delegate
- (CGSize)mzCollectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(mzCollectionView:sizeForItemAtIndexPath:)]) {
        return [self.delegate mzCollectionView:collectionView sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeZero;
}

- (NSInteger)levelOfMultiHeadersInCollectionView:(UICollectionView *)collectionView {
    if ([self.delegate respondsToSelector:@selector(levelOfMultiHeadersInCollectionView:)]) {
        return [self.delegate levelOfMultiHeadersInCollectionView:collectionView];
    }
    return 0;
}

- (NSArray *)mzCollectionView:(UICollectionView *)collectionView eachCellWidthOfLevel:(NSInteger)level {
    if ([self.delegate respondsToSelector:@selector(mzCollectionView:eachCellWidthOfLevel:)]) {
        return [self.delegate mzCollectionView:collectionView eachCellWidthOfLevel:level];
    }
    return nil;
}

@end
