//
//  CJLineChart.h
//  CJChartDemo
//
//  Created by eric on 16/12/30.
//  Copyright © 2016年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJChart.h"
//
//typedef NS_ENUM(NSInteger,CJLineChartQuadrantType) {
//    CJLineChartQuadrant,
//    
//};

@interface CJLineChart :CJChart

@property(strong,nonatomic)NSArray * xLineDataArr;
@property(strong,nonatomic)NSArray * yLineDataArr;
@property(strong,nonatomic)NSArray * valueArr;
@property(strong,nonatomic)NSArray * valueLineColorArr;

@property(strong,nonatomic)NSArray * pointColorArr;
@property(strong,nonatomic)NSArray * positionLineColorArr;
@property(strong,nonatomic)NSArray * pointNumberColorArr;
@property(strong,nonatomic)NSArray * contentFillColorArr;

@property(strong,nonatomic)UIColor * xAndYLineColor;
@property(strong,nonatomic)UIColor * xAndYNumberColor;
@property(assign,nonatomic)CGFloat lineWidth;
/**动画路径宽*/
@property(assign,nonatomic)CGFloat animationPathWidth;
/**是否是曲线*/
@property(assign,nonatomic)BOOL pathCurve;
/**内容是否填充颜色*/
@property(assign,nonatomic)BOOL contentFill;

@end
