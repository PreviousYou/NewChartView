//
//  PVPieChart.h
//  PVChartView
//
//  Created by PV_Wang on 16/3/3.
//  Copyright © 2016年 PV_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVPieChartView : UIView

/** 数值数组 (存储的是NSString类型) */
@property (nonatomic, strong) NSArray * valueArray;
/** 颜色数组 (存储的是UIColor类型) */
@property (nonatomic, strong) NSArray * colorArray;

@property (nonatomic, strong) NSArray * nameArray;

#pragma mark - 可选属性

/** 显示详细信息(默认为YES) */
@property (nonatomic, assign) BOOL isShowDetail;


/** 图表上百分比字体大小 */
@property (nonatomic, assign) CGFloat percentOnChartFontSize;

/**
 *开始画图
 */
-(void)startDrawPieForChart;

@end
