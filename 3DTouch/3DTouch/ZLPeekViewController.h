//
//  ZLPeekViewController.h
//  3DTouch
//
//  Created by ZL on 2017/3/2.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLCellData;

@protocol ZLPeekViewControllerDelegate <NSObject>

- (void)pushToPopViewControllerWithCellData:(ZLCellData *)cellData;

@end

@interface ZLPeekViewController : UIViewController

@property (nonatomic , strong) ZLCellData * cellData;

@property (nonatomic , weak) id<ZLPeekViewControllerDelegate> delegate;

@end
