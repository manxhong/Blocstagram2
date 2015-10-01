//
//  BLCMediaTableViewCell.h
//  Blocstagram
//
//  Created by Man Hong Lee on 2/2/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCMedia, BLCMediaTableViewCell;

@protocol BLCMediaTableViewCellDelegate <NSObject>

- (void) cell:(BLCMediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView;
-(void) cell:(BLCMediaTableViewCell *)cell didLongPressImageView:(UIImageView*)imageView;

@end
@interface BLCMediaTableViewCell : UITableViewCell
@property (nonatomic, strong) BLCMedia *mediaItem;
@property (nonatomic, weak) id<BLCMediaTableViewCellDelegate> delegate;


+(CGFloat) heightForMediaItem: (BLCMedia *)mediaItem width:(CGFloat)width;

@end
