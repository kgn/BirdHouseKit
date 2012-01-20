//
//  BirdHouseKit+Twitter.m
//  BirdHouseKit
//
//  Created by David Keegan on 1/7/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "BirdHouseKit+Private.h"
#import "NSDictionary+KGJSON.h"

@implementation BirdHouseKit(Twitter)

- (void)requestPublicTimelineWithSuccess:(BHTweetsBlock)success andFailure:(BHFailureBlock)failure{
    [self requestWithTwitterApiPath:@"/1/statuses/public_timeline.json" success:^(NSArray *tweets){
        if(success)success(tweets);
    } failure:^(NSError *error){
        if(failure)failure(error);
    }];
}

- (void)requestSearch:(NSString *)search withSuccess:(BHTweetsBlock)success andFailure:(BHFailureBlock)failure{
    search = [[self class] stringWithURLEncoding:search];
    NSString *urlString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", search];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [[BHObject operationQueue] addOperation:
     [AFJSONRequestOperation 
      JSONRequestOperationWithRequest:request 
      success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json){
          NSArray *results = [json objectSafelyFromKey:@"results"];
          NSMutableArray *tweets = [NSMutableArray arrayWithCapacity:[results count]];
          @autoreleasepool{
              for(NSDictionary *dictionary in results){
                  [tweets addObject:[BHTweet tweetWithDictionary:dictionary]];
              }
          }
          if(success)success([NSArray arrayWithArray:tweets]);
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
          if(failure)failure(error);
      }]];
}

- (void)requestUser:(NSString *)user withSuccess:(void (^)(BHUser *user))success andFailure:(BHFailureBlock)failure{
    NSURL *url = [[self class] twitterAPIURLWithPath:@"/1/users/show.json" 
                                        andArguments:[NSDictionary dictionaryWithObject:user 
                                                                                 forKey:@"screen_name"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[BHObject operationQueue] addOperation:
     [AFJSONRequestOperation 
      JSONRequestOperationWithRequest:request 
      success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json){
          if(success)success([BHUser userWithDictionary:json]);
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
          if(failure)failure(error);
      }]];
}

#pragma private

+ (NSURL *)twitterAPIURLWithPath:(NSString *)path{
    return [[self class] twitterAPIURLWithPath:path andArguments:nil];
}

+ (NSURL *)twitterAPIURLWithPath:(NSString *)path andArguments:(NSDictionary *)arguments{
    NSString *encodedArguments = [[self class] urlEncodedArguments:arguments];
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com%@?%@", path, encodedArguments]];
}

- (void)requestWithTwitterApiPath:(NSString *)path success:(BHTweetsBlock)success failure:(BHFailureBlock)failure{
    NSURL *url = [[self class] twitterAPIURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[BHObject operationQueue] addOperation:
     [AFJSONRequestOperation 
      JSONRequestOperationWithRequest:request 
      success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSArray *json){
          NSMutableArray *tweets = [NSMutableArray arrayWithCapacity:[json count]];
          @autoreleasepool{
              for(NSDictionary *dictionary in json){
                  [tweets addObject:[BHTweet tweetWithDictionary:dictionary]];
              }
          }
          if(success)success([NSArray arrayWithArray:tweets]);
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
          if(failure)failure(error);
      }]];
}

@end
