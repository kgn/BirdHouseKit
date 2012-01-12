//
//  BHStyle.m
//  BirdHouseKit
//
//  Created by David Keegan on 1/8/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "BHStyle.h"

@implementation BHStyle

@synthesize timelineDefaultStyle = _timelineDefaultStyle;
@synthesize timelineHashStyle = _timelineHashStyle;
@synthesize timelineUserStyle = _timelineUserStyle;
@synthesize timelineLinkStyle = _timelineLinkStyle;

+ (BHStyle *)sharedStyle{
    static BHStyle *sharedStyle = nil;
    if(sharedStyle == nil){
        sharedStyle = [[BHStyle alloc] init];
    }
    return sharedStyle;
}

- (id)init {
    if((self = [super init])){
        self.timelineDefaultStyle = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                     [NSColor blackColor], NSForegroundColorAttributeName,
                                      nil] autorelease];
        self.timelineHashStyle = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSColor grayColor], NSForegroundColorAttributeName,
                                   [NSCursor pointingHandCursor], NSCursorAttributeName,
                                   nil] autorelease];
        self.timelineUserStyle = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSColor redColor], NSForegroundColorAttributeName,
                                   [NSCursor pointingHandCursor], NSCursorAttributeName,
                                   nil] autorelease];
        self.timelineLinkStyle = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSColor blueColor], NSForegroundColorAttributeName,
                                   [NSCursor pointingHandCursor], NSCursorAttributeName,
                                   nil] autorelease];
    }
    return self;
}

- (void)dealloc{
    [_timelineDefaultStyle release];
    [_timelineHashStyle release];
    [_timelineUserStyle release];
    [_timelineLinkStyle release];
    [super dealloc];
}

@end
