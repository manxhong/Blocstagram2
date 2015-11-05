//
//  BLCInstagramCollectionViewCell.m
//  Blocstagram
//
//  Created by Man Hong Lee on 11/4/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import "BLCInstagramCollectionViewCell.h"

@implementation BLCInstagramCollectionViewCell
- (void) layoutSubviews {
    [super layoutSubviews];
    
    static NSInteger imageViewTag = 1000;
    static NSInteger labelTag = 1001;
    
    self.thumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.thumbnailSize, self.thumbnailSize)];
    self.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbnail.tag = imageViewTag;
    self.thumbnail.clipsToBounds = YES;
    
    [self.contentView addSubview:self.thumbnail];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.thumbnailSize, self.thumbnailSize, 20)];
    self.label.tag = labelTag;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
    
    [self.contentView addSubview:self.label];
    //
}
@end
