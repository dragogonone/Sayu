//
//  Drawline.m
//  Sayu
//
//  Created by USER on 2014/02/13.
//  Copyright (c) 2014年 USER. All rights reserved.
//

#import "Drawline.h"

@implementation Drawline

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect");
    
    //画面取得
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rrr = sc.bounds;
    
    //枠の色や太さの設定
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
    int i, x;
    for (i=1;i<=2;i++){
        x = rrr.size.width / 3 * i;
        CGContextMoveToPoint(context, x, 0);  // 始点
        CGContextAddLineToPoint(context, x, rrr.size.height);  // 終点
        CGContextStrokePath(context);  // 描画！
    }
    
    
}

//- (void)DeleteRect{
//    NSLog(@"DeleteRect");
//    
//    //画面取得
//    UIScreen *sc = [UIScreen mainScreen];
//    CGRect rrr = sc.bounds;
//    
//    //枠の色や太さの設定
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context,0.0, 0.0, 0.0, 1.0);
//    CGContextSetLineWidth(context, 1.0);
//    int i, x;
//    for (i=1;i<=2;i++){
//        x = rrr.size.width / 3 * i;
//        CGContextMoveToPoint(context, x, 0);  // 始点
//        CGContextAddLineToPoint(context, x, rrr.size.height);  // 終点
//        CGContextStrokePath(context);  // 描画！
//    }
//    
//    
//}


@end
