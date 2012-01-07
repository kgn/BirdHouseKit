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

//TODO: this c solution doesn't work with unicode
//Rewrite with NSScanner
static bool isValidUrlChar(char c){
    if(c=='\0' || isspace(c)){
        return false;
    }
    if(ispunct(c) && c!='.' && c!='?' && c!=':' && c!='/'){
        return false;
    }
    return true;
}

static bool isValidAccountOrHashChar(char c){
    return (c != '\0' && (isalnum(c) || c=='_'));
}

static void styleTweet(NSMutableAttributedString *attributedString, NSDictionary *hashStyle, 
                       NSDictionary *accountStyle, NSDictionary *linkStyle){
    NSString *rawText = [attributedString string];
    const char *t = [rawText UTF8String];
    
    int i = 0;
    char c = t[i];
    while(c != '\0'){
        if(c == '#' || c == '@'){ // #hash or @account
            int start = i;
            while(isValidAccountOrHashChar(t[++i]));
            NSRange range = NSMakeRange(start, i-start);
            NSLog(@"%lu, %lu: %@", range.location, range.length, rawText);
            if(c == '#'){
                [attributedString addAttributes:hashStyle range:range];
            }else{
                [attributedString addAttributes:accountStyle range:range];                
            }
        }else if((c == 'h' && t[i+1] == 't' && t[i+2] == 't' && t[i+3] == 'p' && // http(s)://
                 ((t[i+4] == ':' && t[i+5] == '/' && t[i+6] == '/') ||
                  (t[i+4] == 's' && t[i+5] == ':' && t[i+6] == '/' && t[i+7] == '/'))) || 
                 (c == 'f' && t[i+1] == 't' && t[i+2] == 'p' && // ftp(s)://
                  ((t[i+3] == ':' && t[i+4] == '/' && t[i+5] == '/') ||
                   (t[i+3] == 's' && t[i+4] == ':' && t[i+5] == '/' && t[i+6] == '/')))){
             int start = i;
             while(isValidUrlChar(t[++i]));
             NSRange range = NSMakeRange(start, i-start);
             NSLog(@"%lu, %lu: %@", range.location, range.length, rawText);
             NSString *url = [rawText substringWithRange:range];
             [attributedString addAttributes:linkStyle range:range];
             [attributedString addAttribute:NSLinkAttributeName value:url range:range];
        }
        c = t[++i];
    }
}


@implementation BHTweet

@synthesize user = _user;
@synthesize text = _text;
@synthesize styledText = _styledText;

- (NSAttributedString *)styledText{
    if(_styledText == nil){
        static NSDictionary *defaultStyle = nil;
        if(defaultStyle == nil){
            NSShadow *textShadow = nil;
            textShadow = [[NSShadow alloc] init];
            [textShadow setShadowOffset:NSMakeSize(0.0f, -1.0f)];
            [textShadow setShadowColor:[NSColor colorWithDeviceWhite:1.0f alpha:0.6f]];            
            defaultStyle = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSColor blackColor], NSForegroundColorAttributeName,
                            textShadow, NSShadowAttributeName, nil];
            [textShadow release];
        }
        NSMutableAttributedString *attributedString = 
        [[NSMutableAttributedString alloc] initWithString:self.text 
                                               attributes:defaultStyle];
        
        static NSDictionary *hashStyle = nil;
        if(hashStyle == nil){
            hashStyle = [NSDictionary dictionaryWithObject:[NSColor grayColor] 
                                                    forKey:NSForegroundColorAttributeName];
        }
        
        static NSDictionary *accountStyle = nil;
        if(accountStyle == nil){
            accountStyle = [NSDictionary dictionaryWithObject:[NSColor greenColor] 
                                                       forKey:NSForegroundColorAttributeName];
        }
        
        static NSDictionary *linkStyle = nil;
        if(linkStyle == nil){
            linkStyle = [NSDictionary dictionaryWithObject:[NSColor blueColor] 
                                                    forKey:NSForegroundColorAttributeName];
        }
        
        styleTweet(attributedString, hashStyle, accountStyle, linkStyle);
        
        _styledText = [[NSAttributedString alloc] initWithAttributedString:attributedString];
    }
    return _styledText;
}

+ (id)tweetWithDictionary:(NSDictionary *)dictionary{
    return [[[[self class] alloc] initWithDictionary:dictionary] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if((self = [super initWithDictionary:dictionary])){
        _text = [[[dictionary stringSafelyFromKey:@"text"] 
                  stringByReplacingPercentEscapesUsingEncoding:NSUnicodeStringEncoding] copy];
        
        NSDictionary *user = [dictionary objectSafelyFromKey:@"user"];
        if(user != nil){
            _user = [[BHUser userWithDictionary:user] retain];
        }else{
            _user = nil;
        }
    }
    return self;
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
