//
//  BHTweet.m
//  BirdHouseKit
//
//  Created by David Keegan on 12/18/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import "BHObject.h"
#import "NSDictionary+KGJSON.h"

@implementation BHObject

@synthesize identifier = _identifier;
@synthesize createdAt = _createdAt;

+ (NSOperationQueue *)operationQueue{
    static NSOperationQueue *operationQueue = nil;
    if(operationQueue == nil){
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return operationQueue;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if((self = [super init])){
        _identifier = [dictionary uintSafelyFromKey:@"id"];
        
        NSString *createdAt = [dictionary stringSafelyFromKey:@"created_at"];
        if(createdAt != nil){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
            _createdAt = [[formatter dateFromString:createdAt] retain];
            [formatter release];
        }else{
            _createdAt = nil;
        }
    }
    return self;
}

- (NSUInteger)hash{
    return self.identifier;
}

- (BOOL)isEqual:(id)object{
    if([object isKindOfClass:[self class]]){
        return (self.identifier == [(BHObject *)object identifier]);
    }
    return NO;
}

- (void)dealloc{
    [_createdAt release];
    [super dealloc];
}

@end
