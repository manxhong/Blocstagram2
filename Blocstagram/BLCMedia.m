//
//  BLCMedia.m
//  Blocstagram
//
//  Created by Man Hong Lee on 1/29/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import "BLCUser.h"
#import "BLCMedia.h"
#import "BLCComment.h"


@implementation BLCMedia

-(instancetype) initWithDictionary:(NSDictionary *)mediaDictionary {
    self = [super init];
    
    if (self) {
        self.idNumber = mediaDictionary[@"id"];
        self.user = [[BLCUser alloc] initWithDictionary:mediaDictionary[@"user"]];
        NSString *standardResolutionImageURLString = mediaDictionary[@"images"][@"standard_resolution"][@"url"];
        NSURL *standardResolutionImageURL = [NSURL URLWithString:standardResolutionImageURLString];
        
        if (standardResolutionImageURL) {
            self.mediaURL = standardResolutionImageURL;
        }
        
        NSDictionary *captionDictionary = mediaDictionary[@"caption"];
        
        if ([captionDictionary isKindOfClass:[NSDictionary class]]) {
            self.caption = captionDictionary[@"text"];
        } else{
            self.caption =@"";
        }
        
        NSMutableArray *commentsArray = [NSMutableArray array];
        
        for (NSDictionary *commentDictionary in mediaDictionary[@"comments"][@"data"]) {
            BLCComment *comment =[[BLCComment alloc] initWithDictionary:commentDictionary];
            [commentsArray addObject:comment];
        }
        
        self.comments = commentsArray;
    }
    
    return self;
}

@end
