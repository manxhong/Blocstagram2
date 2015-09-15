//
//  BLCComment.m
//  Blocstagram
//
//  Created by Man Hong Lee on 1/29/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import "BLCComment.h"
#import "BLCUser.h" 

@implementation BLCComment

#pragma mark - NSCoding

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.idNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.text = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(text))];
        self.from = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(from))];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
    [aCoder encodeObject:self.text forKey:NSStringFromSelector(@selector(text))];
    [aCoder encodeObject:self.from forKey:NSStringFromSelector(@selector(from))];
}

-(instancetype) initWithDictionary:(NSDictionary *)commentDictionary {
    self = [super init];
    
    if (self) {
        self.idNumber = commentDictionary[@"id"];
        self.text = commentDictionary[@"text"];
        self.from = [[BLCUser alloc] initWithDictionary:commentDictionary[@"from"]];
    }
    
    return self;
}

@end
