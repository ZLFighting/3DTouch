//
//  ZLTableViewCell.h
//  3DTouch
//
//  Created by ZL on 2017/3/2.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLCellDataFrame;
@interface ZLTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView      * headerImgView;
@property (nonatomic , strong) UILabel          * nameLabel;
@property (nonatomic , strong) ZLCellDataFrame  * dataFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
