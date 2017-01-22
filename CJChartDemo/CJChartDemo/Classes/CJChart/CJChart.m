//
//  CJChart.m
//  CJChartDemo
//
//  Created by eric on 16/12/29.
//  Copyright © 2016年 eric. All rights reserved.
//

#import "CJChart.h"

@implementation CJChart
- (void)showAnimation{

}
- (void)clear{

}
/**
 *  绘制线段
 *
 *  @param context  图形绘制上下文
 *  @param start    起点
 *  @param end      终点
 *  @param isDotted 是否是虚线
 *  @param color    线段颜色
 */
-(void)drawLineWithContext:(CGContextRef)context andStartPoint:(CGPoint)start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color{
    
    CGContextMoveToPoint(context, start.x, start.y);
    
    CGContextAddLineToPoint(context, end.x, end.y);
    
    CGContextSetLineWidth(context, 0.5);
    
    [color setStroke];
    
    if (isDotted) {
//        绘制虚线0.5个实线，2个虚线
//        c语言下的数组
        CGFloat ss[] = {0.5,2,1};
//        第一个参数是上下文 第二个参数表示距离线段多少的像素点开始绘制虚线 ，第三个表示虚线的绘制规律数组，如上面的ss数组，表示第一段0.5个像素长度为实线，紧接着2个像素的虚线，再接着1个像素的实线。第四个参数表示如果第三个参数传入数组，则执行绘制的虚线规律数组到第几个。如传入2，表示绘制规律为数组中的前两个元素。
        CGContextSetLineDash(context, 0, ss, 2);
    }
    CGContextMoveToPoint(context, end.x, end.y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}
/**
 *  绘制文字
 *
 *  @param text    文字内容
 *  @param context 图形绘制上下文
 *  @param point    绘制点
 *  @param color   绘制颜色
 */
- (void)drawText:(NSString *)text context:(CGContextRef)context atPoint:(CGPoint)point andColor:(UIColor *)color andFont:(UIFont *)font{
    [[NSString stringWithFormat:@"%@",text] drawAtPoint:point withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
}

- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )point WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize{
    [[NSString stringWithFormat:@"%@",text]drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:color}];
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
}

/**
 *  判断文本宽度
 *
 *  @param text 文本内容
 *
 *  @return 文本宽度
 */

- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text{
    CGSize size = [[NSString stringWithFormat:@"%@",text] boundingRectWithSize:CGSizeMake(100, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7.0]} context:nil].size;
    return size.width;
}
/**
 *  绘制长方形
 *
 *  @param color  填充颜色
 *  @param point     开始点
 *  @param context 图形上下文
 */
- (void)drawQuartWithColor:(UIColor *)color andBeginPoint:(CGPoint)point andContext:(CGContextRef)context{
    CGContextAddRect(context, CGRectMake(point.x, point.y, 10, 10));
    [color setFill];
    [color setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}
/**
 *  返回字符串的占用尺寸
 *
 *  @param maxSize   最大尺寸
 *  @param fontSize  字号大小
 *  @param aimString 目标字符串
 *
 *  @return 占用尺寸
 */

- (CGSize)sizeWithStringWithMaxSize:(CGSize)maxSize textFont:(CGFloat)fontSize aimString:(NSString *)aimString{
    return [[NSString stringWithFormat:@"%@",aimString] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}

- (void)drawPointWithRedius:(CGFloat)radius andColor:(UIColor *)color andPoint:(CGPoint)point andContext:(CGContextRef)context{
    CGContextAddArc(context, point.x, point.y,radius, 0, M_PI * 2, YES);
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
}

@end
