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
@synthesize timelineAccountStyle = _timelineAccountStyle;
@synthesize timelineLinkStyle = _timelineLinkStyle;

+ (id)sharedStyle{
    static BHStyle *sharedStyle = nil;
    if(sharedStyle == nil){
        sharedStyle = [[[self class] alloc] init];
    }
    return sharedStyle;
}

- (id)init {
    if((self = [super init])){
        NSShadow *textShadow = nil;
        textShadow = [[NSShadow alloc] init];
        [textShadow setShadowOffset:NSMakeSize(0.0f, -1.0f)];
        [textShadow setShadowColor:[NSColor colorWithDeviceWhite:1.0f alpha:0.6f]];            
        self.timelineDefaultStyle = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [NSColor blackColor], NSForegroundColorAttributeName,
                                     textShadow, NSShadowAttributeName, nil];
        [textShadow release];
        
        self.timelineHashStyle = [[NSDictionary dictionaryWithObject:[NSColor grayColor] 
                                                              forKey:NSForegroundColorAttributeName] retain];
        self.timelineAccountStyle = [NSDictionary dictionaryWithObject:[NSColor redColor] 
                                                                forKey:NSForegroundColorAttributeName];
        self.timelineLinkStyle = [NSDictionary dictionaryWithObject:[NSColor blueColor] 
                                                             forKey:NSForegroundColorAttributeName];
    }
    return self;
}

- (void)dealloc{
    [_timelineDefaultStyle release];
    [_timelineHashStyle release];
    [_timelineAccountStyle release];
    [_timelineLinkStyle release];
    [super dealloc];
}

@end