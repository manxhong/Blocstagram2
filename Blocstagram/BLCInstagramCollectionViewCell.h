//
//  BLCInstagramCollectionViewCell.h
//  Blocstagram
//
//  Created by Man Hong Lee on 11/4/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCInstagramCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat thumbnailSize;

@end
