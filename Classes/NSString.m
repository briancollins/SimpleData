//
//  NSString.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString.h"


@implementation NSString (SimpleData)

- (NSString *)uncapitalizedString {
	char *s = [self UTF8String];
	char *m = malloc(strlen(s));
	strcpy(m, s);
	m[0] = tolower(m[0]);
	return [NSString stringWithUTF8String:m];
}

@end
