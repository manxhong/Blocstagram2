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

extern NSString *const BLCImageFinishedNotification;

+(NSString *) instagramClientID;
+(instancetype) sharedInstance;
@property (nonatomic, strong, readonly) NSArray *mediaItems;
@property (nonatomic, strong, readonly) NSString *accessToken;

-(void) deleteMediaItem:(BLCMedia *)item;

-(void) requestNewItemWithCompletionHandler:(BLCNewItemCompletionBlcok)completionHandler;

-(void) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlcok)completionHandler;
-(void) downloadImageForMediaItem: (BLCMedia *)mediaItem;

-(void) toggleLikeOnMediaItem: (BLCMedia *)mediaItem;

-(void) commentOnMediaItem: (BLCMedia *)mediaItem withCommentText:(NSString *)commentText;
@end
