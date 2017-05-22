//
//  ZLPopViewController.m
//  3DTouch
//
//  Created by ZL on 2017/3/2.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ZLPopViewController.h"
#import "ZLCellData.h"

@interface ZLPopViewController ()

@end

@implementation ZLPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.cellData.header]];
    imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:imgView];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y + imgView.frame.size.height, self.view.frame.size.width, 40)];
    nameLabel.text = self.cellData.name;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    UILabel * popLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y + nameLabel.frame.size.height, self.view.frame.size.width, 40)];
    popLabel.text = @"这是PopView";
    popLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:popLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
