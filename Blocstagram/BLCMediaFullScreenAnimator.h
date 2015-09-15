//
//  BLCMediaFullScreenAnimator.h
//  Blocstagram
//
//  Created by Man Hong Lee on 9/15/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BLCMediaFullScreenAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, weak) UIImageView *cellImageView;

@end
