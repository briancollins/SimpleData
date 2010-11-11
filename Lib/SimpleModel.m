//
//  SimpleModel.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "SimpleModel.h"
#import "SimpleStore.h"
#import "NSString.h"
#import "NSMutableArray.h"

#define LOTS_OF_ARGS "@^v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

@implementation NilObject

+ (id)sharedInstance {
	static NilObject *sharedNilObject = nil;
	if (!sharedNilObject) {
		sharedNilObject = [[self alloc] init];
	}
	return sharedNilObject;
}

@end


@implementation NSManagedObject (SimpleModel)


+ (NSArray *)findAll {
	return [self findWithPredicate: [NSPredicate predicateWithFormat:@"1 = 1"]
							 limit: 0];
}

- (BOOL)save {
	return [[SimpleStore currentStore] save];
}


+ (id)createWithAttributes:(NSDictionary *)attributes {
	id obj = [[self alloc] initWithEntity:[self entity] 
		   insertIntoManagedObjectContext:[[SimpleStore currentStore] managedObjectContext]];
	for (NSString *attr in attributes) {
		[obj setValue:[attributes objectForKey:attr] forKey:attr];
	}
	[obj save];
	return [obj autorelease];
}


+ (id)find:(id)obj inColumn:(NSString *)col {
	NSArray *result = [self findWithPredicate:[NSPredicate predicateWithFormat:
											   [NSString stringWithFormat:@"%@ = %%@", col], obj]
										limit:1];
	if (result && [result count] > 0) {
		return [result objectAtIndex:0];
	} else {
		return nil;
	}
}


+ (id)findWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit {
	return [self findWithPredicate:predicate limit:limit sortBy:nil];
}



+ (id)findWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit sortBy:(NSMutableArray *)sortDescriptors {
	NSManagedObjectContext *moc = [[SimpleStore currentStore] managedObjectContext];
	NSEntityDescription *entityDescription = [self entity];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	request.sortDescriptors = sortDescriptors;
	
	[request setEntity:entityDescription];
	
	if (limit)
		request.fetchLimit = limit;
	
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	return array;
}


+ (NSArray *)forwardedMethods {
	return [NSArray arrayWithObjects:@"findBy", @"findAllBy", @"createWith",
			@"findOrCreateWith", nil];
}


+ (NSString *)willForward:(SEL)selector {
	NSString *sel = NSStringFromSelector(selector);
	for (NSString *key in [self forwardedMethods]) {
		if ([sel hasPrefix:key])
			return key;
	}
	return nil;
}


+ (NSMutableArray *)attributesForInvocation:(NSInvocation *)invocation withSelectorString:(NSString *)sel {
	NSArray *chunks = [[[NSStringFromSelector(invocation.selector) after:sel] uncapitalizedString] 
					   componentsSeparatedByString: @":"];
	NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:5];
	int i = 2;
	for (NSString *chunk in chunks) {
		if (![chunk isEqualToString:@""]) {
			id arg;
			[invocation getArgument:&arg atIndex:i++];
			if (!arg)
				arg = [NilObject sharedInstance];
			[attributes addObject:chunk];
			[attributes addObject:arg];
		}
	}
	return attributes;
}


+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
	if ([self respondsToSelector:selector]) 
		return [super methodSignatureForSelector:selector];
	else if ([self willForward:selector]) 
		return [NSMethodSignature signatureWithObjCTypes:LOTS_OF_ARGS];
	else
		return nil;
}


+ (void)forwardInvocation:(NSInvocation *)invocation {
	NSString *sel;
	if ((sel = [self willForward:invocation.selector])) {
		NSArray *attrs = [self attributesForInvocation:invocation withSelectorString:sel];
		[invocation setArgument:&attrs atIndex:2];
		[invocation setSelector:NSSelectorFromString([NSString stringWithFormat:@"_%@:", sel])];
		[invocation invokeWithTarget:self];
	}
}


+ (id)_createWith:(NSMutableArray *)attributes {
	id obj = [[self alloc] initWithEntity:[self entity]
		   insertIntoManagedObjectContext:[[SimpleStore currentStore] managedObjectContext]];
	while ([attributes count] > 0) {
		NSString *key = [attributes shift];
		[obj setValue:[attributes shift] forKey:key];
	}
	return [obj autorelease];	
}


+ (id)_findBy:(NSMutableArray *)attributes {
	return [self find:[attributes objectAtIndex:1] inColumn:[attributes objectAtIndex:0]];
}


+ (NSMutableArray *)sortDescriptorsFromAttributes:(NSMutableArray *)attributes {
	NSMutableArray *sortDescriptors = [NSMutableArray arrayWithCapacity:2];
	
	while ([attributes count] > 0) {
		NSString *sortBy = [attributes shift];
		
		if ([sortBy isEqualToString:@"sortByDescending"]) {
			[sortDescriptors addObject:[[[NSSortDescriptor alloc] initWithKey:[attributes shift] ascending:NO] autorelease]];
		} else if ([sortBy isEqualToString:@"sortBy"]) {
			[sortDescriptors addObject:[[[NSSortDescriptor alloc] initWithKey:[attributes shift] ascending:YES] autorelease]];
		} else { 
			@throw([NSException exceptionWithName:@"Unexpected Argument" reason:@"Bad sort descriptor" userInfo:nil]);
		}
	}
	
	return [sortDescriptors count] == 0 ? nil : sortDescriptors;
}


+ (id)_findAllBy:(NSMutableArray *)attributes {
	NSString *col = [attributes shift];
	id val = [attributes shift];
	
	return [self findWithPredicate:[NSPredicate predicateWithFormat:
									[NSString stringWithFormat:@"%@ = %%@", col], val]
							 limit:0
							sortBy:[self sortDescriptorsFromAttributes:attributes]];
}

+ (id)_findOrCreateWith:(NSMutableArray *)attributes {
	id obj;
	if ((obj = [self find:[attributes objectAtIndex:1] inColumn:[attributes objectAtIndex:0]])) 
		return obj;
	else 
		return [self _createWith:attributes];
}

+ (NSEntityDescription *)entity {
	Class c = self, p = self;
	while (c && c != [NSManagedObject class]) {
		p = c;
		c = [c superclass];
	}
	
	if (!c) return nil;
	return [NSEntityDescription entityForName:[p description] inManagedObjectContext:[[SimpleStore currentStore] managedObjectContext]];
}

@end
