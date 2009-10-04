//
//  SimpleModel.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleModel.h"


@implementation SimpleModel

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	if ([self respondsToSelector:selector]) {
		return [super methodSignatureForSelector:selector];
	} else {
		if ([NSStringFromSelector(selector)	rangeOfString:@"findBy"].location == 0) {
			return [super methodSignatureForSelector:@selector(find: inColumn:)];
		} else {
			return [super methodSignatureForSelector:selector];
		}
	}	
}

+ (NSArray *)findAll {
	
}

+ (id)find:(id)obj inColumn:(NSString *)col {

}

+ (void)forwardInvocation:(NSInvocation *)invocation {
	NSString *selector = NSStringFromSelector(invocation.selector);
	
	if ([selector rangeOfString:@"findBy"].location == 0) {
		NSString *column = [selector stringByReplacingCharactersInRange:NSMakeRange(0, 6) withString:@""];
		[invocation setSelector:@selector(find:inColumn:)];
		[invocation setArgument:&column atIndex:3];
		[invocation invokeWithTarget:self];
	}
}

@end
