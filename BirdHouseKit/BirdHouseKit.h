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

typedef void (^BHSuccess)(NSArray *tweets);
typedef void (^BHFailure)(NSError *error);

- (void)requestPublicTimelineWithSuccess:(BHSuccess)success andFailure:(BHFailure)failure;

@end