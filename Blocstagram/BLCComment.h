//
//  BLCComment.h
//  Blocstagram
//
//  Created by Man Hong Lee on 1/29/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLCUser;

@interface BLCComment : NSObject

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) BLCUser *from;
@property (nonatomic, strong) NSString *text;

-(instancetype) initWithDictionary:(NSDictionary *)commentDictionary;

@end
