//
//  BHStyle.h
//  BirdHouseKit
//
//  Created by David Keegan on 1/8/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHStyle : NSObject

@property (retain) NSDictionary *timelineDefaultStyle;
@property (retain) NSDictionary *timelineHashStyle;
@property (retain) NSDictionary *timelineAccountStyle;
@property (retain) NSDictionary *timelineLinkStyle;

+ (id)sharedStyle;

@end
