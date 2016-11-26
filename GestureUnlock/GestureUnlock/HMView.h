//
//  HMView.h
//  手势解锁
//
//  Created by 胡猛 on 16/10/29.
//  Copyright © 2016年 HuMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMView;

@protocol HMViewDelegate <NSObject>

@optional
-(void)lockView:(HMView *)lockView didFinishPath:(NSString *)path;

@end

@interface HMView : UIView

@property (nonatomic, weak) id<HMViewDelegate>delegate;
@end
