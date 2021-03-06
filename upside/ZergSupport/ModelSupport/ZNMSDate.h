//
//  NZMSDate.h
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNMSAttributeType.h"

@interface ZNMSDate : ZNMSAttributeType {
  NSDateFormatter* osxFormatter;
  NSDateFormatter* osxFormatter2;
  NSDateFormatter* railsFormatter;
  NSDateFormatter* rssFormatter;
}

@end
