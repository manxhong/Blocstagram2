//
//  UITableViewCell+BLCMediaTableViewCell.h
//  Blocstagram
//
//  Created by Man Hong Lee on 8/11/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCMedia;
@interface UITableViewCell (BLCMediaTableViewCell)
@property (nonatomic, strong) BLCMedia *mediaItem;
@end
