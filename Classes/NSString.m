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
	const char *s = [self UTF8String];
	char *m = malloc(strlen(s));
	strcpy(m, s);
	m[0] = tolower(m[0]);
	NSString *result = [NSString stringWithUTF8String:m];
	free(m);
	return result;
}

@end
