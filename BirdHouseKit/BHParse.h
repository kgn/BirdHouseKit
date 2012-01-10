//
//  BHParse.h
//  BirdHouseKit
//
//  Created by David Keegan on 1/9/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

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
        if((c == '#' || c == '@') && !uisalnum(uc(s, i-1)) && // #hash or @account
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
