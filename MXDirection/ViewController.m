//
//  ViewController.m
//  MXDirection
//
//  Created by mx on 2017/4/9.
//  Copyright © 2017年 mengx. All rights reserved.
//

#import "ViewController.h"
#import "MXDirectionView.h"

extern NSString* MXDirectionEndNotification;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CATextLayer* layer = [CATextLayer layer];
    
    layer.backgroundColor = [[UIColor blackColor] CGColor];
    
    layer.opacity = 0.5;
    
    layer.fontSize = 12;
    
    layer.alignmentMode = kCAAlignmentCenter;
    
    layer.wrapped = true;
    
    layer.frame = CGRectMake(50, 200, 100, 100);
    //@"我是测试数据啊 啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊";
    layer.string = MXDirectionEndNotification;
    
//    [self.view.layer insertSublayer:layer atIndex:1];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建几个按钮
    UIButton* button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    
    [button1 setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    
    UIButton* button2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 30, self.view.frame.size.height - 30, 30, 30)];
    
    [button2 setBackgroundImage:[UIImage imageNamed:@"film"] forState:UIControlStateNormal];
    
    UIButton* button3 = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height -30, 30, 30)];
    
    [button3 setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    
    UIButton* button4 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 30, self.view.frame.size.height / 2, 30, 30)];
    
    [button4 setBackgroundImage:[UIImage imageNamed:@"password"] forState:UIControlStateNormal];
    
    UIButton* button5 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 30, 30, 30, 30)];
    
    [button5 setBackgroundImage:[UIImage imageNamed:@"internet"] forState:UIControlStateNormal];
    
    UIButton* button6 = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height / 2, 30, 30)];
    
    [button6 setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    UIButton* button7 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, 30, 30)];
    
    [button7 setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    UIButton* button8 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 30, 30)];
    
    [button8 setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    UIButton* button9 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 30, 30, 30)];
    
    [button9 setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    [self.view addSubview:button4];
    [self.view addSubview:button5];
    [self.view addSubview:button6];
    [self.view addSubview:button7];
    [self.view addSubview:button8];
    [self.view addSubview:button9];
    
    NSMutableArray* array = [NSMutableArray arrayWithObjects:
            [MXDirectionAction actionWithType:MXDirectionActionCircle Frame:button1.frame HintInfo:@"点击下一个功能"],
            [MXDirectionAction actionWithType:MXDirectionActionCircle Frame:button2.frame HintInfo:@"点击返回功能"],
            [MXDirectionAction actionWithType:MXDirectionActionCircle Frame:button3.frame HintInfo:@"点击删除功能"],
            [MXDirectionAction actionWithType:MXDirectionActionRoundRect Frame:button4.frame HintInfo:@"设置密码功能"],
            [MXDirectionAction actionWithType:MXDirectionActionRect Frame:button5.frame HintInfo:@"访问互联网功能"],
            [MXDirectionAction actionWithType:MXDirectionActionCircle Frame:button6.frame HintInfo:@"设置多选选项功能"],
            [MXDirectionAction actionWithType:MXDirectionActionCircle Frame:button7.frame HintInfo:@"设置多选选项功能"],
            [MXDirectionAction actionWithType:MXDirectionActionCircle Frame:button8.frame HintInfo:@"设置多选选项功能"],
            [MXDirectionAction actionWithType:MXDirectionActionCircle Frame:button9.frame HintInfo:@"设置多选选项功能"],
     nil];
    
    [MXDirectionView showDirectionWithActions:array BackGroundColor:[UIColor blackColor]  TextColor:[UIColor whiteColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
