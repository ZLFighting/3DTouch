//
//  ViewController.m
//  3DTouch
//
//  Created by ZL on 2017/3/2.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "HomeViewController.h"
#import "ZLCellData.h"
#import "ZLCellDataFrame.h"
#import "ZLTableViewCell.h"
#import "ZLPeekViewController.h"
#import "ZLPopViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate, ZLPeekViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL support3DTouch;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 检测当前设备是否支持3DTouch
    self.support3DTouch = [self support3DTouch];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"3DTouch";
    self.view.backgroundColor = [UIColor orangeColor];
    
    // 子界面
    [self setupSubViewsAndParams];

}


#pragma mark - private method

- (BOOL)support3DTouch {
    
    // 如果开启了3D touch
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        return YES;
    }
    return NO;
}

// 子界面
- (void)setupSubViewsAndParams {
    
    [self.navigationController setTitle:@"3DTouch"];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    //  模拟网络请求回json后的解析过程
    self.dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i ++) {
        
        NSDictionary * dic = @{
                               @"name" : [NSString stringWithFormat:@"测试_%d",i],
                               @"header" : @"icon"
                               };
        ZLCellData * cellData = [[ZLCellData alloc] init];
        cellData.cellDataDic = dic;
        ZLCellDataFrame *cellFrame = [[ZLCellDataFrame alloc] init];
        cellFrame.cellData = cellData;
        [self.dataSource addObject:cellFrame];
    }
    [_tableView reloadData];
    
}

#pragma mark - ZLPeekViewControllerDelegate

- (void)pushToPopViewControllerWithCellData:(ZLCellData *)cellData {
    
    ZLPopViewController *popViewController = [[ZLPopViewController alloc] init];
    popViewController.cellData = cellData;
    [self.navigationController pushViewController:popViewController animated:YES];
}

#pragma mark - 当配置发生了变化，在应用运行中，从支持变成了不支持，回调用这个回调

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection NS_AVAILABLE_IOS(8_0) {
    
    self.support3DTouch = [self support3DTouch];
}

#pragma mark - 3DTouch  UIViewControllerPreviewingDelegate

// 此方法是轻按控件时，跳出peek的代理方法
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    //防止重复加入
    if ([self.presentedViewController isKindOfClass:[ZLPeekViewController class]])
    {
        return nil;
    }
    else
    {
        ZLTableViewCell *cell = (ZLTableViewCell *)previewingContext.sourceView;
        ZLCellData * cellData = cell.dataFrame.cellData;
        ZLPeekViewController *peekViewController = [[ZLPeekViewController alloc] init];
        peekViewController.cellData = cellData;
        peekViewController.delegate = self;
        return peekViewController;
    }
}

//此方法是重按peek时，跳入pop的代理方法
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
    commitViewController:(UIViewController *)viewControllerToCommit {
    
    ZLTableViewCell *cell = (ZLTableViewCell *)previewingContext.sourceView;
    ZLCellData * cellData = cell.dataFrame.cellData;
    ZLPopViewController *popViewController = [[ZLPopViewController alloc] init];
    popViewController.cellData = cellData;
    // 以prentViewController的形式展现
    [self showViewController:popViewController sender:self];
    
    // 以push的形势展现
//    [self.navigationController pushViewController:popViewController animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZLTableViewCell"];
    if (cell == nil) {
        cell = [ZLTableViewCell cellWithTableView:tableView];
    }
    cell.dataFrame = self.dataSource[indexPath.row];
    //给cell注册代理，使其支持3DTouch手势
    if (self.support3DTouch) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZLCellDataFrame *frame = self.dataSource[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZLCellDataFrame *frame = self.dataSource[indexPath.row];
    ZLPopViewController *popVC = [[ZLPopViewController alloc] init];
    popVC.cellData = frame.cellData;
    [self.navigationController pushViewController:popVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
