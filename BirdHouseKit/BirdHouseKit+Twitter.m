//
//  BirdHouseKit+Twitter.m
//  BirdHouseKit
//
//  Created by David Keegan on 1/7/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "BirdHouseKit.h"
#import "AFJSONRequestOperation.h"
#import "NSDictionary+KGJSON.h"

@interface BirdHouseKit()
- (NSString *)stringWithURLEncoding:(NSString *)input;
- (void)requestWithTwitterApiPath:(NSString *)path success:(BHSuccess)success failure:(BHFailure)failure;
@end

@implementation BirdHouseKit(Twitter)

- (NSString *)stringWithURLEncoding:(NSString *)input{
    CFStringRef escaped = 
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input, NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                            kCFStringEncodingUnicode);
    return [(NSString *)escaped autorelease];
}

- (void)requestWithTwitterApiPath:(NSString *)path success:(BHSuccess)success failure:(BHFailure)failure{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com%@", path]];
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

- (void)requestPublicTimelineWithSuccess:(BHSuccess)success andFailure:(BHFailure)failure{
    [self requestWithTwitterApiPath:@"/1/statuses/public_timeline.json" success:^(NSArray *tweets){
        if(success)success(tweets);
    } failure:^(NSError *error){
        if(failure)failure(error);
    }];
}

- (void)requestSearch:(NSString *)search withSuccess:(BHSuccess)success andFailure:(BHFailure)failure{
    search = [self stringWithURLEncoding:search];
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

- (void)requestUser:(NSString *)user withSuccess:(void (^)(BHUser *user))success andFailure:(BHFailure)failure{
    user = [self stringWithURLEncoding:user];
    NSString *path = [NSString stringWithFormat:@"/1/users/show.json?screen_name=%@", user];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com%@", path]];
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

@end
