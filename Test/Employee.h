//
//  Employee.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-05.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SimpleModel.h"

@interface Employee :  SimpleModel  {
}

@property (nonatomic, retain) NSNumber * smoker;
@property (nonatomic, retain) NSString * favoriteColor;
@property (nonatomic, retain) NSString * bloodType;
@property (nonatomic, retain) NSString * starSign;
@property (nonatomic, retain) NSDate * dateOfBirth;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * name;

@end

@interface Employee (Squelch)
+ (id)findByName:(id)n;
+ (id)createWithName:(id)n;
+ (id)createWithName:(id)n dateOfBirth:(id)d starSign:(id)s;
+ (id)findByDateOfBirth:(id)d;
+ (id)findAllByDateOfBirth:(id)d;
+ (id)findAllByDateOfBirth:(id)d sortBy:(id)s;
+ (id)findAllByDateOfBirth:(id)d sortByDescending:(id)s;
+ (id)findAllByDateOfBirth:(id)d sortByDescending:(id)s sortBy:(id)s2;
+ (id)createWithName:(id)n email:(id)e starSign:(id)s createdAt:(id)c
		   updatedAt:(id)u bloodType:(id)b favoriteColor:(id)f;
+ (id)createWithName:(id)n smoker:(id)s;
+ (id)createWithName:(id)n email:(id)e;
+ (id)findOrCreateWithEmail:(id)e name:(id)n;
+ (id)findByEmail:(id)e;
+ (id)findAllByEmail:(id)e;
+ (id)findOrCreateWithName:(id)n;
+ (id)findAllByName:(id)n;

@end



