//
//  ZNCsvHttpRequest.m
//  upside
//
//  Created by Victor Costan on 1/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNCsvHttpRequest.h"

#import "ModelSupport.h"
#import "ZNArrayCsvParser.h"
#import "ZNModelCsvParser.h"

@interface ZNCsvHttpRequest ()
<ZNArrayCsvParserDelegate, ZNModelCsvParserDelegate> 
@end

@implementation ZNCsvHttpRequest

#pragma mark Lifecycle

- (id) initWithURLRequest: (NSURLRequest*)theRequest
            responseClass: (Class)modelClass
       responseProperties: (NSArray*)modelPropertyNames
                   target: (NSObject*)theTarget
                   action: (SEL)theAction {
	if ((self = [super initWithURLRequest:theRequest
                                 target:theTarget
                                 action:theAction])) {
		response = [[NSMutableArray alloc] init];
		if ([ZNModel isModelClass:modelClass]) {
			modelParser = [[ZNModelCsvParser alloc]
                     initWithModelClass:modelClass
                     propertyNames:modelPropertyNames];
			modelParser.delegate = self;
		}
		else {
			arrayParser = [[ZNArrayCsvParser alloc] init];
			arrayParser.delegate = self;
		}
	}
	return self;
}

- (void) dealloc {
	[response release];
	[arrayParser release];
	[modelParser release];
	[super dealloc];
}

+ (void) callService: (NSString*)service
              method: (NSString*)method
                data: (NSDictionary*)data
       responseClass: (Class)modelClass
  responseProperties: (NSArray*)modelPropertyNames
              target: (NSObject*)target
              action: (SEL)action {
	NSURLRequest* urlRequest = [self newURLRequestToService:service
                                                   method:method
                                                     data:data];
	ZNCsvHttpRequest* request =
      [[ZNCsvHttpRequest alloc] initWithURLRequest:urlRequest
                                     responseClass:modelClass
                                responseProperties:modelPropertyNames
                                            target:target
                                            action:action];
	[request start];
	[urlRequest release];
	
	// The request will release itself when it is completed.
}

#pragma mark Parser Delegates

- (void) parsedLine: (NSArray*)lineData context: (id)context {
	[response addObject:lineData];
}

- (void) parsedModel: (ZNModel*)model context: (id)context {
	[response addObject:model];
}

#pragma mark Delegate Invocation

- (void) reportData {
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
	if (arrayParser)
		[arrayParser parseData:responseData];
	else
		[modelParser parseData:responseData];
	[arp release];
	[target performSelector:action withObject:response];	
}

@end
