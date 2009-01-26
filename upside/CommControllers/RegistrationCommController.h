//
//  RegistrationCommController.h
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RegistrationCommDelegate
- (void)activationFailed: (NSError*)error;
- (void)activationSucceeded;
@end

@class ActivationState;

@interface RegistrationCommController : NSObject {	
	IBOutlet id<RegistrationCommDelegate> delegate;
	
	NSDictionary* resposeModels;
	ActivationState* activationState;
}

// Try to register. Sends outcome via a message to the delegate.
- (void) registerDeviceUsing: (ActivationState*)activationState;

@end