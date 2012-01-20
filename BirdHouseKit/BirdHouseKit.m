//
//  BirdHouseKit.m
//  BirdHouseKit
//
//  Created by David Keegan on 12/28/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import "BirdHouseKit.h"
#import "AFOAuth1Client.h"
#import "AFImageRequestOperation.h"

@implementation BirdHouseKit{
    NSString *_consumerKey;
    NSString *_consumerSecret;    
    AFOAuth1Token *_accessToken;
    NSString *_oauthToken;
}

+ (id)kitWithConsumerKey:(NSString *)consumerKey andConsumerSecret:(NSString*)consumerSecret{
    return [[[[self class] alloc] initWithConsumerKey:consumerKey andConsumerSecret:consumerSecret] autorelease];
}

- (id)initWithConsumerKey:(NSString *)consumerKey andConsumerSecret:(NSString*)consumerSecret{
    if((self = [super init])){
        _consumerKey = consumerKey;
        _consumerSecret = consumerSecret;
    }
    return self;
}

- (void)authenticateWithCallbackUrl:(NSURL *)callbackUrl{
    [self authenticateWithCallbackUrl:callbackUrl success:nil failure:nil];
}

- (void)authenticateWithCallbackUrl:(NSURL *)callbackUrl success:(void (^)())success failure:(void (^)(NSError *))failure{
    NSURL *oauthBaseUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/"];
    AFOAuth1Client *twitterClient = [[[AFOAuth1Client alloc] initWithBaseURL:oauthBaseUrl 
                                                                         key:_consumerKey secret:_consumerSecret] 
                                     autorelease];
    [twitterClient 
     authorizeUsingOAuthWithRequestTokenPath:@"request_token" 
     userAuthorizationPath:@"authorize" 
     callbackURL:callbackUrl
     accessTokenPath:@"access_token" 
     success:^(AFOAuth1Token *accessToken){
         _accessToken = accessToken;
         if(success){success();}
    } failure:^(NSError *error){
         if(failure){failure(error);}
    }];
}

- (void)setOAuthToken:(NSString *)oauthToken{
    _oauthToken = oauthToken;
}

- (void)dealloc{
    [_consumerKey release];
    [_consumerSecret release];    
    [super dealloc];
}

#pragma private

+ (NSString *)stringWithURLEncoding:(NSString *)input{
    CFStringRef escaped = 
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input, NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                            kCFStringEncodingUnicode);
    return [(NSString *)escaped autorelease];
}

+ (NSString *)urlEncodedArguments:(NSDictionary *)arguments{
    NSMutableArray *argsAndValues = [[NSMutableArray alloc] init];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for(NSString *key in [arguments allKeys]){
        NSString *escapedKey = [[self class] stringWithURLEncoding:key];
        NSString *value = [[self class] stringWithURLEncoding:[arguments objectForKey:key]];
        [argsAndValues addObject:[NSString stringWithFormat:@"%@=%@", escapedKey, value]];
    }
    [pool drain];
    
    NSString *argsAndValuesString = [argsAndValues componentsJoinedByString:@"&"];
    [argsAndValues release];
    
    return argsAndValuesString;
}

+ (void)requestImageWithURL:(NSURL *)url success:(BHImageBlock)success andFailure:(BHFailureBlock)failure{
    [[BHObject operationQueue] addOperation:
     [AFImageRequestOperation 
      imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url]
      imageProcessingBlock:nil cacheName: nil
      success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSImage *image){
          if(success)success(image);
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
          if(failure)failure(error);
      }]];
}

@end
