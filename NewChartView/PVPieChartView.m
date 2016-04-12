//
//  PVPieChart.m
//  PVChartView
//
//  Created by PV_Wang on 16/3/3.
//  Copyright © 2016年 PV_Wang. All rights reserved.
//

#import "PVPieChartView.h"
/**
 *  角度求三角函数sin值
 */
#define ZFSin(a) sin(a / 180.f * M_PI)
/**
 *  角度求三角函数cos值
 */
#define ZFCos(a) cos(a / 180.f * M_PI)
/**
 *  角度求三角函数tan值
 */
#define ZFTan(a) tan(a / 180.f * M_PI)
/**
 *  弧度转角度
 */
#define ZFAngle(radian) (radian / M_PI * 180.f)
/**
 *  角度转弧度
 */
#define ZFRadian(angle) (angle / 180.f * M_PI)

@interface PVPieChartView ()

/** 总数 */
@property (nonatomic, assign) CGFloat totalValue;
/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 记录每个圆弧开始的角度 */
@property (nonatomic, assign) CGFloat startAngle;
/** 动画总时长 */
@property (nonatomic, assign) CFTimeInterval totalDuration;
/** 圆环线宽 */
@property (nonatomic, assign) CGFloat lineWidth;
//记录当前元素的编号
@property (nonatomic, assign) NSInteger index;
/** 记录当前path的中心点 */
@property (nonatomic, assign) CGPoint centerPoint;
/** 记录圆环中心 */
@property (nonatomic, assign) CGPoint pieCenter;
/** 记录初始高度 */
@property (nonatomic, assign) CGFloat originHeight;
/** 存储每个圆弧动画开始的时间 */
@property (nonatomic, strong) NSMutableArray * startTimeArray;
/** 记录每个path startAngle 和 endAngle, 数组里存的是NSDictionary */
@property (nonatomic, strong) NSMutableArray * angelArray;

@end

@implementation PVPieChartView

- (NSMutableArray *)startTimeArray{
    if (!_startTimeArray) {
        _startTimeArray = [NSMutableArray array];
    }
    return _startTimeArray;
}

- (NSMutableArray *)angelArray{
    if (!_angelArray) {
        _angelArray = [NSMutableArray array];
    }
    return _angelArray;
}

/**
 *  初始化变量
 */
- (void)commonInit{
    
    _radius = self.frame.size.width*0.25;
    _lineWidth = _radius;
    _totalDuration = 0.75f;
    _startAngle = ZFRadian(-90);
    _originHeight = self.frame.size.height;
    _pieCenter = CGPointMake(self.center.x, _radius * 1.8 );
    _percentOnChartFontSize = 10.f;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
        
    }
    return self;
}

#pragma mark - Arc(圆弧)
//填充
- (UIBezierPath *)fill{
    //需要多少度的圆弧
    CGFloat angle = [self countAngle:[_valueArray[_index] floatValue]];
    
    UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:_pieCenter radius:_radius startAngle:_startAngle endAngle:_startAngle + angle clockwise:YES];
    
    self.centerPoint = [self getBezierPathCenterPointWithStartAngle:_startAngle endAngle:_startAngle + angle];
    
    //记录开始角度和结束角度
    NSDictionary * dict = @{@"startAngle":@(_startAngle), @"endAngle":@(_startAngle + angle)};
    [self.angelArray addObject:dict];
    
    _startAngle += angle;
    
    return bezier;
}

//CAShapeLayer
- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.fillColor = nil;
    layer.strokeColor = [_colorArray[_index] CGColor];
    layer.lineWidth = _lineWidth;
    layer.path = [self fill].CGPath;
    
    CABasicAnimation * animation = [self animation];
    [layer addAnimation:animation forKey:nil];
    
    return layer;
}

#pragma mark - 动画

