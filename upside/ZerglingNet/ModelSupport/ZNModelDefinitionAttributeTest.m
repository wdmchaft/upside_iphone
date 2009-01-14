//
//  ZNModelDefinitionAttributeTest.m
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMSenTestCase.h"
#import "ZNTestModels.h"

#import "ZNMSAttributeTypes.h"
#import "ZNModelDefinitionAttribute.h"


@interface ZNModelDefinitionAttributeTest : SenTestCase {
	objc_property_t* testProperties;
	unsigned int numTestProperties;
}
@end

@implementation ZNModelDefinitionAttributeTest
- (void) setUp {
	Class testClass = [ZNTestParsing class];
	testProperties = class_copyPropertyList(testClass,
											&numTestProperties);
}

- (void) tearDown {
	if (testProperties) {
		free(testProperties);
	}
}

- (objc_property_t) propertyNamed: (const char*)name {
	for(unsigned int i = 0; i < numTestProperties; i++) {
		const char* propertyName = property_getName(testProperties[i]);
		if (!strcmp(propertyName, name))
			return testProperties[i];
	}
	return 0;
}

- (void) testSetterStrategy {
	const char* properties[] = {"assign", "copy", "retain",
	                            "ro_assign", "ro_copy", "ro_retain"};
	enum ZNPropertySetterStrategy golden_strategies[] = {
		kZNPropertyWantsAssign, kZNPropertyWantsCopy, kZNPropertyWantsRetain,
		kZNPropertyWantsAssign, kZNPropertyWantsCopy, kZNPropertyWantsRetain};
	BOOL golden_readonlies[] = {NO, NO, NO, YES, YES, YES};
	// BOOL golden_atomics[] = {NO, YES, NO, YES, NO, YES};
	
	for(int i = 0; i < sizeof(properties) / sizeof(*properties); i++) {
		objc_property_t property = [self propertyNamed:properties[i]];
		ZNModelDefinitionAttribute* attr =
		   [ZNModelDefinitionAttribute newAttributeFromProperty:property];
		
		STAssertEquals(golden_strategies[i], [attr setterStrategy],
					   @"Failed to parse setter strategy %s", properties[i]);
		STAssertEquals(golden_readonlies[i], [attr isReadOnly],
					   @"Failed to parse readonly attribute for %s",
					   properties[i]);
		/*
		STAssertEquals(golden_atomics[i], [attr isAtomic],
					   @"Failed to parse atomicity for %s",
					   properties[i]);
		 */
	}
}

- (void) testType {
	const char* properties[] = {"date_prop",
	    "double_prop", "integer_prop", "string_prop", "uinteger_prop"};
	ZNMSAttributeTypes* t = [ZNMSAttributeTypes sharedInstance];
	ZNMSAttributeType* golden_types[] = {[t dateType],
	    [t doubleType], [t integerType], [t stringType], [t uintegerType]};
	
	for(int i = 0; i < sizeof(properties) / sizeof(*properties); i++) {
		objc_property_t property = [self propertyNamed:properties[i]];
		ZNModelDefinitionAttribute* attr =
		[ZNModelDefinitionAttribute newAttributeFromProperty:property];
		
		STAssertEquals(golden_types[i], [attr type],
					   @"Failed to parse type for %s", properties[i]);
		/*
		STAssertEquals(YES, [attr isAtomic],
					   @"Failed to parse atomicity for %s", properties[i]);
		 */
	}
}

- (void) testCustomGetterSetter {
	const char* properties[] =
	    {"string_prop", "getter", "setter", "accessor"};
	NSString* golden_getters[] = 
	    {nil, @"get_pwn", nil, @"superpwn"};
	NSString* golden_setters[] = 
	    {nil, nil, @"set_pwn:", @"superpwn:"};
	//BOOL golden_atomics[] = {NO, NO, NO, YES};
	
	for(int i = 0; i < sizeof(properties) / sizeof(*properties); i++) {
		objc_property_t property = [self propertyNamed:properties[i]];
		ZNModelDefinitionAttribute* attr =
		[ZNModelDefinitionAttribute newAttributeFromProperty:property];
		
		STAssertEqualStrings(golden_getters[i], [attr getterName],
					         @"Failed to parse getter name for %s",
							 properties[i]);
		STAssertEqualStrings(golden_setters[i], [attr setterName],
							 @"Failed to parse setter name for %s",
							 properties[i]);
		/*
		STAssertEquals(golden_atomics[i], [attr isAtomic],
					   @"Failed to parse atomicity for %s",
					   properties[i]);
		 */
	}	
}

@end
