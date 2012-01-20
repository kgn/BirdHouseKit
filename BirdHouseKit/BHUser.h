//
//  BHTweet.m
//  BirdHouseKit
//
//  Created by David Keegan on 12/18/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BHObject.h"
#import "BHBlocks.h"

@interface BHUser : BHObject

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *screenName;
@property (nonatomic, readonly) NSURL *profileImageUrl;

+ (id)userWithDictionary:(NSDictionary *)dictionary;

typedef void (^BHUserAvatar)(NSImage *image);

- (void)requestAvatarWithSuccess:(BHImageBlock)success andFailure:(BHFailureBlock)failure; // 48x48
- (void)requestMiniAvatarWithSuccess:(BHImageBlock)success andFailure:(BHFailureBlock)failure; // 24x24
- (void)requestBiggerAvatarWithSuccess:(BHImageBlock)success andFailure:(BHFailureBlock)failure; // 73x73
- (void)requestOriginalAvatarWithSuccess:(BHImageBlock)success andFailure:(BHFailureBlock)failure; // original size

@end
