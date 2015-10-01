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
#import <UICKeyChainStore.h>
#import <AFNetworking/AFNetworking.h>


@interface BLCDataSource (){
    NSMutableArray *_mediaItems;
}

@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSArray *mediaItems;

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, assign) BOOL isLoadingOlderItems;

@property (nonatomic, assign) BOOL thereAreNoMoreOlderMessages;

@property (nonatomic, strong) AFHTTPRequestOperationManager *instagramOperationManager;

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
        
        NSMutableDictionary *mutableParameters = [@{@"access_token": self.accessToken} mutableCopy];
        
        [mutableParameters addEntriesFromDictionary:parameters];
        
        [self.instagramOperationManager GET:@"users/self/feed" parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self parseDataFromFeedDictionary:responseObject fromRequestWithParameters:parameters];
                
                if (completionHandler) {
                    completionHandler(nil);
                }
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            if (completionHandler) {
                completionHandler(error);
            }
        }];

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
    
    if (tmpMediaItems.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUInteger numberOfItemToSave = MIN(self.mediaItems.count, 50);
            NSArray *mediaItemToSave = [self.mediaItems subarrayWithRange:NSMakeRange(0, numberOfItemToSave)];
            
            NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(mediaItems))];
            NSData *mediaItemData = [NSKeyedArchiver archivedDataWithRootObject:mediaItemToSave];
            
            NSError *dataError;
            BOOL wroteSuccessfully = [mediaItemData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
            
            if (!wroteSuccessfully) {
                NSLog(@"Couldn't write file: %@", dataError);
            }
        });
    }
}

- (void) downloadImageForMediaItem:(BLCMedia *)mediaItem {
    if (mediaItem.mediaURL && !mediaItem.image) {
        [self.instagramOperationManager GET:mediaItem.mediaURL.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[UIImage class]]) {
                mediaItem.image = responseObject;
                NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
                NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
                [mutableArrayWithKVO replaceObjectAtIndex:index withObject:mediaItem];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error downloading image: %@", error);
        }];
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
        NSURL *baseURL = [NSURL URLWithString:@"https://api.instagram.com/v1/"];
        self.instagramOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        
        AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
        
        AFImageResponseSerializer *imageSerializer = [AFImageResponseSerializer serializer];
        imageSerializer.imageScale = 1.0;
        
        AFCompoundResponseSerializer *serializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[jsonSerializer, imageSerializer]];
        self.instagramOperationManager.responseSerializer = serializer;
        self.accessToken = [UICKeyChainStore stringForKey:@"access token"];
    
        if (!self.accessToken) {
            [self registerForAccessTokenNotification];
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(mediaItems))];
                NSArray *storedMediaItems = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (storedMediaItems.count > 0) {
                        NSMutableArray *mutableMediaItems =[storedMediaItems mutableCopy];
                        
                        [self willChangeValueForKey:@"mediaItems"];
                        self.mediaItems = mutableMediaItems;
                        [self didChangeValueForKey:@"mediaItems"];
                    } else{
                        [self populateDataWithParameters:nil completionHandler:nil];
                    }
                });
            });

        }
    }
    
    return self;
}

-(void) registerForAccessTokenNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:BLCLoginViewControllerDidGetAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note){
        self.accessToken = note.object;
        [UICKeyChainStore setString:self.accessToken forKey:@"access token"];
        [self populateDataWithParameters:nil completionHandler:nil];
    }];
}


-(void) deleteMediaItem:(BLCMedia *)item{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    [mutableArrayWithKVO removeObject:item];
}

- (NSString *) pathForFilename:(NSString *) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingString:filename];
    return dataPath;
}

@end

