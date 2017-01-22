//
//  LineChart.m
//  CJChartDemo
//
//  Created by eric on 16/12/30.
//  Copyright © 2016年 eric. All rights reserved.
//

#import "CJLineChart.h"
#define kXandYSpaceForSuperView 20

@interface CJLineChart ()<CAAnimationDelegate>
/**
 x轴长度
 */
@property(assign,nonatomic)CGFloat xLength;
/**
 y轴长度
 */
@property(assign,nonatomic)CGFloat yLength;
/**
 等分x轴长度
 */
@property(assign,nonatomic)CGFloat perXLength;
/**
 等分y轴长度
 */
@property(assign,nonatomic)CGFloat perYLength;
//纵坐标的每个刻度值
@property(assign,nonatomic)CGFloat perValue;

@property(strong,nonatomic)NSMutableArray * drawDataArr;
@property(strong,nonatomic)CAShapeLayer * shapeLayer;

@property(assign,nonatomic)BOOL isEndAnimation;
@property(strong,nonatomic)NSMutableArray * layerArr;
@end
@implementation CJLineChart
- (NSMutableArray *)drawDataArr{
    if (_drawDataArr == nil) {
        _drawDataArr = [NSMutableArray array];
    }
    return _drawDataArr;
}
- (NSMutableArray *)layerArr{
    if (_layerArr == nil) {
        _layerArr = [NSMutableArray array];
    }
    return _layerArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:0.3];
        self.contentInsets = UIEdgeInsetsMake(10, 20, 10, 10);
        _xLineDataArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _yLineDataArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _valueLineColorArr = @[[UIColor redColor]];
        _pointColorArr = @[[UIColor redColor]];
        _positionLineColorArr = @[[UIColor darkGrayColor]];
        _pointNumberColorArr = @[[UIColor orangeColor]];
        _xAndYLineColor = [UIColor redColor];
        _xAndYNumberColor = [UIColor greenColor];
        _lineWidth = 0.5;
        
        [self configChartOrigin];
      
        [self configChartXAndYLength];
        
        [self configPerXAndPerY];
    }
    return self;
}
//获得x、y轴的长度
- (void)configChartXAndYLength{
    _xLength = CGRectGetWidth(self.frame)-self.contentInsets.left-self.contentInsets.right;
    _yLength = CGRectGetHeight(self.frame)- self.contentInsets.top-self.contentInsets.bottom;
}
//构建折线图原点
- (void)configChartOrigin{
    self.chartOrigin = CGPointMake(self.contentInsets.left, CGRectGetHeight(self.frame)-self.contentInsets.bottom);
}
- (void)configPerXAndPerY{
    _perXLength = (_xLength - kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
    _perYLength = (_yLength - kXandYSpaceForSuperView)/_yLineDataArr.count;
}
//重写ValueArr的setter方法 赋值时改变Y轴刻度大小
- (void)setValueArr:(NSArray *)valueArr{
    _valueArr = valueArr;
    [self updateYData];
}
//更新y轴的组数
- (void)updateYData{
    
    if (_valueArr.count) {
        NSInteger max = 0;
        for (NSArray * arr in _valueArr) {
            for (NSString * number in arr) {
                NSInteger num = [number integerValue];
                if (num >= max) {
                    max = num;
                }
            }
        }
        if (max%5 == 0) {
            max = max;
        }else{
            _yLineDataArr = nil;
            NSMutableArray * arr = [NSMutableArray array];
            max = (max/5+1)*5;
            if (max<5) {
                for (int i = 0; i < 5; i++) {
                    [arr addObject:[NSString stringWithFormat:@"%d",(i+1)*1]];
                }
            }else if (max <10 && max >5){
                for (int i = 0; i < 5; i++) {
                    [arr addObject:[NSString stringWithFormat:@"%d",(i+1)*2]];
                }
            }else if (max >10){
                for (int i = 0; i < max/5; i++) {
                    [arr addObject:[NSString stringWithFormat:@"%d",(i+1)*5]];
                }
            }
            _yLineDataArr = arr;
            [self setNeedsDisplay];
        }
    }
}

- (void)showAnimation{
    [self configPerXAndPerY];
    [self configValueDataArray];
    [self drawAnimation];
}
- (void)drawRect:(CGRect)rect{
    CGContextRef  context = UIGraphicsGetCurrentContext();
    [self drawXAndYLineWithContext:context];
    if (!_isEndAnimation) {
        return;
    }
    if (_drawDataArr.count > 0) {
        [self drawPositionLineWithContext:context];
    }
    
}
/**
 *  把 换值数组 为 点数组
 */
- (void)configValueDataArray{
    if (!_valueArr.count) {
        return;
    }
        _perValue = _perYLength/[[_yLineDataArr firstObject]floatValue];
    for (NSArray * arr in _valueArr) {
        NSMutableArray * dataArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            CGPoint point = PointMake(i * _perXLength + self.chartOrigin.x, self.contentInsets.top+_yLength-_perValue * ([arr[i] floatValue]));
            NSValue * value = [NSValue valueWithCGPoint:point];
            [dataArr addObject:value];
        }
        [self.drawDataArr addObject:dataArr];
    }
    
}
//执行动画
- (void)drawAnimation{
    
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = [CAShapeLayer layer];
    
    if (!_drawDataArr.count) {
        return;
    }
    for (int i = 0; i < _drawDataArr.count; i++) {
        NSArray * dataArr = _drawDataArr[i];
        [self drawPathWithDataArr:dataArr andIndex:i];
    }
}
- (void)drawPathWithDataArr:(NSArray *)dataArr andIndex:(NSInteger)colorIndex{
    UIBezierPath * firstPath = [UIBezierPath bezierPath];
    UIBezierPath * secondPath = [UIBezierPath bezierPath];
    
    for (int i = 0; i < dataArr.count; i++) {
        CGPoint point = [dataArr[i] CGPointValue];
        if (_pathCurve) {
            if (i == 0) {
                if (_contentFill) {
                    [firstPath moveToPoint:PointMake(point.x, self.chartOrigin.y)];
                    [firstPath addLineToPoint:point];
                }
                [secondPath moveToPoint:point];
                
            }else{
                CGPoint nextP = [dataArr[i-1] CGPointValue];
                CGPoint control1 = PointMake(point.x + (nextP.x- point.x)/2.0, nextP.y);
                CGPoint control2 = PointMake(point.x + (nextP.x - point.x)/2.0, point.y);
                [firstPath addCurveToPoint:point controlPoint1:control1 controlPoint2:control2];
                [secondPath addCurveToPoint:point controlPoint1:control1 controlPoint2:control2];
            }
            
        }else{
            if (i == 0) {
                if (_contentFill) {
                    [firstPath moveToPoint:PointMake(point.x, self.chartOrigin.y)];
                    [firstPath addLineToPoint:point];
                }
                [secondPath moveToPoint: point];
                
            }else{
                [firstPath addLineToPoint:point];
                [secondPath addLineToPoint:point];
            }
        }
        if ( i == dataArr.count-1) {
            [firstPath addLineToPoint:PointMake(point.x, self.chartOrigin.y)];
        }
    }
    if (_contentFill) {
        [firstPath closePath];
    }
    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.frame = self.bounds;
    shape.path = secondPath.CGPath;
    UIColor *color = ((_valueLineColorArr.count == _drawDataArr.count)?_valueLineColorArr[colorIndex]:[UIColor orangeColor]);
    shape.strokeColor = color.CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.lineWidth = (_animationPathWidth<=0?2:_animationPathWidth);
    [self.layer addSublayer:shape];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.duration = 4;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    [shape addAnimation:animation forKey:nil];
    [self.layerArr addObject:shape];
    
    weakSelf(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = weakSelf.bounds;
        shapeLayer.path = firstPath.CGPath;
        if (weakSelf.contentFillColorArr.count == weakSelf.drawDataArr.count) {
            shapeLayer.fillColor = [weakSelf.contentFillColorArr[colorIndex] CGColor];;
        }else{
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
        }
        [weakSelf.layer addSublayer:shapeLayer];
        
        [_layerArr addObject:shapeLayer];
    });

}
//绘制x、y轴
- (void)drawXAndYLineWithContext:(CGContextRef)context{
    
    [self drawLineWithContext:context andStartPoint:self.chartOrigin andEndPoint:PointMake(self.chartOrigin.x + _xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:_xAndYLineColor];
    
    [self drawLineWithContext:context andStartPoint:self.chartOrigin andEndPoint:PointMake(self.chartOrigin.x, self.chartOrigin.y - _yLength) andIsDottedLine:NO andColor:_xAndYLineColor];
    
    if (_xLineDataArr.count > 0) {
        CGFloat xSpace = (_xLength - kXandYSpaceForSuperView)/(_xLineDataArr.count -1);
        for (int i = 0;i < self.xLineDataArr.count; i++) {
            CGPoint point = PointMake(i*xSpace+self.chartOrigin.x, self.chartOrigin.y);
            
            CGFloat len = [self getTextWithWhenDrawWithText:_xLineDataArr[i]];
            
            [self drawLineWithContext:context andStartPoint:point andEndPoint:PointMake(point.x, point.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
            
            [self drawText:_xLineDataArr[i] context:context atPoint:PointMake(point.x-len/2, point.y+2) andColor:_xAndYNumberColor andFont:[UIFont systemFontOfSize:7.0]];
        }
    }
    
    if (_yLineDataArr.count > 0) {
        CGFloat ySpace = (_yLength - kXandYSpaceForSuperView)/(_yLineDataArr.count);
        for (int i = 0; i < self.yLineDataArr.count; i++) {
            CGPoint point = PointMake(self.chartOrigin.x, self.chartOrigin.y - ySpace*(i+1));
            CGFloat len = [self getTextWithWhenDrawWithText:_yLineDataArr[i]];
            
            [self drawLineWithContext:context andStartPoint:point andEndPoint:PointMake(self.chartOrigin.x+3, point.y) andIsDottedLine:NO andColor:_xAndYLineColor];
            
            [self drawText:_yLineDataArr[i] context:context atPoint:PointMake(point.x-len-3, point.y-3) andColor:_xAndYNumberColor andFont:[UIFont systemFontOfSize:7.0]];
        }
    }
}
/**
 *  设置点的引导虚线
 *
 *  @param context 图形面板上下文
 */
- (void)drawPositionLineWithContext:(CGContextRef)context{
    if (!_drawDataArr.count) {
        return;
    }
    for (int m = 0; m < _valueArr.count; m++) {
        NSArray * arr = _drawDataArr[m];
        for (int i = 0; i < arr.count; i++) {
            CGPoint point = [arr[i] CGPointValue];
            UIColor * positionLineColor = [UIColor blueColor];

            if (_positionLineColorArr.count == _drawDataArr.count) {
                positionLineColor = _positionLineColorArr[m];
            }else{
                positionLineColor = [UIColor orangeColor];
            }
            if (point.y != self.chartOrigin.y && point.x != self.chartOrigin.x) {
                [self drawLineWithContext:context andStartPoint:point andEndPoint:PointMake(self.chartOrigin.x, point.y) andIsDottedLine:YES andColor:positionLineColor];
                
                [self drawLineWithContext:context andStartPoint:point andEndPoint:PointMake(point.x,self.chartOrigin.y) andIsDottedLine:YES andColor:positionLineColor];
                
            }
            UIColor * pointNumberColor = (_pointNumberColorArr.count == _valueArr.count)?(_pointNumberColorArr[i]):[UIColor orangeColor];
            [self drawText:[NSString stringWithFormat:@"(%@,%@)",_xLineDataArr[i],_valueArr[m][i]] context:context atPoint:point andColor:pointNumberColor andFont:[UIFont systemFontOfSize:7.0]];
        }

    }
    _isEndAnimation = NO;
    
}
#pragma mark -CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self drawPoint];
    }
}
//绘制点
-(void)drawPoint{
    for (int i = 0; i < _drawDataArr.count; i++) {
        NSArray * arr = _drawDataArr[i];
        for (int j = 0; j < arr.count; j++) {
            NSValue * value = arr[j];
            CGPoint point = value.CGPointValue;
            UIBezierPath * bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 5, 5)];
            [bezier moveToPoint:point];
            CAShapeLayer * shape = [CAShapeLayer layer];
            shape.frame = CGRectMake(0, 0, 5, 5);
            shape.position = point;
            shape.path = bezier.CGPath;
            UIColor * color = (_pointColorArr.count ==_drawDataArr.count)?_pointColorArr[i]:[UIColor orangeColor];
            shape.fillColor = color.CGColor;
             [self.layer addSublayer:shape];
            
            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @0.0;
            animation.toValue = @1.0;
            animation.duration = 2.0;
            [shape addAnimation:animation forKey:nil];
            [_layerArr addObject:shape];
        }
        _isEndAnimation = YES;
        [self setNeedsDisplay];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
