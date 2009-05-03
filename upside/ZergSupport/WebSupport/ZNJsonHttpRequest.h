//
//  ZNJsonHttpRequest.h
//  ZergSupport
//
//  Created by Victor Costan on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZNHttpRequest.h"

@class ZNModelJsonParser;


@interface ZNJsonHttpRequest : ZNHttpRequest {
  NSMutableArray* response;
  ZNModelJsonParser* responseParser;
}

// Convenience method for issuing a request.
+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSDictionary*)data
       fieldCasing:(enum ZNFormatterCasing)fieldCasing
   responseQueries:(NSArray*)responseQueries
    responseCasing:(enum ZNFormatterCasing)responseCasing
            target:(NSObject*)target
            action:(SEL)action;

// Convenience method for issuing a request with a snake-cased server.
+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSDictionary*)data
   responseQueries:(NSArray*)responseQueries
            target:(NSObject*)target
            action:(SEL)action;

// Designated initializer.
-(id)initWithURLRequest:(NSURLRequest*)request
        responseQueries:(NSArray*)responseQueries
         responseCasing:(enum ZNFormatterCasing)responseCasing
                 target:(NSObject*)target
                 action:(SEL)action;
@end
