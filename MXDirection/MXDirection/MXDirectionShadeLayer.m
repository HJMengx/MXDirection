//
//  MXDirectionShadeLayer.m
//  MXDirection
//
//  Created by mx on 2017/4/9.
//  Copyright © 2017年 mengx. All rights reserved.
//

#import "MXDirectionShadeLayer.h"

const int infoRectOfWidthAndHeight = 150;

const int CircleOffset = 5;

NSString* const MXDirectionEndNotification = @"MXDirectionEndNotification";

@interface MXDirectionShadeLayer()

@property (nonatomic,assign)int currentUrl;

@property (nonatomic,strong)UIBezierPath* maskRectPath;

@property (nonatomic,weak)CAShapeLayer* infoLayer;

@property (nonatomic,strong)UIColor* textColor;

@end

@implementation MXDirectionShadeLayer

+ (instancetype)initWithFrame:(CGRect)frame DirectionActions:(NSMutableArray *)actions TextColor:(nonnull UIColor *)color BackGroundColor:(nonnull UIColor *)backgroundColor{
    
    MXDirectionShadeLayer* layer = [[super alloc] init];
    
    layer.frame = frame;
    
    layer.backgroundColor = backgroundColor.CGColor;
    
    layer.textColor = color;
    //初始化MaskLayer
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    
    [maskLayer setFrame:layer.bounds];
    
    //设置MaskLayer的路径
    UIBezierPath* maskLayerPath = [UIBezierPath bezierPathWithRect:maskLayer.bounds];
    
    layer.directionActions = actions;
    
    layer.currentUrl = 0;
    
    //保存mask矩形路径
    layer.maskRectPath = [maskLayerPath copy];
    
    //创建mask以及镂空效果的路径
    UIBezierPath* path = [layer settingMaskAttributes];
    
    [maskLayerPath appendPath:[path bezierPathByReversingPath]];
    
    maskLayer.path = maskLayerPath.CGPath;
    
    //设置Mask
    layer.mask = maskLayer;
    
    //显示提示框
    [layer showAction];
    
    return layer;
}

//MARK: 初始化相关操作
- (UIBezierPath*) settingMaskAttributes{
    //设置SubLayer
    UIBezierPath* path;
    
    switch (self.directionActions[self.currentUrl].type) {
        case MXDirectionActionRect:
            //矩形
            path = [UIBezierPath bezierPathWithRect: self.directionActions[self.currentUrl].frame];
            break;
        case MXDirectionActionRoundRect:
            //圆角矩形
            path = [UIBezierPath bezierPathWithRoundedRect: self.directionActions[self.currentUrl].frame cornerRadius:5];
            break;
        default:
            //Circle
            //需要将半径扩大
            path = [UIBezierPath bezierPath];
            
            CGPoint center = CGPointMake(self.directionActions[self.currentUrl].frame.size.width / 2 + self.directionActions[self.currentUrl].frame.origin.x, self.directionActions[self.currentUrl].frame.size.height / 2 + self.directionActions[self.currentUrl].frame.origin.y);
            
            CGFloat radius = (self.directionActions[self.currentUrl].frame.size.width / 2 > self.directionActions[self.currentUrl].frame.size.height / 2) ? self.directionActions[self.currentUrl].frame.size.width / 2 : self.directionActions[self.currentUrl].frame.size.height / 2;
            
            [path addArcWithCenter:center radius:radius + CircleOffset startAngle:0 endAngle:M_PI * 2 clockwise:true];
            
            break;
    }
    
    return path;
}

