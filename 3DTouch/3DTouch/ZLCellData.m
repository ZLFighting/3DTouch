//
//  ZLCellData.m
//  3DTouch
//
//  Created by ZL on 2017/3/2.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ZLCellData.h"

@implementation ZLCellData

- (void)setCellDataDic:(NSDictionary *)cellDataDic {
    _cellDataDic = cellDataDic;
    
    self.name = cellDataDic[@"name"];
    self.header = cellDataDic[@"header"];
}


@end
