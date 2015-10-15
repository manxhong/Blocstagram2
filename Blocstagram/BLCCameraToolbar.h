//
//  BLCCameraToolbar.h
//  
//
//  Created by Man Hong Lee on 10/15/15.
//
//

#import <UIKit/UIKit.h>

@class BLCCameraToolbar;

@protocol BLCCameraToolbarDelegate <NSObject>

-(void) leftButtonPressedOnToolbar:(BLCCameraToolbar *)toolbar;
-(void) rightButtonPressedOnToolbar:(BLCCameraToolbar *)toolbar;
-(void) cameraButtonPressedOnToolbar:(BLCCameraToolbar *)toolbar;

@end

@interface BLCCameraToolbar : UIView

- (instancetype) initWithImageNames:(NSArray *)imageNames;

@property (nonatomic, weak) NSObject <BLCCameraToolbarDelegate> *delegate;

@end
