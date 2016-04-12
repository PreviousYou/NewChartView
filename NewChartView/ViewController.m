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
#import "PVPieChartView.h"

@interface ViewController ()
{
    PVPieChartView * pieChartView;
    PVBarChartView *barChartView;
    PVLineChartView *lineChartView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)doWithCreatPieChart{
 
    pieChartView = [[PVPieChartView alloc] initWithFrame:self.view.bounds];
    
    pieChartView.valueArray = @[@"280", @"255", @"308", @"273", @"236", @"267"];
    pieChartView.nameArray = @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
    pieChartView.colorArray = @[[UIColor redColor],[UIColor orangeColor],[UIColor grayColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor greenColor]];
    
    [self.view addSubview:pieChartView];
    
    [pieChartView startDrawPieForChart];
}

-(void)doWithCreatBarChart{
    barChartView = [[PVBarChartView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 300)];
    
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
    lineChartView = [[PVLineChartView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 300)];
    
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

- (IBAction)creatChartViewAction:(UIButton *)sender {
//    
//    [pieChartView removeFromSuperview];
//    [self doWithCreatPieChart];
    
//    [barChartView removeFromSuperview];
//    [self doWithCreatBarChart];
    
    [lineChartView removeFromSuperview];
        [self doWithCreatLineChart];
    
}
@end
