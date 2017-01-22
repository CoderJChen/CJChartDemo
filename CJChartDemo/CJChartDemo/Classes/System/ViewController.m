//
//  ViewController.m
//  CJChartDemo
//
//  Created by eric on 16/12/29.
//  Copyright © 2016年 eric. All rights reserved.
//

#import "ViewController.h"
#import "CJLineChart.h"

#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CJLineChart * chart = [[CJLineChart alloc]initWithFrame:CGRectMake(10, 100, k_MainBoundsWidth-20, 300)];
    chart.valueArr = @[@[@"1",@"12",@"1",@6,@4,@9,@6,@7],@[@"3",@"1",@"2",@16,@2,@3,@5,@10]];
    
    chart.valueLineColorArr =@[[UIColor purpleColor],[UIColor brownColor]];
   
    chart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    chart.xAndYLineColor = [UIColor blackColor];
    
    chart.xAndYNumberColor = [UIColor blueColor];
    
    chart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
    
    chart.contentFill = YES;
    
    chart.pathCurve = YES;
    
    chart.contentFillColorArr = @[[UIColor colorWithRed:0.500 green:0.000 blue:0.500 alpha:0.468],[UIColor colorWithRed:0.500 green:0.214 blue:0.098 alpha:0.468]];
    [self.view addSubview:chart];
    [chart showAnimation];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
