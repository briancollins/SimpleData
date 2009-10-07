//
//  NSString.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "NSString.h"


@implementation NSString (SimpleData)

// This is not the same as lowercaseString, it only downcases the first character
- (NSString *)uncapitalizedString {
	const char *s = [self UTF8String];
	char *m = malloc(strlen(s) + 1);
	strcpy(m, s);
	m[0] = tolower(m[0]);
	NSString *result = [NSString stringWithUTF8String:m];
	free(m);
	return result;
}

- (NSString *)camelizedString {
	const char *s = [self UTF8String];
	char *m = malloc(strlen(s) + 1);
	strcpy(m, s);
	m[0] = toupper(m[0]);
	NSString *result = [NSString stringWithUTF8String:m];
	free(m);
	return result;
}

- (BOOL)hasSubstring:(NSString *)substring {
	return [self rangeOfString:substring].location != NSNotFound;
}

- (NSString *)after:(NSString *)substring {
	NSRange r = [self rangeOfString:substring];
	if (r.location == NSNotFound)
		return @"";
	else
		return [self substringFromIndex:r.location + r.length];
}

@end
