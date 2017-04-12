//
//  MXDirectionShadeView.m
//  MXDirection
//
//  Created by mx on 2017/4/9.
//  Copyright © 2017年 mengx. All rights reserved.
//

#import "MXDirectionView.h"
#import "MXDirectionAction.h"

extern NSString* MXDirectionEndNotification;

@interface MXDirectionView()

@property (nonatomic,weak) MXDirectionShadeLayer* shadeLayer;

@end

@implementation MXDirectionView

+ (void)showDirectionWithActions:(NSMutableArray<MXDirectionAction *> *)actions BackGroundColor:(nonnull UIColor *)backgroundColor TextColor:(nonnull UIColor *)textColor{
    //首先判断是否是第一次运行
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"MXDirectionFirst"]){
        //创建ShadeView
        MXDirectionView* shadeView = [self MXDirectionViewWithActions:actions BackGroundColor:backgroundColor TextColor:textColor];
        
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:shadeView];
        //保存，已经不是第一次运行了
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MXDirectionFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        return ;
    }
}

+ (instancetype)MXDirectionViewWithActions:(NSMutableArray<MXDirectionAction *> *)actions BackGroundColor:(UIColor*)backGroundcolor TextColor:(UIColor*)textColor{
    
    MXDirectionView* shadeView = [[MXDirectionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //初始化相关属性
    MXDirectionShadeLayer* layer = [MXDirectionShadeLayer initWithFrame:shadeView.bounds DirectionActions:actions TextColor:textColor BackGroundColor:backGroundcolor];
    
    shadeView.shadeLayer = layer;
    
    //注册通知
    [NSNotificationCenter.defaultCenter addObserver:shadeView selector:@selector(directionEnd) name:MXDirectionEndNotification object:nil];
    //添加
    [shadeView.layer insertSublayer:layer atIndex:0];
    
    return shadeView;
    
}
//取消点击的时候，调用下一个指引
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //执行下一个操作
    [self.shadeLayer nextAction];
}


- (void) directionEnd{
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //执行动画,缩小
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        //去除显示层
        [self.shadeLayer removeFromSuperlayer];
        //从SuperView
        [self removeFromSuperview];
        //取消通知
        [NSNotificationCenter.defaultCenter removeObserver:self];
    }];
}
@end
