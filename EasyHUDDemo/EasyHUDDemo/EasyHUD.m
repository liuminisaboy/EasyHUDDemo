//
//  EasyHUD.m
//  EasyHUDDemo
//
//  Created by Sen on 2019/6/10.
//  Copyright © 2019年 easyhud. All rights reserved.
//

#import "EasyHUD.h"

#define kStatusFont     [UIFont boldSystemFontOfSize:15]

@interface EasyHUD()

@property (nonatomic, strong) UILabel* statusLabel;
@property (nonatomic, copy) NSString* status;
@property (nonatomic, assign) BOOL isShowing;   //showing

@property (nonatomic, assign) CGFloat height_statusBar;
@property (nonatomic, assign) CGFloat width_screen;
@property (nonatomic, assign) CGFloat height_navBar;

@end

@implementation EasyHUD

+ (EasyHUD*)share
{
    static EasyHUD* hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hud = [[EasyHUD alloc] init];
        
    });
    return hud;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 2);
        self.layer.shadowOpacity = 0.382;
        self.layer.shadowRadius = 2;
        self.layer.cornerRadius = 3;
        
        UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizer:)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
        [self addGestureRecognizer:swipe];

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
        [self addGestureRecognizer:tap];
        
        self.width_screen = [UIScreen mainScreen].bounds.size.width;
        if (@available(iOS 13.0, *)) {
            UIStatusBarManager* sm = [UIApplication sharedApplication].delegate.window.windowScene.statusBarManager;
            self.height_statusBar = sm.statusBarFrame.size.height;
        }else {
            self.height_statusBar = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        self.height_navBar = 44+self.height_statusBar;
    }
    return self;
}

+ (void)gestureRecognizer:(UIGestureRecognizer*)sender
{
    [self cancelPreviousPerformRequestsWithTarget:self];
    [self dismiss];
}

#pragma mark - set alert text

+ (void)showStatus:(NSString*)status
{
    [self loadheaderViewWithStatus:status bgColor:[UIColor blueColor] textColor:[UIColor whiteColor]];
}
+ (void)showError:(NSString*)status
{
    [self loadheaderViewWithStatus:status bgColor:[UIColor grayColor] textColor:[UIColor whiteColor]];
}
+ (void)loadheaderViewWithStatus:(NSString*)status bgColor:(UIColor*)bgColor textColor:(UIColor*)textColor
{
    [self share].status = status;
    
    [self share].backgroundColor = bgColor;
    [self share].statusLabel.textColor = textColor;
    [self share].statusLabel.text = status;
    
    CGSize statusSize = [self sizeOfStatus:status];
    CGSize selfSize = CGSizeMake(statusSize.width+50, statusSize.height+20);
    
    [self share].statusLabel.frame = CGRectMake(25, 10, statusSize.width, statusSize.height);
    
    [self share].frame = CGRectMake(([self share].width_screen-selfSize.width)*0.5,
                                    [self share].isShowing ? (20+[self share].height_navBar) : [self share].height_statusBar,
                                    selfSize.width,
                                    selfSize.height);
    
    [self share].layer.cornerRadius = selfSize.height*0.5;
    
    if ([self share].isShowing) {
        
        [self cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
        return;
    }
    [self show];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
}


#pragma mark - show & dismiss

+ (void)show
{
    [self share].isShowing = YES;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:[self share]];
    [UIView animateWithDuration:0.382 animations:^{
        [self share].frame = CGRectMake([self share].frame.origin.x,
                                        20+[self share].height_navBar,
                                        [self share].bounds.size.width,
                                        [self share].bounds.size.height);
        [self share].alpha = 1;
    }];
    
}

+ (void)dismiss
{
    if (![self share].status) {
        return;
    }
    
    [UIView animateWithDuration:0.382 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self share].frame = CGRectMake([self share].frame.origin.x,
                                        [self share].height_statusBar,
                                        [self share].bounds.size.width,
                                        [self share].bounds.size.height);
        
        [self share].alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self share].isShowing = NO;
        [[self share] removeFromSuperview];
        [self share].status = nil;
    }];
}

+ (CGSize)sizeOfStatus:(NSString*)status
{
    NSDictionary* attribute = @{NSFontAttributeName:kStatusFont};
    CGSize size = [status boundingRectWithSize:CGSizeMake([self share].width_screen-60, 80) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

#pragma mark - lazy
- (UILabel*)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = kStatusFont;
        _statusLabel.textAlignment = 1;
        _statusLabel.numberOfLines = 0;
        
        [self addSubview:_statusLabel];
    }
    return _statusLabel;
}

@end
