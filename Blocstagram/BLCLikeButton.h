//
//  BLCLikeButton.h
//  Blocstagram
//
//  Created by Man Hong Lee on 10/2/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLCLikeState) {
    BLCLikeStateNotLiked                = 0,
    BLCLikeStateLiking                  = 1,
    BLCLikeStateLiked                   = 2,
    BLCLikeStateUnliking                = 3
};

@interface BLCLikeButton : UIButton

@property (nonatomic, assign) BLCLikeState likeButtonState;

@end