//填充动画过程
- (CABasicAnimation *)animation{
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    fillAnimation.duration = [self countDuration:_index];
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = @(0.f);
    fillAnimation.toValue = @(1.f);
    
    return fillAnimation;
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)startDrawPieForChart{
    _startAngle = ZFRadian(-90);
    [self addColorInstruct];

    for (NSInteger i = 0; i < _valueArray.count; i++) {
        
        NSDictionary * userInfo = @{@"index":@(i)};
        NSTimer * timer = [NSTimer timerWithTimeInterval:[self.startTimeArray[i] floatValue] target:self selector:@selector(timerAction:) userInfo:userInfo repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
    }
    
}

#pragma mark - 定时器

- (void)timerAction:(NSTimer *)sender{
    _index = [[sender.userInfo objectForKey:@"index"] integerValue];
    CAShapeLayer * shapeLayer = [self shapeLayer];
    [self.layer addSublayer:shapeLayer];
    [self creatPercentLabel];
    [sender invalidate];
    sender = nil;
}

#pragma mark - 获取每个item所占百分比

/**
 *  计算每个item所占角度大小
 *
 *  @param value 每个item的value
 *
 *  @return 返回角度大小
 */
- (CGFloat)countAngle:(CGFloat)value{
    //计算百分比
    CGFloat percent = value / _totalValue;
    //需要多少度的圆弧
    CGFloat angle = M_PI * 2 * percent;
    return angle;
}

#pragma mark - 计算每个圆弧执行动画持续时间
/**
 *  计算每个圆弧执行动画持续时间
 *
 *  @param index 下标
 *
 *  @return CFTimeInterval
 */
- (CFTimeInterval)countDuration:(NSInteger)index{
    if (_totalDuration < 0.1f) {
        _totalDuration = 0.1f;
    }
    float count = _totalDuration / 0.1f;
    CGFloat averageAngle =  M_PI * 2 / count;
    CGFloat time = [self countAngle:[_valueArray[index] floatValue]] / averageAngle * 0.1;
    
    return time;
}

#pragma mark - 获取每个path的中心点

/**
 *  获取每个path的中心点
 *
 *  @return CGFloat
 */
- (CGPoint)getBezierPathCenterPointWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle{
    //一半角度(弧度)
    CGFloat halfAngle = (endAngle - startAngle) / 2;
    //中心角度(弧度)
    CGFloat centerAngle = halfAngle + startAngle;
    //中心角度(角度)
    CGFloat realAngle = ZFAngle(centerAngle);
    
    CGFloat center_xPos = ZFCos(realAngle) * _radius + _pieCenter.x;
    CGFloat center_yPos = ZFSin(realAngle) * _radius + _pieCenter.y;
    
    return CGPointMake(center_xPos, center_yPos);
}

#pragma mark - 添加百分比Label

/**
 *  添加百分比Label
 */
- (void)creatPercentLabel{
    NSString * string = [self getPercent:_index];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    label.text = string;
    label.alpha = 0.f;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:_percentOnChartFontSize];
    label.center = self.centerPoint;
    label.tag = 100 + _index;
    [self addSubview:label];
    
    [UIView animateWithDuration:[self countDuration:_index] animations:^{
        label.alpha = 1.f;
    }];
}

/**
 *  计算百分比
 *
 *  @return NSString
 */
- (NSString *)getPercent:(NSInteger)index{
    CGFloat percent = [_valueArray[index] floatValue] / _totalValue * 100;
    NSString * string;
    string = [NSString stringWithFormat:@"%.1f%%",percent];
    return string;
}

#pragma mark - 重写setter,getter方法

- (void)setValueArray:(NSMutableArray *)valueArray{
    _valueArray = valueArray;
    _totalValue = 0;
    [self.startTimeArray removeAllObjects];
    CFTimeInterval startTime = 0.f;
    //计算总数
    for (NSInteger i = 0; i < valueArray.count; i++) {
        _totalValue += [valueArray[i] floatValue];
    }
    
    //计算每个path的开始时间
    for (NSInteger i = 0; i < valueArray.count; i++) {
        [self.startTimeArray addObject:[NSNumber numberWithDouble:startTime]];
        CFTimeInterval duration = [self countDuration:i];
        startTime += duration;
    }
}

/**
 *  视图说明
 */
-(void)addColorInstruct{
    
//    float width=self.frame.size.width / 3;

    for (int i=0; i<self.colorArray.count; i++) {
        int a=i / 3;
        int b=i % 3;
        float width=self.frame.size.width / 3;
        
        UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(10 + b * width, _radius * 3.5 + a * 45, 20, 15)];
        UIColor *color=self.colorArray[i];
        colorView.backgroundColor = color;
        [self addSubview:colorView];
        
        NSString *persentString = [self getPercent:i];
        NSString *nameString = [NSString stringWithFormat:@"%@所占比例%@",self.nameArray[i], persentString];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + b * width + 20, _radius * 3.5 + a * 45 - 15, width - 15, 45)];
        
        nameLabel.text = nameString;
        nameLabel.textColor = [UIColor blackColor];
        
        if (width / 3 > 10) {
            nameLabel.font = [UIFont systemFontOfSize:10];
        }else{
            nameLabel.font = [UIFont systemFontOfSize:width / 3];
        }
        nameLabel.font = [UIFont systemFontOfSize:10];
        nameLabel.numberOfLines = 0;
        
        [self addSubview:nameLabel];
    }
}


@end
