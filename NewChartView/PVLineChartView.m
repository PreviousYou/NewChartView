//
//  PVLineChart.m
//  NewChartView
//
//  Created by PV_Wang on 16/3/15.
//  Copyright © 2016年 PV_Wang. All rights reserved.
//

#import "PVLineChartView.h"

#define LineChartYRange 45//Y坐标间隔
#define LineChartTopRange 100//距离顶部高度
#define LineChartLeftRange 40//距离左侧距离
#define LineChartHorizontalCount 5//横线条数

@interface  PVLineChartView ()

@property(nonatomic, strong) NSMutableArray *xPointArray;//点的x坐标数组
@property(nonatomic, strong) NSMutableArray *yPointArray;//点的y坐标数组
@property(nonatomic, strong) NSMutableArray *pointArr;//顶点数组
@property(nonatomic) float lineChartXRange;//X坐标间隔
@end

@implementation PVLineChartView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if (self) {
        self.lineColor=[UIColor lightGrayColor];
        self.pointColor=[UIColor redColor];
        self.xPointArray=[[NSMutableArray alloc]init];
        self.yPointArray=[[NSMutableArray alloc]init];
        self.pointArr=[[NSMutableArray alloc]init];
        self.topMarkColor=[UIColor darkGrayColor];
    }
    return self;
}

-(void)setYValueArr:(NSArray *)yValueArr{
    _yValueArr=yValueArr;
}

-(void)setXValueArr:(NSArray *)xValueArr{
    _xValueArr=xValueArr;
    _lineChartXRange=(self.frame.size.width-40-30)/(_xValueArr.count-1);
}

-(void)setMaxValue:(float)maxValue{
    _maxValue = maxValue;
}

-(void)setTopMarkColor:(UIColor *)topMarkColor{
    _topMarkColor=topMarkColor;
}

-(void)setLineColor:(UIColor *)lineColor{

    _lineColor=lineColor;
}

-(void)setIsHideTitle:(BOOL)isHideTitle{
    _isHideTitle=isHideTitle;
}

-(void)setPointColor:(UIColor *)pointColor{
    _pointColor=pointColor;
}

//划横线
-(void)drawHorizontalLine{
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    for (NSInteger i = 0; i < LineChartHorizontalCount+1; i++) {
        
        [path moveToPoint:CGPointMake(LineChartLeftRange, LineChartYRange * i + LineChartTopRange)];
        [path addLineToPoint:CGPointMake(LineChartLeftRange+(self.xValueArr.count-1)*self.lineChartXRange, LineChartYRange * i + LineChartTopRange)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
//        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.3f;
        [self.layer addSublayer:shapeLayer];
    }
}

//画竖线
-(void)drawVerticalLine{
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    for (NSInteger i = 0; i < self.xValueArr.count; i++) {
        
        [path moveToPoint:CGPointMake(LineChartLeftRange+i*self.lineChartXRange, LineChartTopRange)];
        [path addLineToPoint:CGPointMake(LineChartLeftRange+i*self.lineChartXRange, LineChartYRange * LineChartHorizontalCount + LineChartTopRange)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.lineWidth = 0.3f;
        [self.layer addSublayer:shapeLayer];
    }
    
}

-(void)startDrawLineForChart{
    [self drawHorizontalLine];
    [self drawVerticalLine];

//    保存点的X坐标
    for (int i=0; i<self.xValueArr.count; i++) {
        float width=LineChartLeftRange+self.lineChartXRange*i;
        [self.xPointArray addObject:[NSString stringWithFormat:@"%f",width]];
    }
//    保存点的Y坐标
    for (int i=0; i<self.xValueArr.count; i++) {
        float hiehghtNumber=[self.yValueArr[i] floatValue];
        float height=LineChartTopRange+(1-hiehghtNumber/self.maxValue)*(LineChartHorizontalCount*LineChartYRange);
        [self.yPointArray addObject:[NSString stringWithFormat:@"%f",height]];
    }
// 画出顶点，保存顶点
    for (NSInteger i = 0; i < self.xPointArray.count; i++) {
        CGPoint point = CGPointMake([self.xPointArray[i] floatValue], [self.yPointArray[i] floatValue]);
        NSValue * value = [NSValue valueWithCGPoint:point];
        [self.pointArr addObject:value];
        [self addXLabelMark:point andIndex:i];
    }
//    画折线
    for (NSInteger i = 0; i < self.xValueArr.count; i++) {
        if (i<self.xValueArr.count && i+1<self.xValueArr.count) {
            UIBezierPath * path = [UIBezierPath bezierPath];
            CAShapeLayer * shapeLayer = [CAShapeLayer layer];
            NSValue *value1=self.pointArr[i];
            NSValue *value2=self.pointArr[i+1];
            
            [path moveToPoint:[value1 CGPointValue]];
            [path addLineToPoint:[value2 CGPointValue]];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = self.lineColor.CGColor;
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }
    for (NSInteger i = 0; i < self.xValueArr.count; i++) {
        [self addCircle:[self.pointArr[i] CGPointValue] andIndex:i];
    }
    
    [self addYLabelMark];
}

//圆圈
- (void)addCircle:(CGPoint)point andIndex:(NSInteger)index {
//   顶点
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.center = point;
    view.backgroundColor = self.pointColor;
    view.layer.cornerRadius = 5.f;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
//   顶点标记数值
    if (!self.isHideTitle) {
        UILabel *topMarkLable=[[UILabel alloc]initWithFrame:CGRectMake(point.x-15, point.y-18, 30, 15)];
        topMarkLable.textAlignment=NSTextAlignmentCenter;
        topMarkLable.text=self.yValueArr[index];
        topMarkLable.font=[UIFont systemFontOfSize:self.lineChartXRange/2];
        topMarkLable.textColor=self.topMarkColor;
        [self addSubview:topMarkLable];
    }
}

//设置x轴标记label
- (void)addXLabelMark:(CGPoint)point andIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ((self.frame.size.width-40)/(self.xValueArr.count-1)), 20)];
    label.center = CGPointMake(point.x,  LineChartTopRange+LineChartHorizontalCount*LineChartYRange+10);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:10.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.xValueArr[index];
    [self addSubview:label];
}

//设置y轴标记label
-(void)addYLabelMark{
    for (int i=0; i<LineChartHorizontalCount+1; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, LineChartTopRange+LineChartYRange*(LineChartHorizontalCount-i)-10, 35, 20)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%.1f",i*self.maxValue/LineChartHorizontalCount];
        [self addSubview:label];
    }
}

@end
