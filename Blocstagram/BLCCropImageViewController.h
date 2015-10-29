//
//  BLCCropImageViewController.h
//  Blocstagram
//
//  Created by Man Hong Lee on 10/25/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BLCMediaFullScreenViewController.h"

@class BLCCropImageViewController;

@protocol BLCCropImageViewControllerDelegate <NSObject>

-(void) cropControllerFinishedWithImage:(UIImage *)croppedImage;

@end

@interface BLCCropImageViewController : BLCMediaFullScreenViewController

-(instancetype) initwithImage:(UIImage *)sourceImage;

@property (nonatomic, weak) NSObject <BLCCropImageViewControllerDelegate> *delegate;

@end
