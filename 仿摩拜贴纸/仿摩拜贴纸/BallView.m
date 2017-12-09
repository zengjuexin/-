//
//  BallView.m
//  仿摩拜贴纸
//
//  Created by 曾觉新 on 2017/12/6.
//  Copyright © 2017年 曾觉新. All rights reserved.
//

#import "BallView.h"

@interface BallView()



@end

@implementation BallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *d = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        d.backgroundColor = [UIColor blueColor];
        [self addSubview:d];
        
        
        
    }
    return self;
}
//非常重要，没有的话滚动会不自然
- (UIDynamicItemCollisionBoundsType)collisionBoundsType {
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

