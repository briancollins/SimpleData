//
//  SimpleModel.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleModel.h"
#import "SimpleStore.h"

@implementation SimpleModel

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	if ([self respondsToSelector:selector]) {
		return [super methodSignatureForSelector:selector];
	} else {
		if ([NSStringFromSelector(selector)	rangeOfString:@"findBy"].location == 0) 
			return [super methodSignatureForSelector:@selector(find: inColumn:)];
		else if ([NSStringFromSelector(selector) rangeOfString:@"createWith"].location == 0)
			return [super methodSignatureForSelector:@selector(createWithAttributes:a:b:c:d:e:)];			
		else
			return [super methodSignatureForSelector:selector];
	}	
}

+ (NSArray *)findAll {
	return nil;
}


 //FIXME: ugly UGLY method proxying hack, because [invocation getArgument:>2] won't work otherwise
+ (id)createWithAttributes:(NSDictionary *)attributes a:(id)a b:(id)b c:(id)c d:(id)d e:(id)e {
	return [self createWithAttributes:attributes];
}

+ (id)createWithAttributes:(NSDictionary *)attributes {
	id obj = [[self alloc] initWithEntity:[NSEntityDescription entityForName:self.description
													  inManagedObjectContext:[[SimpleStore currentStore] managedObjectContext]] 
		   insertIntoManagedObjectContext:[[SimpleStore currentStore] managedObjectContext]];
	for (NSString *attr in attributes) {
		[obj setValue:[attributes objectForKey:attr] forKey:attr];
	}
	return obj;
}

+ (id)find:(id)obj inColumn:(NSString *)col {
	return nil;
}

+ (void)forwardInvocation:(NSInvocation *)invocation {
	NSString *selector = NSStringFromSelector(invocation.selector);
	
	if ([selector rangeOfString:@"findBy"].location == 0) {
		NSString *column = [selector stringByReplacingCharactersInRange:NSMakeRange(0, 6) withString:@""];
		[invocation setSelector:@selector(find:inColumn:)];
		[invocation setArgument:&column atIndex:3];
		[invocation invokeWithTarget:self];
	} else if ([selector rangeOfString:@"createWith"].location == 0) {
		NSArray *chunks = [[selector stringByReplacingCharactersInRange:NSMakeRange(0, 10) withString:@""] componentsSeparatedByString: @":"];
		NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithCapacity:[chunks count] - 1];
		int i = 2;
		for (NSString *chunk in chunks) {
			if ([chunk length] > 0) {
				id o;
				[invocation getArgument:&o atIndex:i];
				[attributes setObject:o forKey:chunk];
				i++;
			}
			
		}
		
		[invocation setSelector:@selector(createWithAttributes:a:b:c:d:e:)];
		[invocation setArgument:&attributes atIndex:2];
		[invocation invokeWithTarget:self];
	}
}

@end
