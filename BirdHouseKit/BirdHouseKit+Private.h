//
//  BirdHouseKit.m
//  BirdHouseKit
//
//  Created by David Keegan on 12/28/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import "BirdHouseKit.h"
#import "AFJSONRequestOperation.h"

@interface BirdHouseKit()
+ (NSString *)stringWithURLEncoding:(NSString *)input;
+ (NSString *)urlEncodedArguments:(NSDictionary *)arguments;

+ (NSURL *)twitterAPIURLWithPath:(NSString *)path;
+ (NSURL *)twitterAPIURLWithPath:(NSString *)path andArguments:(NSDictionary *)arguments;

+ (void)requestImageWithURL:(NSURL *)url success:(BHImageBlock)success andFailure:(BHFailureBlock)failure;
- (void)requestWithTwitterApiPath:(NSString *)path success:(BHTweetsBlock)success failure:(BHFailureBlock)failure;
@end
