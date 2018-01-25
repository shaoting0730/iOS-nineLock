//
//  NineLockView.h
//  lockView
//
//  Created by Shaoting Zhou on 2018/1/24.
//  Copyright © 2018年 Shaoting Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NineLockView;
@protocol NineLockViewDelegate <NSObject>

@optional
- (void)lockView:(NineLockView *)lockView didFinishPath:(NSString *)path;
@end

@interface NineLockView : UIView
@property (nonatomic,assign) id<NineLockViewDelegate>delegete;
@end
