//
//  CJChart.h
//  CJChartDemo
//
//  Created by eric on 16/12/29.
//  Copyright © 2016年 eric. All rights reserved.
//
/*******************************************
 *
 *
 *
 *   自定义图表绘制 包括折线图 柱状图 饼状图等等
 *
 *
 *
 ********************************************/

#import <UIKit/UIKit.h>

#define PointMake(x,y)  CGPointMake(x, y)
#define weakSelf(weakSelf)  __weak typeof(self) weakSelf = self;

@interface CJChart : UIView
/**chart的边界值*/
@property(assign , nonatomic) UIEdgeInsets contentInsets;
/**表格的起始位置*/
@property(assign , nonatomic) CGPoint chartOrigin;
/**表格的名称*/
@property(assign , nonatomic) NSString * chartTitle;
/**
 *  绘制线段
 *
 *  @param context  图形绘制上下文
 *  @param start    起点
 *  @param end      终点
 *  @param isDotted 是否是虚线
 *  @param color    线段颜色
 */
- (void)drawLineWithContext:(CGContextRef)context andStartPoint:(CGPoint)start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color;
/**
 * 绘制文字
 * @param context 图形绘制上下文
 * @param point 绘制点
 * @param text 绘制文字
 * @param color 绘制文字颜色
 * @param font 文字字体
 */
- (void)drawText:(NSString *)text context:(CGContextRef)context atPoint:(CGPoint)point andColor:(UIColor *)color andFont:(UIFont *)font;

- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )point WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize;

- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text;

- (void)drawQuartWithColor:(UIColor *)color andBeginPoint:(CGPoint)point andContext:(CGContextRef)context;

- (void)drawPointWithRedius:(CGFloat)radius andColor:(UIColor *)color andPoint:(CGPoint)point andContext:(CGContextRef)context;

- (CGSize)sizeWithStringWithMaxSize:(CGSize)maxSize textFont:(CGFloat)fontSize aimString:(NSString *)aimString;
/**
 * 显示动画
 */
- (void)showAnimation;

/**
 *  清除当前视图  
 */
- (void)clear;
@end
