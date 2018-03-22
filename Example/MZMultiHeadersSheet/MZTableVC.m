//
//  MZTableVC.m
//  MZMultiHeadersSheet_Example
//
//  Created by boco on 2018/3/22.
//  Copyright © 2018年 machellezhang. All rights reserved.
//

#import "MZTableVC.h"
#import "MZFreeLayoutVC.h"
#import "MZMultiHeadersLayoutVC.h"

@interface MZTableVC ()

@property (nonatomic, strong) NSArray *datasArr;

@end

@implementation MZTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.datasArr = @[@"MZMultiHeadersLayoutVC", @"MZFreeLayoutVC"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.datasArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MZMultiHeadersLayoutVC *multiHeadersVC = [MZMultiHeadersLayoutVC new];
        [self.navigationController pushViewController:multiHeadersVC animated:YES];
    } else if (indexPath.row == 1) {
        MZFreeLayoutVC *freeLayoutVC = [MZFreeLayoutVC new];
        [self.navigationController pushViewController:freeLayoutVC animated:YES];
    }
}

@end
