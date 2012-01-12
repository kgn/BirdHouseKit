//
//  BMTableCellView.h
//  BirdHouseKitTest
//
//  Created by David Keegan on 1/12/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <BirdHouseKit/BirdHouseKit.h>

@interface BMTableCellView : NSTableCellView

@property (strong, nonatomic) IBOutlet BHTextView *textView;

@end
