//
//  BHTextView.m
//  BirdHouseKit
//
//  Created by David Keegan on 1/10/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "BHTextView.h"
#import "BHStyle.h"

@interface BHTextViewActions()
- (BHTextViewAction)linkAction;
- (BHTextViewAction)hashAction;
- (BHTextViewAction)userAction;
@end

@implementation BHTextViewActions{
    BHTextViewAction _linkAction;
    BHTextViewAction _hashAction;
    BHTextViewAction _userAction;    
}

- (BHTextViewAction)linkAction{
    return _linkAction;
}
- (void)setLinkAction:(BHTextViewAction)action{
    Block_release(_linkAction);
    _linkAction = Block_copy(action);
}

- (BHTextViewAction)hashAction{
    return _hashAction;
}
- (void)setHashAction:(BHTextViewAction)action{
    Block_release(_hashAction);
    _hashAction = Block_copy(action);    
}

- (BHTextViewAction)userAction{
    return _userAction;
}
- (void)setUserAction:(BHTextViewAction)action{
    Block_release(_userAction);
    _userAction = Block_copy(action);
}

- (void)dealloc{
    Block_release(_linkAction);
    Block_release(_hashAction);
    Block_release(_userAction);
    [super dealloc];
}

@end

@implementation BHTextView

- (void)setup{
    [self setBackgroundColor:[NSColor clearColor]];
    [self setTextContainerInset:NSZeroSize];
    [self setEditable:NO];
    [self setSelectable:YES];
}

// TIP: subclass NSView in Interface Builder so the scrollbars arn't created
- (id)initWithCoder:(NSCoder *)coder{
    if((self = [super initWithCoder:coder])){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame{ 
    if((self = [super initWithFrame:frame])){
        [self setup];
    }
    return self;
}

- (void)setTweet:(BHTweet *)tweet{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(tweet.styledText){
            [[self textStorage] setAttributedString:tweet.styledText];
        }else{
            //TODO: there's got to be an easier way...
            [[self textStorage] setAttributedString:
             [[[NSAttributedString alloc] initWithString:@""] autorelease]];
        }
    });
}

- (void)mouseDown:(NSEvent *)theEvent{
    BOOL passThroughMouseDown = YES;
	NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSInteger charIndex = [self characterIndexForInsertionAtPoint:point];
	if(charIndex < [[self string] length]){
		NSDictionary *attributes = [[self attributedString] attributesAtIndex:charIndex effectiveRange:NULL];
		if([attributes objectForKey:BHLinkAttributeName] != nil){
            BHTextViewAction linkAction = [[BHTextView sharedActions] linkAction];
			if(linkAction)linkAction([attributes objectForKey:BHLinkAttributeName]);
            passThroughMouseDown = NO;
		}else if([attributes objectForKey:BHHashAttributeName] != nil){
            BHTextViewAction hashAction = [[BHTextView sharedActions] hashAction];
			if(hashAction)hashAction([attributes objectForKey:BHHashAttributeName]);
            passThroughMouseDown = NO;
		}else if([attributes objectForKey:BHUserAttributeName] != nil){
            BHTextViewAction userAction = [[BHTextView sharedActions] userAction];
			if(userAction)userAction([attributes objectForKey:BHUserAttributeName]);
            passThroughMouseDown = NO;
        }
	}
	if(passThroughMouseDown){
        [[self superview] mouseDown:theEvent];
    }
    
//	[super mouseDown:theEvent];
}

//- (NSView *)hitTest:(NSPoint)aPoint{
////	NSPoint point = [self convertPoint:aPoint fromView:nil];
//	NSInteger charIndex = [self characterIndexForInsertionAtPoint:aPoint];
//    if(charIndex < [[self string] length]){
//        NSLog(@"in range");
//        return self;
//    }
//    return nil;
//}

+ (BHTextViewActions *)sharedActions{
    static BHTextViewActions *sharedActions = nil;
    if(sharedActions == nil){
        sharedActions = [[BHTextViewActions alloc] init];
    }
    return sharedActions;
}

@end
