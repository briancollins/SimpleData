//
//  User.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SimpleModel.h"

@interface User :  SimpleModel  
{
}

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * createdAt;

@end



