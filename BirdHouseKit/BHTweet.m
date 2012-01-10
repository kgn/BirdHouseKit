//
//  BHTweet.m
//  BirdHouseKit
//
//  Created by David Keegan on 12/13/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

// * implemented
// - wont implement
//{
//    contributors = "<null>";
//    coordinates = "<null>";
//*    "created_at" = "Sun Dec 18 01:26:47 +0000 2011";
//    favorited = 0;
//    geo = "<null>";
//*    id = 148212579565715456;
//-    "id_str" = 148212579565715456;
//    "in_reply_to_screen_name" = jbrewer;
//    "in_reply_to_status_id" = 148188556819574784;
//-    "in_reply_to_status_id_str" = 148188556819574784;
//    "in_reply_to_user_id" = 12555;
//-    "in_reply_to_user_id_str" = 12555;
//    place = "<null>";
//    "retweet_count" = 0;
//    retweeted = 0;
//    source = "<a href=\"http://tapbots.com/tweetbot\" rel=\"nofollow\">Tweetbot for iPhone</a>";
//*    text = "@jbrewer lame !!!";
//    truncated = 0;
//*    user = {}
//}

#import "BHTweet.h"
#import "NSDictionary+KGJSON.h"
#import "BHStyle.h"

static bool uisalnum(unichar c){
    return [[NSCharacterSet alphanumericCharacterSet] characterIsMember:c];
}

static bool uispunct(unichar c){
    return [[NSCharacterSet punctuationCharacterSet] characterIsMember:c];
}

static bool uisspace(unichar c){
    return [[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:c];
}

static unichar uc(NSString *string, NSUInteger charIndex){
    if(charIndex < [string length]){
        return [string characterAtIndex:charIndex];
    }
    return '\0';
}

static bool isValidUrlChar(unichar c){
    if(c=='\0' || uisspace(c)){
        return false;
    }
    if(uispunct(c) && c!='.' && c!='?' && c!=':' && c!='/'){
        return false;
    }
    return true;
}

static bool isValidAccountOrHashChar(unichar c){
    return (c != '\0' && (uisalnum(c) || c=='_'));
}

static void styleTweet(NSMutableAttributedString *attributedString){
    NSString *s = [attributedString string];
    
    NSUInteger i = 0;
    unichar c = uc(s, i);
    while(c != '\0'){
        if((c == '#' || c == '@') /*&& isspace(uc(rawText, i-1))*/ && // #hash or @account
           isValidAccountOrHashChar(uc(s, i+1))){
            NSUInteger start = i;
            while(isValidAccountOrHashChar(uc(s, ++i)));
            NSRange range = NSMakeRange(start, i-start);
            if(c == '#'){
                [attributedString addAttributes:[[BHStyle sharedStyle] timelineHashStyle] range:range];
            }else{
                [attributedString addAttributes:[[BHStyle sharedStyle] timelineAccountStyle] range:range];
            }
        }else if((c == 'h' && uc(s, i+1) == 't' && uc(s, i+2) == 't' && uc(s, i+3) == 'p' && // http(s)://
                 ((uc(s, i+4) == ':' && uc(s, i+5) == '/' && uc(s, i+6) == '/') ||
                  (uc(s, i+4) == 's' && uc(s, i+5) == ':' && uc(s, i+6) == '/' && uc(s, i+7) == '/'))) || 
                 (c == 'f' && uc(s, i+1) == 't' && uc(s, i+2) == 'p' && // ftp(s)://
                  ((uc(s, i+3) == ':' && uc(s, i+4) == '/' && uc(s, i+5) == '/') ||
                   (uc(s, i+3) == 's' && uc(s, i+4) == ':' && uc(s, i+5) == '/' && uc(s, i+6) == '/')))){
            NSUInteger start = i;
            while(isValidUrlChar(uc(s, ++i)));
            NSRange range = NSMakeRange(start, i-start);
            NSString *url = [s substringWithRange:range];
            [attributedString addAttribute:NSLinkAttributeName value:url range:range];                      
            [attributedString addAttributes:[[BHStyle sharedStyle] timelineLinkStyle] range:range];
        }
        c = uc(s, ++i);
    }
}


@implementation BHTweet

@synthesize user = _user;
@synthesize text = _text;
@synthesize styledText = _styledText;

- (NSAttributedString *)styledText{
    if(_styledText == nil){
        if(self.text == nil){
            return nil;
        }
        NSMutableAttributedString *attributedString = 
        [[NSMutableAttributedString alloc] initWithString:self.text 
                                               attributes:[[BHStyle sharedStyle] timelineDefaultStyle]];
        [attributedString beginEditing];
        styleTweet(attributedString);
        [attributedString endEditing];
        
        _styledText = [[NSAttributedString alloc] initWithAttributedString:attributedString];
    }
    return _styledText;
}

+ (id)tweetWithDictionary:(NSDictionary *)dictionary{
    return [[[[self class] alloc] initWithDictionary:dictionary] autorelease];
}

- (NSString *)decodeString:(NSString *)inputString{
    NSString *outputString = [NSString stringWithString:inputString];
    outputString = [outputString stringByReplacingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    outputString = [outputString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    outputString = [outputString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    outputString = [outputString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    outputString = [outputString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    outputString = [outputString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    outputString = [outputString stringByReplacingOccurrencesOfString:@"<3"  withString:@"♥"];
    return outputString;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if((self = [super initWithDictionary:dictionary])){
        _text = [[self decodeString:[dictionary stringSafelyFromKey:@"text"]] copy];
        
        NSDictionary *user = [dictionary objectSafelyFromKey:@"user"];
        if(user != nil){
            _user = [[BHUser userWithDictionary:user] retain];
        }else{
            _user = nil;
        }
    }
    return self;
}

- (NSURL *)tweetUrl{
    NSString *urlString = [NSString stringWithFormat:@"http://twitter.com/%@/status/%lu", 
                           self.user.screenName, self.identifier];
    return [NSURL URLWithString:urlString];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@ %lu Name='%@' Text='%@'>", 
            [self class], self.identifier, self.user.name, self.text];
}

- (void)dealloc{
    [_user release];
    [_text release];    
    [_styledText release];
    [super dealloc];
}

@end
