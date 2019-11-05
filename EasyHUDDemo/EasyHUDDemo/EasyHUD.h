//
//  EasyHUD.h
//  EasyHUDDemo
//
//  Created by Sen on 2019/6/10.
//  Copyright © 2019年 easyhud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasyHUD : UIView

+ (void)showStatus:(NSString*)status;
+ (void)showError:(NSString*)status;

@end

NS_ASSUME_NONNULL_END
