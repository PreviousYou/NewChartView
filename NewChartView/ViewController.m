//
//  ViewController.m
//  NewChartView
//
//  Created by PV_Wang on 16/3/15.
//  Copyright © 2016年 PV_Wang. All rights reserved.
//

#import "ViewController.h"
#import "PVLineChartView.h"
#import "PVBarChartView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self doWithCreatBarChart];
//    [self doWithCreatLineChart];
}

-(void)doWithCreatBarChart{
    PVBarChartView *barChartView=[[PVBarChartView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    barChartView.maxValue=15.0;
    
    barChartView.isHideTitle=NO;
    barChartView.barColor=[UIColor redColor];

    barChartView.xValueArr=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                             @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
    
    barChartView.yValueArr=@[@"10.0",@"3.0",@"15.0",@"11.0",@"4.0",@"8.0",
                             @"1.0",@"0.0",@"12.0",@"7.0",@"3",@"10",@"4",
                             @"7",@"11",@"3",@"5"];
    
    [self.view addSubview:barChartView];
    
    [barChartView startDrawLineForChart];
}

-(void)doWithCreatLineChart{
    PVLineChartView *lineChartView=[[PVLineChartView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    lineChartView.maxValue=15.0;
    
    lineChartView.isHideTitle=NO;
    
    lineChartView.lineColor=[UIColor orangeColor];
    
    lineChartView.topMarkColor=[UIColor darkGrayColor];
    
    lineChartView.xValueArr=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                             @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
    
    lineChartView.yValueArr=@[@"10.0",@"3.0",@"15.0",@"11.0",@"4.0",@"8.0",
                             @"1.0",@"0.0",@"12.0",@"7.0",@"3",@"10",@"4",
                             @"7",@"11",@"3",@"5"];
    
    [self.view addSubview:lineChartView];
    
    [lineChartView startDrawLineForChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
