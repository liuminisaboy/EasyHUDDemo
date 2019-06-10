//
//  EasyHUD.m
//  EasyHUDDemo
//
//  Created by Sen on 2019/6/10.
//  Copyright © 2019年 easyhud. All rights reserved.
//

#import "EasyHUD.h"

#define kHUD_width      [UIScreen mainScreen].bounds.size.width
#define kHUD_height     ([UIApplication sharedApplication].statusBarFrame.size.height + 44)
#define kStatus_y       [UIApplication sharedApplication].statusBarFrame.size.height

@interface EasyHUD()

@property (nonatomic, strong) UILabel* statusLabel;
@property (nonatomic, copy) NSString* status;
@property (nonatomic, assign) BOOL isShowing;   //showing

@end

@implementation EasyHUD

+ (EasyHUD*)share
{
    static EasyHUD* hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UIBlurEffect* blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        hud = [[self alloc] initWithEffect:blur];
        hud.frame = CGRectMake(0, 0, kHUD_width, kHUD_height);
        hud.layer.masksToBounds = YES;
        
        UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizer:)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
        [hud addGestureRecognizer:swipe];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
        [hud addGestureRecognizer:tap];
        
    });
    return hud;
}


#pragma mark - set alert text

+ (void)showStatus:(NSString*)status{
    [self loadHUDWithStatus:status bgColor:[[UIColor greenColor] colorWithAlphaComponent:0.618] textColor:[UIColor blackColor]];
}
+ (void)showError:(NSString*)status{
    [self loadHUDWithStatus:status bgColor:[[UIColor redColor] colorWithAlphaComponent:0.618] textColor:[UIColor whiteColor]];
}
+ (void)loadHUDWithStatus:(NSString*)status bgColor:(UIColor*)bgColor textColor:(UIColor*)textColor
{
    [self share].status = status;
    
    [self share].backgroundColor = bgColor;
    [self share].statusLabel.textColor = textColor;
    [self share].statusLabel.text = status;
    
    if ([self share].isShowing) {
        [self cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
        
        return;
    }
    
    [self show];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
}


#pragma mark - show & dismiss

+ (void)gestureRecognizer:(UIGestureRecognizer*)sender
{
    [self cancelPreviousPerformRequestsWithTarget:self];
    [self dismiss];
}



+ (void)show
{
    
    [self share].isShowing = YES;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:[self share]];
    [UIView animateWithDuration:0.35 animations:^{
        [self share].frame = CGRectMake([self share].frame.origin.x,
                                        0,
                                        [self share].bounds.size.width,
                                        [self share].bounds.size.height);
    }];
}

+ (void)dismiss
{
    if (![self share].status) {
        return;
    }
    [UIView animateWithDuration:0.35 animations:^{
        [self share].frame = CGRectMake([self share].frame.origin.x,
                                        -[self share].bounds.size.height,
                                        [self share].bounds.size.width,
                                        [self share].bounds.size.height);
    } completion:^(BOOL finished) {
        [self share].isShowing = NO;
        [[self share] removeFromSuperview];
        [self share].status = nil;
    }];
}

#pragma mark - lazu

- (UILabel*)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kStatus_y, kHUD_width-20, 44)];
        _statusLabel.font = [UIFont boldSystemFontOfSize:15];
        _statusLabel.textAlignment = 1;
        _statusLabel.numberOfLines = 0;
        [self.contentView addSubview:_statusLabel];
    }
    return _statusLabel;
}

@end
