//
//  MXDirectionAction.h
//  MXDirection
//
//  Created by mx on 2017/4/9.
//  Copyright © 2017年 mengx. All rights reserved.
//

//处理位置，类型等信息
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MXDirectionActionRect,
    MXDirectionActionRoundRect,
    MXDirectionActionCircle
} MXDirectionActionType;

@interface MXDirectionAction : NSObject

@property (nonatomic,assign) MXDirectionActionType type;

@property (nonatomic,assign)CGRect frame;

@property (nonatomic,copy)NSString* hintInfo;

+ (nonnull instancetype)actionWithType:(MXDirectionActionType)type Frame:(CGRect)frame HintInfo:(nonnull NSString*)hintInfo;
@end
