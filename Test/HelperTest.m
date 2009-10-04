//
//  HelperTest.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-04.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "HelperTest.h"
#import "NSString.h"

@implementation HelperTest

- (void) testUncapitalizedString {
    STAssertEqualStrings(@"helloWorld", [@"HelloWorld" uncapitalizedString], 
						 @"String should be uncapitalized but camel case preserved");
}


@end
