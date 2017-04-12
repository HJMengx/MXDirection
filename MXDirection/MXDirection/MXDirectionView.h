//
//  MXDirectionShadeView.h
//  MXDirection
//
//  Created by mx on 2017/4/9.
//  Copyright © 2017年 mengx. All rights reserved.
//

//遮罩
#import <UIKit/UIKit.h>
#import "MXDirectionShadeLayer.h"

@interface MXDirectionView : UIView

+ (void)showDirectionWithActions:(nonnull NSMutableArray<MXDirectionAction*>*)actions BackGroundColor:(nonnull UIColor*)backgroundColor TextColor:(nonnull UIColor*)textColor;

@end
