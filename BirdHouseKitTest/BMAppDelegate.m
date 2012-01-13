//
//  BMAppDelegate.m
//  BirdHouseKitTest
//
//  Created by David Keegan on 1/12/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "BMAppDelegate.h"
#import <BirdHouseKit/BirdHouseKit.h>
#import "BMTableCellView.h"

@interface BMAppDelegate()
- (void)updateTableCellViewHeights;
@end

@implementation BMAppDelegate{
    NSArray *_tweets;
    BirdHouseKit *_birdhouse;    
}

@synthesize window = _window;
@synthesize tweetTable = _tweetTable;

- (void)updateTableCellViewHeights{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_tweets count])];
    [self.tweetTable noteHeightOfRowsWithIndexesChanged:indexSet];
    [NSAnimationContext endGrouping];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(updateTableCellViewHeights) 
     name:NSWindowDidResizeNotification object:self.window];
    
    [[BHTextView sharedActions] setLinkAction:^(NSString *text){
        NSLog(@"link: %@", text);
    }];        
    [[BHTextView sharedActions] setHashAction:^(NSString *text){
        NSLog(@"hash: %@", text);
    }];        
    [[BHTextView sharedActions] setUserAction:^(NSString *text){
        NSLog(@"user: %@", text);
    }];         
    
    _birdhouse = [BirdHouseKit kitWithConsumerKey:nil andConsumerSecret:nil];    
    [self refreshSteam:self];
}

- (IBAction)refreshSteam:(id)sender{
    [_birdhouse requestPublicTimelineWithSuccess:^(NSArray *tweets){
        if(tweets != nil){
            _tweets = tweets;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tweetTable reloadData];
            });
        }        
    } andFailure:^(NSError *error){
        NSLog(@"%@", error);
    }];    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [_tweets count];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    CGFloat width = NSWidth(tableView.frame);
    BHTweet *tweet = [_tweets objectAtIndex:row];
    NSRect textRect = [tweet.styledText
                       boundingRectWithSize:NSMakeSize(width-40.0f, 0.0f) 
                       options:NSStringDrawingUsesLineFragmentOrigin];    
    return NSHeight(textRect)+40.0f;
}

- (BMTableCellView *)tableView:(NSTableView *)tableView 
            viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    BMTableCellView *view = [tableView makeViewWithIdentifier:@"TweetCell" owner:self];
    BHTweet *tweet = [_tweets objectAtIndex:row];
    view.textField.stringValue = tweet.user.name;
    [view.textView setTweet:tweet];
    return view;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
