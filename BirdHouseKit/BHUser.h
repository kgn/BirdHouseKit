//
//  BHTweet.m
//  BirdHouseKit
//
//  Created by David Keegan on 12/18/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BHObject.h"

@interface BHUser : BHObject

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *screenName;
@property (nonatomic, readonly) NSURL *profileImageUrl;

+ (id)userWithDictionary:(NSDictionary *)dictionary;

- (void)requestAvatarWithBlock:(void (^)(NSImage *styledAvatar))block;

@end
