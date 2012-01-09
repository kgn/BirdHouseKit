//
//  BHTweet.m
//  BirdHouseKit
//
//  Created by David Keegan on 12/13/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BHUser.h"

@interface BHTweet : BHObject

@property (nonatomic, readonly) BHUser *user;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSAttributedString *styledText;

+ (id)tweetWithDictionary:(NSDictionary *)dictionary;

- (NSURL *)tweetUrl;

@end
