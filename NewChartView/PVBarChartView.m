//
//  PVBarChartView.m
//  NewChartView
//
//  Created by PV_Wang on 16/3/15.
//  Copyright © 2016年 PV_Wang. All rights reserved.
//

#import "PVBarChartView.h"


#define LineChartYRange 45//Y坐标间隔
#define LineChartTopRange 15//距离顶部高度
#define LineChartLeftRange 40//距离左侧距离
#define LineChartHorizontalCount 5//纵坐标点数
@interface PVBarChartView ()

@property(nonatomic, strong) NSMutableArray *xPointArray;//点的x坐标数组
@property(nonatomic, strong) NSMutableArray *yPointArray;//点的y坐标数组
@property(nonatomic, strong) NSMutableArray *pointArr;//顶点数组
@property(nonatomic) float lineChartXRange;//X坐标间隔
@property(nonatomic, strong) UIScrollView *backScrollView;//底部滑动scrollView
@property(nonatomic) float animationTime;
@end

@implementation PVBarChartView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if (self) {
        self.barColor=[UIColor blueColor];
        self.xPointArray=[[NSMutableArray alloc]init];
        self.yPointArray=[[NSMutableArray alloc]init];
        self.pointArr=[[NSMutableArray alloc]init];
        self.topMarkColor=[UIColor darkGrayColor];
        self.animationTime = 3.0f;
    }
    return self;
}

/**
 *  初始化scrollView
 */
- (void)doWithCreatBackScrollView{
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    
    self.backScrollView.contentSize = CGSizeMake(LineChartLeftRange + 30 + self.xValueArr.count * _lineChartXRange, self.frame.size.height);
    
    [self addSubview:self.backScrollView];

}

-(void)setYValueArr:(NSArray *)yValueArr{
    _yValueArr=yValueArr;
}

- (void)setDonation:(float)donation{
    _donation = donation;
}

-(void)setXValueArr:(NSArray *)xValueArr{
    _xValueArr=xValueArr;
    
    float width = (self.frame.size.width-LineChartLeftRange-30)/_xValueArr.count;
    
    if (width > 20) {
        _lineChartXRange=(self.frame.size.width-LineChartLeftRange-30)/_xValueArr.count;
    }else{
        _lineChartXRange = 20;
    }
    
    [self doWithCreatBackScrollView];
}

-(void)setTopMarkColor:(UIColor *)topMarkColor{
    _topMarkColor=topMarkColor;
}

-(void)setMaxValue:(float)maxValue{
    _maxValue = maxValue;
}

-(void)setBarColor:(UIColor *)barColor{
    _barColor=barColor;
}

-(void)setIsHideTitle:(BOOL)isHideTitle{
    _isHideTitle=isHideTitle;
}

-(void)startDrawLineForChart{
    [self drawHorizontalLine];
    [self drawVerticalLine];
    [self drawBar];
    [self addYLabelMark];
}

//画柱子
-(void)drawBar{

    //    保存顶点的X坐标
    for (int i=0; i<self.xValueArr.count; i++) {
        float width=LineChartLeftRange+self.lineChartXRange*i;
        [self.xPointArray addObject:[NSString stringWithFormat:@"%f",width]];
    }
    //    保存顶点的Y坐标
    for (int i=0; i<self.xValueArr.count; i++) {
        float hiehghtNumber=[self.yValueArr[i] floatValue];
        float height=LineChartTopRange+(1-hiehghtNumber/self.maxValue)*(LineChartHorizontalCount*LineChartYRange);
        [self.yPointArray addObject:[NSString stringWithFormat:@"%f",height]];
    }
    // 保存X轴单个柱子模块的开始顶点坐标
    for (NSInteger i = 0; i < self.xPointArray.count; i++) {
        CGPoint point = CGPointMake([self.xPointArray[i] floatValue], [self.yPointArray[i] floatValue]);
        NSValue * value = [NSValue valueWithCGPoint:point];
        [self.pointArr addObject:value];
        [self addXLabelMark:point andIndex:i];
    }
    
    //    画柱子
    UIBezierPath * bezierLine = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = self.barColor.CGColor;
    shapeLayer.fillColor = [self.barColor CGColor];
    shapeLayer.lineWidth = 0.6 * self.lineChartXRange;
    [self.backScrollView.layer addSublayer:shapeLayer];
    
    for (int i=0; i<self.xValueArr.count; i++) {
        
        CGPoint point1 = CGPointMake(LineChartLeftRange+self.lineChartXRange / 2+i*self.lineChartXRange, LineChartTopRange+LineChartHorizontalCount*LineChartYRange);
        
        float hiehghtNumber = [self.yValueArr[i] floatValue];
        float height = LineChartTopRange + (1-hiehghtNumber / self.maxValue) *(LineChartHorizontalCount * LineChartYRange);
        CGPoint point2 = CGPointMake(LineChartLeftRange + self.lineChartXRange / 2 + i * self.lineChartXRange, height);
        
        [bezierLine moveToPoint:point1];
        [bezierLine addLineToPoint:point2];

        [self addTopMark:[self.pointArr[i] CGPointValue] andIndex:i];
    }
    
    shapeLayer.path = bezierLine.CGPath;

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    if (self.donation == 0) {
        if (self.xValueArr.count * 0.3 < 3) {
            pathAnimation.duration = self.xValueArr.count * 0.3 < 3;
        }else{
            pathAnimation.duration = self.animationTime;
        }
    }else{
        pathAnimation.duration = self.donation;
    }
    
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.f];
    pathAnimation.autoreverses = NO;
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    shapeLayer.strokeEnd = 1.f;
    
}

