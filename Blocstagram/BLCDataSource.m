//
//  BLCDataSource.m
//  Blocstagram
//
//  Created by Man Hong Lee on 1/29/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import "BLCDataSource.h"
#import "BLCUser.h"
#import "BLCMedia.h"
#import "BLCComment.h"
#import "BLCLoginViewController.h"

@interface BLCDataSource (){
    NSMutableArray *_mediaItems;
}

@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSArray *mediaItems;

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, assign) BOOL isLoadingOlderItems;

@property (nonatomic, assign) BOOL thereAreNoMoreOlderMessages;
@end

@implementation BLCDataSource
#pragma - Key/Value Observing

-(void) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlcok)completionHandler {
    if (self.isLoadingOlderItems == NO && self.thereAreNoMoreOlderMessages ==NO) {
        self.isLoadingOlderItems = YES;
        
        NSString *maxID = [[self.mediaItems lastObject] idNumber];
        NSDictionary *parameters = @{@"max_id": maxID};
        
        [self populateDataWithParameters:parameters completionHandler:^(NSError *error) {
            self.isLoadingOlderItems = NO;
            
            if (completionHandler) {
                completionHandler(error);
            }
        }];
    }

    
    
}

-(void) populateDataWithParameters:(NSDictionary *)parameters completionHandler:(BLCNewItemCompletionBlcok)completionHandler{
    if (self.accessToken) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://api.instagram.com/v1/users/self/feed?access_token=%@", self.accessToken];
            
            for (NSString *parameterName in parameters) {
                
                [urlString appendFormat:@"&%@=%@", parameterName, parameters[parameterName]];
            }
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            if (url) {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                NSURLResponse *response;
                NSError *webError;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&webError];
                
                if (responseData) {
                    NSError *jsonError;
                    NSDictionary *feedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
                    
                    if (feedDictionary) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self parseDataFromFeedDictionary:feedDictionary fromRequestWithParameters:parameters];
                            if (completionHandler) {
                                completionHandler(nil);
                            }
                        });
                    } else if (completionHandler) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler (jsonError);
                        });
                    }
                } else if (completionHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(webError);
                    });
                }
            }
        });
    }
}

-(void) parseDataFromFeedDictionary:(NSDictionary *) feedDictionary fromRequestWithParameters: (NSDictionary *)parameters {
    NSArray *mediaArray = feedDictionary[@"data"];
    
    NSMutableArray *tmpMediaItems = [NSMutableArray array];
    
    for (NSDictionary *mediaDictionary in mediaArray) {
        BLCMedia *mediaItem = [[BLCMedia alloc] initWithDictionary:mediaDictionary];
        
        if (mediaItem) {
            [tmpMediaItems addObject:mediaItem];
            [self downloadImageForMediaItem:mediaItem];
        }
    }
    
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    
    if (parameters[@"min_id"]) {
        NSRange rangeOfIndexes = NSMakeRange(0, tmpMediaItems.count);
        NSIndexSet *indexSetOfNewObjects = [NSIndexSet indexSetWithIndexesInRange:rangeOfIndexes];
        
        [mutableArrayWithKVO insertObjects:tmpMediaItems atIndexes:indexSetOfNewObjects];
    } else if (parameters[@"max_id"]){
        
        if (tmpMediaItems.count == 0) {
            self.thereAreNoMoreOlderMessages = YES;
        }
        [mutableArrayWithKVO addObjectsFromArray:tmpMediaItems];
    } else{
        [self willChangeValueForKey:@"mediaItems"];
        self.mediaItems = tmpMediaItems;
        [self didChangeValueForKey:@"mediaItmes"];
    }
}

- (void) downloadImageForMediaItem:(BLCMedia *)mediaItem {
    if (mediaItem.mediaURL && !mediaItem.image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:mediaItem.mediaURL];
            
            NSURLResponse *response;
            NSError *error;
            NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (image) {
                    mediaItem.image = image;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
                        NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
                        [mutableArrayWithKVO replaceObjectAtIndex:index withObject:mediaItem];
                    });
                }
            } else {
                NSLog(@"Error downloading image: %@", error);
            }
        });
    }
}


+(NSString *) instagramClientID{
    return @"4b9d4f57194c40d5817d03b996d0ffee";
}

-(void) requestNewItemWithCompletionHandler:(BLCNewItemCompletionBlcok)completionHandler{
    self.thereAreNoMoreOlderMessages = NO;
    
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
        
        NSString *minID = [[self.mediaItems firstObject] idNumber];
        NSDictionary *parameters = nil;
        if (self.mediaItems.count) {
            parameters = @{@"min_id": minID};
        }
        
        [self populateDataWithParameters:parameters completionHandler:^(NSError *error){
            self.isRefreshing = NO;
            
            if (completionHandler) {
                completionHandler (error);
            }
        }];
    }
}

-(NSUInteger) countOfMediaItems{
    return self.mediaItems.count;
}

-(id) objectInMediaItemsAtIndex:(NSUInteger)index{
    return [self.mediaItems objectAtIndex:index];
}

-(NSArray *) mediaItemsAtIndexes:(NSIndexSet *)indexes {
    return [self.mediaItems objectsAtIndexes:indexes];
}

-(void) insertObject:(BLCMedia *)object inMediaItemsAtIndex:(NSUInteger)index{
    [_mediaItems insertObject:object atIndex:index];
}

-(void) removeObjectFromMediaItemsAtIndex:(NSUInteger)index{
    [_mediaItems removeObjectAtIndex:index];
}

-(void) replaceObjectInMediaItemsAtIndex:(NSUInteger)index withObject:(id)object{
    [_mediaItems replaceObjectAtIndex:index withObject:object];
}

+(instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

-(instancetype) init {
    self = [super init];
    
    if (self) {
        //[self addRandomData];
        [self registerForAccessTokenNotification];
    }
    
    return self;
}

-(void) registerForAccessTokenNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:BLCLoginViewControllerDidGetAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note){
        self.accessToken = note.object;
        
        [self populateDataWithParameters:nil completionHandler:nil];
    }];
}


-(void) deleteMediaItem:(BLCMedia *)item{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    [mutableArrayWithKVO removeObject:item];
}

@end

