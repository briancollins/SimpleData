//
//  SimpleModel.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <CoreData/CoreData.h>

@interface SimpleModel : NSManagedObject {

}

+ (id)createWithAttributes:(NSDictionary *)attributes;
+ (id)findWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit;
+ (id)findAll;
+ (id)find:(id)obj inColumn:(NSString *)col;

@end
