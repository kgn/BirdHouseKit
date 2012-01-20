//
//  BirdHouseKit.h
//  BirdHouseKit
//
//  Created by David Keegan on 12/28/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHUser.h"
#import "BHTweet.h"
#import "BHStyle.h"
#import "BHTextView.h"
#import "BHBlocks.h"

@interface BirdHouseKit : NSObject

+ (id)kitWithConsumerKey:(NSString *)consumerKey andConsumerSecret:(NSString*)consumerSecret;
- (id)initWithConsumerKey:(NSString *)consumerKey andConsumerSecret:(NSString*)consumerSecret;

- (void)authenticateWithCallbackUrl:(NSURL *)callbackUrl;
- (void)authenticateWithCallbackUrl:(NSURL *)callbackUrl 
                            success:(void (^)())success 
                            failure:(void (^)(NSError *))failure;

- (void)setOAuthToken:(NSString *)oauthToken;

@end

@interface BirdHouseKit(Twitter)

- (void)requestPublicTimelineWithSuccess:(BHTweetsBlock)success andFailure:(BHFailureBlock)failure;
- (void)requestUser:(NSString *)user withSuccess:(void (^)(BHUser *user))success andFailure:(BHFailureBlock)failure;
- (void)requestSearch:(NSString *)search withSuccess:(BHTweetsBlock)success andFailure:(BHFailureBlock)failure;
@end