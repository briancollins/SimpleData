//
//  NSMutableArray.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-06.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "NSMutableArray.h"


@implementation NSMutableArray (SimpleData)

// remove and return first element
- (id)shift {
	id obj = [self objectAtIndex:0];
	[self removeObjectAtIndex:0];
	return obj;
}

@end