//MARK: Show
- (void)showAction{
    //取出对应位置的Action
    MXDirectionAction* action = self.directionActions[self.currentUrl];
    
    //判断action的位置
    //左右中
    //0:左 1:右 2:中
    int horizontal;
    //0:上 1:下 2:中
    int vertical;
    
    //水平方向
    if(action.frame.origin.x <= self.bounds.size.width / 3.0){
        //左边
        horizontal = 0;
    }else if (action.frame.origin.x >= self.bounds.size.width / 3.0 * 2 ){
        //右边
        horizontal = 1;
    }else{
        //中间
        horizontal = 2;
    }
    
    //垂直方向
    if(action.frame.origin.y <= self.bounds.size.height / 3.0){
        //左边
        vertical = 0;
    }else if (action.frame.origin.y >= self.bounds.size.height / 3.0 * 2 ){
        //右边
        vertical = 1;
    }else{
        //中间
        vertical = 2;
    }
    //创建显示信息框
    CAShapeLayer* infoLayer = [CAShapeLayer layer];
    
    self.infoLayer = infoLayer;
    //起始坐标
    int infoLayerOriginX,infoLayerOriginY;
    
    //初始小圆的位置
    int hintInfoFirstLayerOriginX,hintInfoFirstLayerOriginY;
    //求水平方向的坐标
    switch (horizontal) {
        case 0:
            //左边
            //最右边的位置
            infoLayerOriginX = action.frame.origin.x + action.frame.size.width / 2.0;
            
            hintInfoFirstLayerOriginX = 5;
            
            break;
        case 1:
            //右边
            //保存靠近左边的位置
            infoLayerOriginX = action.frame.origin.x + action.frame.size.width / 2.0 - infoRectOfWidthAndHeight;
            
            hintInfoFirstLayerOriginX = infoRectOfWidthAndHeight - 5;
            
            break;
        default:
            //中间
            infoLayerOriginX = action.frame.origin.x + action.frame.size.width / 2.0;
            
            hintInfoFirstLayerOriginX = 5;
            
            break;
    }
    
    //垂直方向的坐标
    
    switch (vertical) {
        case 0:
            //上
            infoLayerOriginY = action.frame.origin.y + action.frame.size.height;
            
            hintInfoFirstLayerOriginY = 10;
            break;
        case 1:
            //下
            infoLayerOriginY = action.frame.origin.y - infoRectOfWidthAndHeight;
            
            hintInfoFirstLayerOriginY = infoRectOfWidthAndHeight - 10;
            break;
            
        default:
            //中
            infoLayerOriginY = action.frame.origin.y + action.frame.size.height;
            
            hintInfoFirstLayerOriginY = 10;
            break;
    }
    //设置Frame
    infoLayer.frame = CGRectMake(infoLayerOriginX, infoLayerOriginY, infoRectOfWidthAndHeight, infoRectOfWidthAndHeight);
    //创建文本Layer
    CATextLayer* textLayer = [CATextLayer layer];
    
    //创建路径
    UIBezierPath* finallyPath = [UIBezierPath bezierPath];
    
    //路径创建分为朝上还是朝下
    if(vertical == 1){
        //朝上
        //还需要分为朝左还是朝右
        if(horizontal == 1){
            //朝左
            //创建第一个圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX, hintInfoFirstLayerOriginY, 6, 4)]];
            
            //创建第二个圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX - 19, hintInfoFirstLayerOriginY - 15, 11, 8)]];
            
            //创建第三个椭圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX - 136.5 , hintInfoFirstLayerOriginY - 106, 118, 90)]];
            
            
            textLayer.frame = CGRectMake(hintInfoFirstLayerOriginX - 136.5 + 114 / 4, hintInfoFirstLayerOriginY - 106 + 90 / 4, 114 / 2, 90 / 2);
        }else{
            //朝右
            //创建第一个圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX, hintInfoFirstLayerOriginY, 6, 4)]];
            
            //创建第二个圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX + 8, hintInfoFirstLayerOriginY - 15, 11, 8)]];
            
            //创建第三个椭圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX + 18.5 , hintInfoFirstLayerOriginY - 106, 118, 90)]];
            
            textLayer.frame = CGRectMake(hintInfoFirstLayerOriginX + 23.5 + 114 / 4, hintInfoFirstLayerOriginY - 106 + 90 / 4, 114 / 2, 90 / 2);
        }

    }else{
        //朝下
        //判断左右
        if(horizontal == 1){
            //朝左
            //创建第一个圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX, hintInfoFirstLayerOriginY, 6, 4)]];
            
            //创建第二个圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX - 19, hintInfoFirstLayerOriginY + 7, 11, 8)]];
            
            //创建第三个椭圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX - 136.5 , hintInfoFirstLayerOriginY + 16, 118, 90)]];
            
            
            textLayer.frame = CGRectMake(hintInfoFirstLayerOriginX - 136.5 + 114 / 4, hintInfoFirstLayerOriginY + 20 + 90 / 4, 114 / 2, 90 / 2);
        }else{
            //朝右
            //创建第一个圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX, hintInfoFirstLayerOriginY, 6, 4)]];
            
            //创建第二个圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX + 8, hintInfoFirstLayerOriginY + 7, 11, 8)]];
            
            //创建第三个椭圆
            [finallyPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(hintInfoFirstLayerOriginX + 18.5 , hintInfoFirstLayerOriginY + 16, 118, 90)]];
            
            
            textLayer.frame = CGRectMake(hintInfoFirstLayerOriginX + 22 + 114 / 4, hintInfoFirstLayerOriginY + 20 + 90 / 4, 114 / 2, 90 / 2);
        }
    }
    textLayer.wrapped = true;
    
    textLayer.fontSize = 10;
    
    textLayer.string = action.hintInfo;
    
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    textLayer.alignmentMode = kCAAlignmentCenter;
    
    textLayer.foregroundColor = [self.textColor CGColor];
    
    [infoLayer insertSublayer:textLayer atIndex:0];
    
    //给予路径
    infoLayer.path = finallyPath.CGPath;
    
    //创建路径绘制动画
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    anim.fromValue = [NSNumber numberWithInt:0];
    
    anim.toValue = [NSNumber numberWithInt:1];
    
    anim.duration = 0.75;
    
    anim.autoreverses = false;
    
    anim.fillMode = kCAFillModeForwards;
    
    //创建显示文本动画
    CABasicAnimation* textAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    textAnim.fromValue = [NSNumber numberWithInt:0];
    
    textAnim.toValue = [NSNumber numberWithInt:1];
    
    textAnim.duration = 1;
    
    textAnim.autoreverses = false;
    
    textAnim.fillMode = kCAFillModeForwards;
    //设置渲染相关属性
    infoLayer.strokeColor = [self.textColor CGColor];
    
    infoLayer.lineWidth = 2;
    
    //添加信息
    [self insertSublayer:infoLayer atIndex:0];
    
    //添加动画
    [infoLayer addAnimation:anim forKey:@"InfoPathAnim"];
    
    [textLayer addAnimation:textAnim forKey:@"textAnimation"];
}

