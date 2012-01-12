//
//  BMAppDelegate.h
//  BirdHouseKitTest
//
//  Created by David Keegan on 1/12/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BMAppDelegate : NSObject 
<NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (strong, nonatomic) IBOutlet NSWindow *window;
@property (strong, nonatomic) IBOutlet NSTableView *tweetTable;

@end
