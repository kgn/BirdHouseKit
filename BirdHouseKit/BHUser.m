//
//  BHTweet.m
//  BirdHouseKit
//
//  Created by David Keegan on 12/18/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

// * implemented
// - wont implement
//user =         {
//    "contributors_enabled" = 0;
//*    "created_at" = "Fri May 16 22:36:14 +0000 2008";
//    "default_profile" = 0;
//    "default_profile_image" = 0;
//*    description = "I make stuff.";
//    "favourites_count" = 0;
//    "follow_request_sent" = "<null>";
//    "followers_count" = 3986;
//    following = "<null>";
//    "friends_count" = 226;
//    "geo_enabled" = 0;
//*    id = 14805097;
//-    "id_str" = 14805097;
//    "is_translator" = 0;
//    lang = en;
//    "listed_count" = 342;
//*    location = "Carlsbad, CA";
//*    name = "Drew Wilson";
//    notifications = "<null>";
//-    "profile_background_color" = e6e9e4;
//-    "profile_background_image_url" = "http://a0.twimg.com/profile_background_images/261523023/dw-twitter-bg.jpg";
//-    "profile_background_image_url_https" = "https://si0.twimg.com/profile_background_images/261523023/dw-twitter-bg.jpg";
//-    "profile_background_tile" = 0;
//*    "profile_image_url" = "http://a1.twimg.com/profile_images/1338124160/drew-avatar_normal.jpg";
//    "profile_image_url_https" = "https://si0.twimg.com/profile_images/1338124160/drew-avatar_normal.jpg";
//-    "profile_link_color" = 5ba8a8;
//-    "profile_sidebar_border_color" = ffffff;
//-    "profile_sidebar_fill_color" = e6e9e4;
//-    "profile_text_color" = 69697a;
//-    "profile_use_background_image" = 1;
//    protected = 0;
//*    "screen_name" = drewwilson;
//    "show_all_inline_media" = 0;
//    "statuses_count" = 6674;
//    "time_zone" = "Pacific Time (US & Canada)";
//*    url = "http://www.drewwilson.com";
//    "utc_offset" = "-28800";
//    verified = 0;
//};

#import "BHUser.h"
#import "NSDictionary+KGJSON.h"
#import "BirdHouseKit+Private.h"

@interface BHUser()
- (NSURL *)avatarURLForSize:(NSString *)size;
@end

@implementation BHUser

@synthesize url = _url;
@synthesize name = _name;
@synthesize location = _location;
@synthesize screenName = _screenName;
@synthesize about = _about;
@synthesize profileImageUrl = _profileImageUrl;

+ (id)userWithDictionary:(NSDictionary *)dictionary{
    return [[[[self class] alloc] initWithDictionary:dictionary] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if((self = [super initWithDictionary:dictionary])){
        _url = [[dictionary URLSafelyFromKey:@"url"] retain];
        _name = [[dictionary stringSafelyFromKey:@"name"] copy];
        _about = [[dictionary stringSafelyFromKey:@"description"] copy];         
        _location = [[dictionary stringSafelyFromKey:@"location"] copy];
        _screenName = [[dictionary stringSafelyFromKey:@"screen_name"] copy];
        _profileImageUrl = [[dictionary URLSafelyFromKey:@"profile_image_url"] retain];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@ %lu Name='%@' Screen Name='%@' URL=%@>", 
            [self class], self.identifier, self.name, self.screenName, self.url];
}

- (void)dealloc{
    [_url release];
    [_name release];
    [_about release];    
    [_location release];
    [_screenName release];
    [_profileImageUrl release];
    [super dealloc];
}

#pragma avatar

- (NSURL *)avatarURLForSize:(NSString *)size{
    NSDictionary *arguments = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                self.screenName, @"screen_name", size, @"size",nil] autorelease];
    return [BirdHouseKit twitterAPIURLWithPath:@"/1/users/profile_image" andArguments:arguments];
}

- (void)requestAvatarWithSuccess:(BHImageBlock)success andFailure:(BHFailureBlock)failure{
    [BirdHouseKit requestImageWithURL:self.profileImageUrl success:success andFailure:failure];
}

- (void)requestMiniAvatarWithSuccess:(BHImageBlock)success andFailure:(BHFailureBlock)failure{
    [BirdHouseKit requestImageWithURL:[self avatarURLForSize:@"mini"] success:success andFailure:failure];
}

- (void)requestBiggerAvatarWithSuccess:(BHImageBlock)success andFailure:(BHFailureBlock)failure{
    [BirdHouseKit requestImageWithURL:[self avatarURLForSize:@"bigger"] success:success andFailure:failure];   
}

- (void)requestOriginalAvatarWithSuccess:(BHImageBlock)success andFailure:(BHFailureBlock)failure{
    [BirdHouseKit requestImageWithURL:[self avatarURLForSize:@"original"] success:success andFailure:failure];
}

@end
