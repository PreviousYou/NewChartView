//
//  PVLineChart.h
//  NewChartView
//
//  Created by PV_Wang on 16/3/15.
//  Copyright © 2016年 PV_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVLineChartView : UIView
/**
 *Y轴最大值
 */
@property (nonatomic,assign) float maxValue;
/**
 *折线颜色
 */
@property (nonatomic,strong) UIColor *lineColor;
/**
 *X轴值数组
 */
@property (nonatomic,strong) NSArray *xValueArr;
/**
 *Y轴值数组
 */
@property (nonatomic,strong) NSArray *yValueArr;
/**
 *是否隐藏顶点数值
 */
@property (nonatomic) BOOL isHideTitle;
/**
 *顶点颜色
 */
@property (nonatomic,strong) UIColor *pointColor;
/**
 *顶部标记数值颜色
 */
@property (nonatomic,strong) UIColor *topMarkColor;
/**
 *开始画图
 */
-(void)startDrawLineForChart;
@end
