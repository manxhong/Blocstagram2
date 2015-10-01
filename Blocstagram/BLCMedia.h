//
//  BLCMedia.h
//  Blocstagram
//
//  Created by Man Hong Lee on 1/29/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLCMediaDownloadState) {
    BLCMediaDownloadStateNeedsImage             =0,
    BLCMediaDownloadStateDownloadInProgress     =1,
    BLCMediaDownloadStateNonRecoverableError    =2,
    BLCMediaDownloadStateHasImage               =3
};
@class BLCUser;

@interface BLCMedia : NSObject <NSCoding>

-(instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) BLCUser *user;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BLCMediaDownloadState downloadState;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSArray *comments;

@end
