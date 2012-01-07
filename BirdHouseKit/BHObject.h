//
//  BHTweet.m
//  BirdHouseKit
//
//  Created by David Keegan on 12/18/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHObject : NSObject

@property (nonatomic, readonly) NSUInteger identifier;
@property (nonatomic, readonly) NSDate *createdAt;

+ (NSOperationQueue *)operationQueue;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
