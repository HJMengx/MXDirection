//
//  MXDirectionShadeLayer.h
//  MXDirection
//
//  Created by mx on 2017/4/9.
//  Copyright © 2017年 mengx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MXDirectionAction.h"


@interface MXDirectionShadeLayer : CAShapeLayer

//所有的需要指引的事件
@property (nonnull,nonatomic,strong)NSMutableArray<MXDirectionAction*>* directionActions;


+ (nonnull instancetype) initWithFrame:(CGRect)frame  DirectionActions:(nonnull NSMutableArray*)actions TextColor:(nonnull UIColor*)color BackGroundColor:(nonnull UIColor*)backgroundColor;


- (void)nextAction;


@end
