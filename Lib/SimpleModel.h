//
//  SimpleModel.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 Brian Collins. All rights reserved.
//
#import <CoreData/CoreData.h>

@interface SimpleModel : NSManagedObject {

}

+ (id)createWithAttributes:(NSDictionary *)attributes;
+ (id)findWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit;
+ (id)findAll;
+ (id)find:(id)obj inColumn:(NSString *)col;
+ (id)findWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit sortBy:(NSMutableArray *)sortCol;
+ (void)forwardInvocation:(NSInvocation *)invocation;
- (BOOL)save;

@end
