//
//  ViewController.m
//  仿摩拜贴纸
//
//  Created by 曾觉新 on 2017/12/6.
//  Copyright © 2017年 曾觉新. All rights reserved.
//

/**
 仿物理运动
 UIDynamicAnimator //运动管理
 

 UIDynamicBehavior - 运动行为（基类）
 * UIGravityBehavior *gravity； - 重力
 * UICollisionBehavior *collision; - 碰撞
 * UIAttachmentBehavior *attach; - 吸附
 * UISnapBehavior *snap; - 振动
 * UIPushBehavior *push; - 推
 * UIDynamicItemBehavior
 **/
#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "BallView.h"


@interface ViewController ()
@property (nonatomic, strong) NSMutableArray<BallView *> *ballViewArr;

@property (nonatomic, strong) CMMotionManager *motionManager;//陀螺仪

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIDynamicItemBehavior *behavior;
@property (nonatomic, strong) UIGravityBehavior *gravity;//重力
@property (nonatomic, strong) UICollisionBehavior *collision;//碰撞

@property (nonatomic, strong) CADisplayLink *displayLink;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ballViewArr = [NSMutableArray array];
    
    
    
    [self caerteBall];
    [self addAnimator];
    [self startMotion];
    
}
- (void)caerteBall
{
    for (int i = 0; i < 10; i++) {
        
        BallView *ballView = [[BallView alloc] initWithFrame:CGRectMake(arc4random() % (NSInteger)(self.view.frame.size.width - 40), 10, 40, 40)];
        ballView.backgroundColor = [UIColor redColor];
        ballView.layer.cornerRadius = 20;
        ballView.layer.masksToBounds = YES;
        [self.view addSubview:ballView];
        
        [self.ballViewArr addObject:ballView];
    }
}

- (void)addAnimator
{
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    _behavior = [[UIDynamicItemBehavior alloc] initWithItems:self.ballViewArr];
    _behavior.allowsRotation = YES;//是否可以滚动
    _behavior.elasticity = 0.6;
    [_dynamicAnimator addBehavior:_behavior];
    
    //重力
    _gravity = [[UIGravityBehavior alloc] initWithItems:self.ballViewArr];
    [_dynamicAnimator addBehavior:_gravity];
    
    //碰撞
    _collision = [[UICollisionBehavior alloc] initWithItems:self.ballViewArr];
    _collision.collisionMode = UICollisionBehaviorModeEverything;
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    [_dynamicAnimator addBehavior:_collision];
}

- (void)startMotion
{
    self.motionManager = [[CMMotionManager alloc] init];
    if (_motionManager.accelerometerAvailable) {
        
        _motionManager.accelerometerUpdateInterval = 0.01;
        __weak __typeof(self) weakSelf = self;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (error) {
                [weakSelf.motionManager stopAccelerometerUpdates];
                NSLog(@"error:%@", error);
            } else {
                
                NSLog(@"elapsedTime = %f", weakSelf.dynamicAnimator.elapsedTime);
                NSLog(@"running = %d", weakSelf.dynamicAnimator.running);
                
                CMAcceleration gravity = motion.gravity;
                double x = gravity.x;
                double y = gravity.y;
                
                CGFloat dx = 0;
                CGFloat dy = 0;
                if (x > 0) {
                    dx = 1;
                } else {
                    dx = -1;
                }
                
                if (y <= 0) {
                    dy = 1;
                } else {
                    dy = -1;
                }
                
                CGVector vector = CGVectorMake(dx, dy);
                weakSelf.gravity.gravityDirection = vector;//重力方向
                
            }
        }];
    } else {
        NSLog(@"没有陀螺仪");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
