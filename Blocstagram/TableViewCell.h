//
//  UITableViewCell.h
//  Blocstagram
//
//  Created by Man Hong Lee on 2/2/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCMedia;
@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) BLCMedia *mediaItem;

@end
