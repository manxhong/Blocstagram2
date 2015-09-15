//
//  BLCMediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Man Hong Lee on 9/15/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCMedia;

@interface BLCMediaFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

-(instancetype) initWithMedia:(BLCMedia *)media;

-(void) centerScrollView;
@end
