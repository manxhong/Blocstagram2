//
//  BLCMediaFullScreenViewController.m
//  Blocstagram
//
//  Created by Man Hong Lee on 9/15/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import "BLCMediaFullScreenViewController.h"
#import "BLCMedia.h"

@interface BLCMediaFullScreenViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@property (nonatomic, strong) UITapGestureRecognizer *tapBehind;
@end

@implementation BLCMediaFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    self.imageView = [UIImageView new];
    self.imageView.image = self.media.image;
    
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.media.image.size;
    
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButton)];

    UINavigationItem *newItem = [UINavigationItem new];
    newItem.rightBarButtonItem = shareButton;
    [navbar setItems:@[newItem]];

    
    self.tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];

    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapFired:)];
    self.doubleTap.numberOfTapsRequired = 2;
    
    [self.tap requireGestureRecognizerToFail:self.doubleTap];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone == NO) {
        self.tapBehind = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBehindFired:)];
        self.tapBehind.cancelsTouchesInView = NO;
    }
    
    [self.scrollView addGestureRecognizer:self.tap];
    [self.scrollView addGestureRecognizer:self.doubleTap];
    [self.view addSubview:navbar];
    // Do any additional setup after loading the view.
}

#pragma mark - Gesture Recognizers

-(void) tapFired:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) doubleTapFired:(UITapGestureRecognizer *)sender{
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        CGPoint locationPoint = [sender locationInView:self.imageView];
        
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
        CGFloat x = locationPoint.x - (width / 2);
        CGFloat y = locationPoint.y - (height / 2);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, width, height) animated:YES];
    }else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    
    [self recalculateZoomScale];}

-(void) recalculateZoomScale{
    
    CGSize scrollViewFrameSize = self.scrollView.frame.size;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    scrollViewContentSize.height /= self.scrollView.zoomScale;
    scrollViewContentSize.width /= self.scrollView.zoomScale;
    
    CGFloat scaleWidth = scrollViewFrameSize.width / scrollViewContentSize.width;
    CGFloat scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self centerScrollView];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone == NO) {
        [[[[UIApplication sharedApplication] delegate] window] addGestureRecognizer:self.tapBehind];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone == NO) {
        [[[[UIApplication sharedApplication] delegate] window] removeGestureRecognizer:self.tapBehind];
    }
}

-(void) tapBehindFired:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:nil];
        CGPoint locationInVC = [self.presentedViewController.view convertPoint:location fromView:self.view.window];
        
        if ([self.presentedViewController.view pointInside:locationInVC withEvent:nil] == NO) {
            
            
            if (self.presentedViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

- (void)centerScrollView {
    [self.imageView sizeToFit];
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - CGRectGetWidth(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.x = 0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - CGRectGetHeight(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.y = 0;
    }
    
    self.imageView.frame = contentsFrame;
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(instancetype) initWithMedia:(BLCMedia *)media {
    self = [super init];
    
    if (self) {
        self.media = media;
    }
    
    return self;
}

#pragma mark - share

-(void) shareButton {
    NSArray *itemToShare = @[self.media.caption, self.media.image];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
