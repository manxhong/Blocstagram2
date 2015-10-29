//
//  BLCImageLibraryViewController.h
//  Blocstagram
//
//  Created by Man Hong Lee on 10/25/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCImageLibraryViewController;

@protocol BLCImageLibraryViewControllerDelegate <NSObject>

-(void) imageLibraryViewController:(BLCImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image;

@end

@interface BLCImageLibraryViewController : UICollectionViewController

@property (nonatomic, weak) NSObject <BLCImageLibraryViewControllerDelegate> *delegate;
@end
