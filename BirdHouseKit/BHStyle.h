//
//  BHStyle.h
//  BirdHouseKit
//
//  Created by David Keegan on 1/8/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BHLinkAttributeName @"BHLinkAttributeName"
#define BHHashAttributeName @"BHHashAttributeName"
#define BHUserAttributeName @"BHUserAttributeName"

@interface BHStyle : NSObject

@property (retain) NSDictionary *timelineDefaultStyle;
@property (retain) NSDictionary *timelineHashStyle;
@property (retain) NSDictionary *timelineUserStyle;
@property (retain) NSDictionary *timelineLinkStyle;

+ (BHStyle *)sharedStyle;

@end
