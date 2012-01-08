//
//  BirdHouseKit+Twitter.m
//  BirdHouseKit
//
//  Created by David Keegan on 1/7/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "BirdHouseKit.h"
#import "AFJSONRequestOperation.h"

@interface BirdHouseKit()
- (void)requestWithTwitterApiPath:(NSString *)path success:(BHSuccess)success failure:(BHFailure)failure;
@end

@implementation BirdHouseKit(Twitter)

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

@end
