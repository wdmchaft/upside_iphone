//
//  ZNCsvHttpRequest.h
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNHttpRequest.h"

@class ZNArrayCsvParser;
@class ZNModelCsvParser;

@interface ZNCsvHttpRequest : ZNHttpRequest {
  NSMutableArray* response;
  ZNArrayCsvParser* arrayParser;
  ZNModelCsvParser* modelParser;
}

// Convenience method for issuing a request.
+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSObject*)dictionaryOrModel
       fieldCasing:(enum ZNFormatterCasing)fieldCasing
      encoderClass:(Class)dataEncodingClass
     responseClass:(Class)modelClass
responseProperties:(NSArray*)modelPropertyNames
            target:(NSObject*)target
            action:(SEL)action;

// Convenience method for issuing a request with snake-cased form fields.
+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSObject*)dictionaryOrModel
     responseClass:(Class)modelClass
responseProperties:(NSArray*)modelPropertyNames
            target:(NSObject*)target
            action:(SEL)action;

// Designated initializer.
-(id)initWithURLRequest:(NSURLRequest*)request
          responseClass:(Class)modelClass
     responseProperties:(NSArray*)modelPropertyNames
                 target:(NSObject*)target
                 action:(SEL)action;

@end
