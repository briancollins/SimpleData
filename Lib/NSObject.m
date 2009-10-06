//
//  NSObject.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-05.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "NSObject.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}


@implementation NSObject (SimpleData)


+ (NSDictionary *)describeProperties {
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:10];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
			const char *propType = getPropertyType(property);
			[d setObject:[NSString stringWithUTF8String:propType]
				  forKey:[NSString stringWithUTF8String:propName]];
        }
    }
    free(properties);
	return [NSDictionary dictionaryWithDictionary:d];
}

@end
