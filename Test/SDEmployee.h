#import "Employee.h"

@interface SDEmployee : Employee {

}

@end

@interface SDEmployee (Squelch)
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
