//
//  MXDirectionAction.m
//  MXDirection
//
//  Created by mx on 2017/4/9.
//  Copyright © 2017年 mengx. All rights reserved.
//

#import "MXDirectionAction.h"

@implementation MXDirectionAction

+ (instancetype)actionWithType:(MXDirectionActionType)type Frame:(CGRect)frame HintInfo:(NSString *)hintInfo{
    
    MXDirectionAction* action = [[MXDirectionAction alloc] init];
    
    action.type = type;
    
    action.frame = frame;
    
    action.hintInfo = hintInfo;
    
    return action;
}

@end
