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

@implementation BMAppDelegate{
    NSArray *_tweets;
}

@synthesize window = _window;
@synthesize tweetTable = _tweetTable;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    BirdHouseKit *birdhouse = [BirdHouseKit kitWithConsumerKey:nil andConsumerSecret:nil];
    
    [[BHTextView sharedActions] setLinkAction:^(NSString *text){
        NSLog(@"link: %@", text);
    }];        
    [[BHTextView sharedActions] setHashAction:^(NSString *text){
        NSLog(@"hash: %@", text);
    }];        
    [[BHTextView sharedActions] setUserAction:^(NSString *text){
        NSLog(@"user: %@", text);
    }];         
    
    [birdhouse requestPublicTimelineWithSuccess:^(NSArray *tweets){
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

- (BMTableCellView *)tableView:(NSTableView *)tableView 
            viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    BMTableCellView *view = [tableView makeViewWithIdentifier:@"TweetCell" owner:self];
    BHTweet *tweet = [_tweets objectAtIndex:row];
    view.textField.stringValue = tweet.user.name;
    [view.textView setTweet:tweet];
    return view;
}


@end
