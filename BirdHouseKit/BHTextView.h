//
//  BHTextView.h
//  BirdHouseKit
//
//  Created by David Keegan on 1/10/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//
//  Basied on Mike Rundle's awesome blog post:
//  http://flyosity.com/mac-os-x/clickable-tweet-links-hashtags-usernames-in-a-custom-nstextview.php
//

#import <AppKit/AppKit.h>
#import "BHTweet.h"

@interface BHTextViewActions : NSObject

typedef void (^BHTextViewAction)(NSString *text);

- (void)setLinkAction:(BHTextViewAction)action;
- (void)setHashAction:(BHTextViewAction)action;
- (void)setUserAction:(BHTextViewAction)action;

@end

@interface BHTextView : NSTextView

- (void)setTweet:(BHTweet *)tweet;

+ (BHTextViewActions *)sharedActions;

@end