//MARK: Action
- (void)nextAction{
    //判断下标是否为最后一个
    if(self.currentUrl == self.directionActions.count - 1){
        //最后一个，直接结束，通知
        [NSNotificationCenter.defaultCenter postNotificationName:MXDirectionEndNotification object:nil];
        
        return;
    }
    //删除当前信息框
    if(self.infoLayer){
        [self.infoLayer removeFromSuperlayer];
    }
    //下标+
    self.currentUrl++;
    //设置mask
    //MARK: 这里还要修改
    
    UIBezierPath* maskPath = [self.maskRectPath copy];
    
    [maskPath appendPath:[[self settingMaskAttributes] bezierPathByReversingPath]];
    
    //使用动画过度过去
    CABasicAnimation* passMaskAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    passMaskAnim.fromValue = (__bridge id _Nullable)(((CAShapeLayer*)self.mask).path);
    
    passMaskAnim.toValue = (__bridge id _Nullable)(maskPath.CGPath);
    
    passMaskAnim.duration = 0.5;
    
    passMaskAnim.fillMode = kCAFillModeForwards;
    
    passMaskAnim.removedOnCompletion = NO;
    
    ((CAShapeLayer*)self.mask).path = maskPath.CGPath;
    
    [((CAShapeLayer*)self.mask) addAnimation:passMaskAnim forKey:@"MaskAnim"];
    //显示
    [self showAction];
}

@end
