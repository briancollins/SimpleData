//
//  NSString.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 Brian Collins. All rights reserved.
//



@interface NSString (SimpleData) 

- (BOOL)hasSubstring:(NSString *)substring;
- (NSString *)uncapitalizedString;
- (NSString *)camelizedString;
- (NSString *)after:(NSString *)substring;

@end
