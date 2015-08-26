//
//  BLCDataSource.h
//  Blocstagram
//
//  Created by Man Hong Lee on 1/29/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BLCMedia;

typedef void (^BLCNewItemCompletionBlcok)(NSError *error);
@interface BLCDataSource : NSObject

+(instancetype) sharedInstance;
@property (nonatomic, strong, readonly) NSArray *mediaItems;

-(void) deleteMediaItem:(BLCMedia *)item;

-(void) requestNewItemWithCompletionHandler:(BLCNewItemCompletionBlcok)completionHandler;

-(void) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlcok)completionHandler;
@end
