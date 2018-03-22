//
//  MZMultiHeadersLayoutVC.m
//  MZMultiHeadersSheet
//
//  Created by machellezhang on 03/15/2018.
//  Copyright (c) 2018 machellezhang. All rights reserved.
//

#import "MZMultiHeadersLayoutVC.h"
#import "MZMultiHeadersSheetLayout.h"
#import "MZCollectionViewCell.h"

static NSString *cellIdentifier = @"MZCollectionViewCell";

@interface MZMultiHeadersLayoutVC () <MZMultiHeadersSheetLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MZMultiHeadersLayoutVC

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initForView];
}

- (void)initForView {
    MZMultiHeadersSheetLayout *multiHeadersLayout = [[MZMultiHeadersSheetLayout alloc] init];
    multiHeadersLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100) collectionViewLayout:multiHeadersLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.directionalLockEnabled = YES;
    [self.view addSubview:self.collectionView];
}

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
    return 3;
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5;
    cell.title.text = [NSString stringWithFormat:@"%@+%@", @(indexPath.section), @(indexPath.row)];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"Section:%@ Row:%@", @(indexPath.section), @(indexPath.row));
}

@end
