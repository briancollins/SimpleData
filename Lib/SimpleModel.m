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

#define LOTS_OF_ARGS "@^v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

@implementation SimpleModel


+ (NSArray *)findAll {
	return [self findWithPredicate: [NSPredicate predicateWithFormat:@"1 = 1"]
							 limit: 0];
}

- (BOOL)save {
	return [[SimpleStore currentStore] save];
}


+ (id)findUsingColumn:(NSString *)col orCreateWithAttributes:(NSDictionary *)attributes {
	NSLog(@"%@ %@", col, [attributes objectForKey:col]);
	id obj;
	if (obj = [self find:[attributes objectForKey:col] inColumn:col])
		return obj;
	else
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
	NSArray *result = [self findWithPredicate: [NSPredicate predicateWithFormat:
												[NSString stringWithFormat:@"%@ = %%@", col], obj]
										limit: 1];
	if (result && [result count] > 0) {
		return [result objectAtIndex:0];
	} else {
		return nil;
	}
	
}

+ (NSArray *)findAll:(id)obj inColumn:(NSString *)col sortBy:(NSString *)sortCol {
	return [self findWithPredicate: [NSPredicate predicateWithFormat:
												[NSString stringWithFormat:@"%@ = %%@", col], obj]
										limit: 0
									   sortBy: sortCol];
}


+ (id)findWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit {
	return [self findWithPredicate:predicate limit:limit sortBy:@""];
}


+ (id)findWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit sortBy:(NSString *)sortCol {
	NSManagedObjectContext *moc = [[SimpleStore currentStore] managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:self.description inManagedObjectContext:moc];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	if ([sortCol length] > 0)
		[request setSortDescriptors:
		 [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:sortCol ascending:YES] autorelease]]];
	
	[request setEntity:entityDescription];
	
	if (limit)
		request.fetchLimit = limit;
	
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	return array;
}


+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	if ([self respondsToSelector:selector]) {
		return [super methodSignatureForSelector:selector];
	} else {
		NSString *sel = NSStringFromSelector(selector);
		if ([sel hasPrefix:@"findBy"]) 
			return [super methodSignatureForSelector:@selector(find: inColumn:)];
		else if ([sel hasPrefix:@"findAllBy"])
			return [super methodSignatureForSelector:@selector(findAll: inColumn: sortBy:)];
		else if ([sel hasPrefix:@"createWith"])
			return [NSMethodSignature signatureWithObjCTypes:LOTS_OF_ARGS];
		else if ([sel hasPrefix:@"findOrCreateWith"])
			return [NSMethodSignature signatureWithObjCTypes:LOTS_OF_ARGS];
		else
			return [super methodSignatureForSelector:selector];
	}	
}


+ (void)forwardInvocation:(NSInvocation *)invocation {
	NSString *sel = NSStringFromSelector(invocation.selector);
	
	if ([sel hasPrefix:@"findBy"]) {
		NSString *column = [sel stringByReplacingCharactersInRange:NSMakeRange(0, 6) withString:@""];
		column = [column stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
		column = [column uncapitalizedString];
		[invocation setSelector:@selector(find: inColumn:)];
		[invocation setArgument:&column atIndex:3];
		[invocation invokeWithTarget:self];
	} else if ([sel hasPrefix:@"findAllBy"]) {
		NSArray *chunks = [[sel stringByReplacingCharactersInRange:NSMakeRange(0, 9) withString:@""] componentsSeparatedByString: @":"];

		if ([[chunks objectAtIndex:1] isEqualToString:@"sortBy"]) {
			NSString *sortBy;
			[invocation getArgument:&sortBy atIndex:3];
			[invocation setArgument:&sortBy atIndex:4];
		} else {
			NSString *empty = @"";
			[invocation setArgument:&empty atIndex:4];
		}
		
		NSString *col = [[chunks objectAtIndex:0] uncapitalizedString];
		[invocation setArgument:&col atIndex:3];
		
		[invocation setSelector:@selector(findAll: inColumn: sortBy:)];
		[invocation invokeWithTarget:self];
	} else if ([sel hasPrefix:@"createWith"]) {
		NSArray *chunks = [[sel stringByReplacingCharactersInRange:NSMakeRange(0, 10) withString:@""] componentsSeparatedByString: @":"];
		NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:[chunks count] - 1];
		int i = 2;
		for (NSString *chunk in chunks) {
			if ([chunk length] > 0) {
				id o;
				[invocation getArgument:&o atIndex:i];
				[attributes setObject:o forKey:[chunk uncapitalizedString]];
				i++;
			}
			
		}
		
		[invocation setSelector:@selector(createWithAttributes:)];
		[invocation setArgument:&attributes atIndex:2];
		[invocation invokeWithTarget:self];
	} else if ([sel hasPrefix:@"findOrCreateWith"]) {
		NSArray *chunks = [[sel stringByReplacingCharactersInRange:NSMakeRange(0, 16) withString:@""] componentsSeparatedByString: @":"];
		NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:[chunks count] - 1];
		int i = 2;
		
		for (NSString *chunk in chunks) {
			if ([chunk length] > 0) {
				id o;
				[invocation getArgument:&o atIndex:i];
				[attributes setObject:o forKey:[chunk uncapitalizedString]];
				i++;
			}
		}
		
		id col = [[chunks objectAtIndex:0] uncapitalizedString];
		[invocation setArgument:&col atIndex:2];
		
		
		[invocation setSelector:@selector(findUsingColumn:orCreateWithAttributes:)];
		[invocation setArgument:&attributes atIndex:3];
		[invocation invokeWithTarget:self];
		
	}
}

@end
