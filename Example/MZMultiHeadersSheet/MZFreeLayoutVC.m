//
//  MZFreeLayoutVC.m
//  MZMultiHeadersSheet_Example
//
//  Created by boco on 2018/3/22.
//  Copyright © 2018年 machellezhang. All rights reserved.
//

#import "MZFreeLayoutVC.h"
#import "MZFreeSheetLayout.h"
#import "MZCollectionViewCell.h"

static NSString *cellIdentifier = @"MZCollectionViewCell";

@interface MZFreeLayoutVC () <MZFreeSheetLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation MZFreeLayoutVC

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initForView];
    [self initForData];
}

- (void)initForView {
    MZFreeSheetLayout *freeLayout = [[MZFreeSheetLayout alloc] init];
    freeLayout.delegate = self;
    freeLayout.itemSpacing = 2;
    freeLayout.itemMargin = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100) collectionViewLayout:freeLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.directionalLockEnabled = YES;
    [self.view addSubview:self.collectionView];
}

- (void)initForData {
    self.datas = @[
                    @[@(1), @(1)],
                    @[@(2), @(1)], //1
                    @[@(1), @(1)],
                    @[@(1), @(1)],
                    @[@(1), @(1)],
                    @[@(1), @(1)],
                    @[@(1), @(3)], //6
                    @[@(1), @(1)],
                    @[@(1), @(1)],
                    @[@(1), @(1)],
                    @[@(1), @(1)],
                    @[@(1), @(1)],
                    @[@(1), @(1)],
                    @[@(1), @(2)], //13
                    @[@(1), @(1)],
                    @[@(2), @(2)], //15
                    @[@(1), @(1)],
                    @[@(1), @(1)],
                   ];
}

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
    return CGSizeMake(1, 1);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5;
    cell.title.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", @(indexPath.row));
}

@end
