//
//  ZLCellDataFrame.h
//  3DTouch
//
//  Created by ZL on 2017/3/2.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ZLCellData;

@interface ZLCellDataFrame : NSObject
// cell 的数据模型
@property (nonatomic, strong) ZLCellData *cellData;

// 头像的rect
@property (nonatomic, assign) CGRect headerRect;

// 名字的rect
@property (nonatomic, assign) CGRect nameRect;

// cell height
@property (nonatomic, assign) CGFloat cellHeight;

@end
