//
//  BLCMediaTableViewCell.h
//  Blocstagram
//
//  Created by Man Hong Lee on 2/2/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCMedia;
@interface BLCMediaTableViewCell : UITableViewCell
@property (nonatomic, strong) BLCMedia *mediaItem;

+(CGFloat) heightForMediaItem: (BLCMedia *)mediaItem width:(CGFloat)width;
//@property (nonatomic, strong) UIImageView *mediaImageView;
//@property (nonatomic, strong) UILabel *usernameAndCaptionLabel;
//@property (nonatomic, strong) UILabel * commentLabel;

//New comment from mentor
@end
