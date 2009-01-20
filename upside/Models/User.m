//
//  User.m
//  upside
//
//  Created by Victor Costan on 1/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "User.h"

#import <CommonCrypto/CommonDigest.h>

#import "Device.h"

@implementation User

@synthesize name, password, isPseudoUser, modelId;

- (void) dealloc {
	[name release];
	[password release];
	[super dealloc];
}

- (NSString*) hexDigest: (NSString*)string {
	uint8_t digestBuffer[CC_SHA256_DIGEST_LENGTH];
	NSData* stringBytes = [string dataUsingEncoding:NSUTF8StringEncoding];
	
	CC_SHA256([stringBytes bytes], [stringBytes length], digestBuffer);
	NSMutableString* hexDigest = [[NSMutableString alloc] init];
	for (NSUInteger i = 0;
		 i < sizeof(digestBuffer) / sizeof(*digestBuffer);
		 i++) {
		[hexDigest appendFormat:@"%02x", digestBuffer[i]];
	}
	return [hexDigest autorelease];
}

- (id) initPseudoUser: (Device*)device {
	return [self initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
									 [self hexDigest:device.uniqueId], @"name",
									 device.uniqueId, @"password",
									 [NSNumber numberWithBool:YES],
									 @"isPseudoUser", nil]];
}

- (id) initWithName: (NSString*)theName password: (NSString*)thePassword {
	return [self initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
									 theName, @"name", thePassword, @"password",
									 [NSNumber numberWithBool:NO],
									 @"isPseudoUser", nil]];
}

- (id) initWithUser: (User*)user password: (NSString*)thePassword {
	if ((self = [self initWithModel:user])) {
		[password release];
		password = [thePassword retain];
	}
	return self;
}


@end
