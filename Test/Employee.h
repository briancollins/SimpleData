//
//  Employee.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-04.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SimpleModel.h"

@interface Employee :  SimpleModel  
{
}

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * dateOfBirth;

@end



