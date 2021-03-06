//
//  BLCCropImageViewController.m
//  Blocstagram
//
//  Created by Man Hong Lee on 10/25/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import "BLCCropImageViewController.h"
#import "BLCCropBox.h"
#import "BLCMedia.h"
#import "BLCImageUtilities.h"

@interface BLCCropImageViewController ()

@property (nonatomic, strong) BLCCropBox *cropBox;
@property (nonatomic, assign) BOOL hasLoadedOnce;
@property (nonatomic, strong) UIToolbar *topView;
@property (nonatomic, strong) UIToolbar *bottomView;

@end

@implementation BLCCropImageViewController

- (instancetype) initwithImage:(UIImage *)sourceImage {
    BLCCropImageViewController *obj = [super init];
    
    if (obj) {
        obj.media = [[BLCMedia alloc] init];
        obj.media.image = sourceImage;
        
        obj.cropBox = [BLCCropBox new];
    }
    
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.cropBox];
    self.topView = [[UIToolbar alloc] init];
    self.bottomView = [[UIToolbar alloc] init];
    UIColor *whiteBG = [UIColor colorWithWhite:1.0 alpha:1.5];
    self.topView.barTintColor = whiteBG;
    self.bottomView.barTintColor = whiteBG;
    self.topView.alpha = 0.5;
    self.bottomView.alpha = 0.5;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Crop", @"Crop command") style:UIBarButtonItemStyleDone target:self action:@selector(cropPressed:)];
    
    self.navigationItem.title = NSLocalizedString(@"Crop Image", nil);
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect cropRect = CGRectZero;
    
    CGFloat edgeSize = MIN(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    cropRect.size = CGSizeMake(edgeSize, edgeSize);
    
    CGSize size = self.view.frame.size;
    
    self.cropBox.frame = cropRect;
    self.cropBox.center = CGPointMake(size.width / 2, size.height / 2);
    self.scrollView.frame = self.cropBox.frame;
    self.scrollView.clipsToBounds = NO;
    
    [self recalculateZoomScale];
    
    if (self.hasLoadedOnce == NO) {
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
        self.hasLoadedOnce = YES;
    }
}

-(void) cropPressed:(UIBarButtonItem *) sender {
    CGRect visibleRect;
    float scale = 1.0f / self.scrollView.zoomScale / self.media.image.scale;
    visibleRect.origin.x = self.scrollView.contentOffset.x * scale;
    visibleRect.origin.y = self.scrollView.contentOffset.y * scale;
    visibleRect.size.width = self.scrollView.bounds.size.width * scale;
    visibleRect.size.height = self.scrollView.bounds.size.height * scale;
    
    UIImage *scrollViewCrop = [self.media.image imageWithFixedOrientation];
    scrollViewCrop = [scrollViewCrop imageCroppedToRect:visibleRect];
    
    [self.delegate cropControllerFinishedWithImage:scrollViewCrop];
}


@end