-(void)addTopMark:(CGPoint)point andIndex:(NSInteger)index{
    //   顶点标记数值
    if (!self.isHideTitle) {
        UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(point.x, point.y-15, self.lineChartXRange, 15)];
        titleLable.textAlignment=NSTextAlignmentCenter;
        titleLable.text=self.yValueArr[index];
        if (self.lineChartXRange/3>14) {
            titleLable.font=[UIFont systemFontOfSize:14];
        }else{
            titleLable.font=[UIFont systemFontOfSize:self.lineChartXRange/3];
        }
        titleLable.textColor=self.topMarkColor;
        [self.backScrollView addSubview:titleLable];
    }
}

//划横线
-(void)drawHorizontalLine{
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    for (NSInteger i = 0; i < LineChartHorizontalCount+1; i++) {
        
        [path moveToPoint:CGPointMake(LineChartLeftRange, LineChartYRange * i + LineChartTopRange)];
        [path addLineToPoint:CGPointMake(LineChartLeftRange+self.xValueArr.count*self.lineChartXRange, LineChartYRange * i + LineChartTopRange)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.3f;
        [self.backScrollView.layer addSublayer:shapeLayer];
    }
}

//画竖线
-(void)drawVerticalLine{
    //左侧竖线
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    [path moveToPoint:CGPointMake(LineChartLeftRange, LineChartTopRange)];
    [path addLineToPoint:CGPointMake(LineChartLeftRange, LineChartYRange * LineChartHorizontalCount + LineChartTopRange)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.lineWidth = 0.3f;
    [self.backScrollView.layer addSublayer:shapeLayer];
    //右侧竖线
    UIBezierPath * path2 = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer2 = [CAShapeLayer layer];
    [path2 moveToPoint:CGPointMake(LineChartLeftRange+self.xValueArr.count*self.lineChartXRange, LineChartTopRange)];
    [path2 addLineToPoint:CGPointMake(LineChartLeftRange+self.xValueArr.count*self.lineChartXRange, LineChartYRange * LineChartHorizontalCount + LineChartTopRange)];
    [path2 closePath];
    shapeLayer2.path = path2.CGPath;
    shapeLayer2.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer2.lineWidth = 0.3f;
    [self.backScrollView.layer addSublayer:shapeLayer2];
}

//设置x轴标记label
- (void)addXLabelMark:(CGPoint)point andIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.lineChartXRange, 20)];
    label.center = CGPointMake(point.x+self.lineChartXRange/2,  LineChartTopRange+LineChartHorizontalCount*LineChartYRange+10);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:10.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.xValueArr[index];
    [self.backScrollView addSubview:label];
}

//设置y轴标记label
-(void)addYLabelMark{
    for (int i=0; i<LineChartHorizontalCount+1; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, LineChartTopRange+LineChartYRange*(LineChartHorizontalCount-i)-10, 35, 20)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%.1f",i*self.maxValue/LineChartHorizontalCount];
        [self.backScrollView addSubview:label];
    }
}
@end
