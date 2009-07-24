//
//  ZNExtUIApplicationTest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNExtUIApplication.h"


// This delegate should not be auto-instantiated for chaining.
static BOOL manualDelegateLaunched = NO;
@interface ZNExtUIApplicationTestManual : NSObject<UIApplicationDelegate> {  
}
@end
@implementation ZNExtUIApplicationTestManual
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  manualDelegateLaunched = NO;
}
@end


// This delegate should be auto-instantiated for chaining.
static BOOL autoDelegateLaunched = NO;
@interface ZNExtUIApplicationTestAuto :
    NSObject<UIApplicationDelegate, ZNAutoUIApplicationDelegate> {  
}
@end
@implementation ZNExtUIApplicationTestAuto
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  autoDelegateLaunched = YES;
}
@end


@interface ZNExtUIApplicationTest : SenTestCase {
}
@end


@implementation ZNExtUIApplicationTest

-(void)testAutoDelegateChaining {
  STAssertTrue(autoDelegateLaunched,
               @"Delegate with auto-chaining wasn't invoked at app launch");
  STAssertFalse(manualDelegateLaunched,
               @"Delegate without auto-chaining was invoked at app launch");
}

-(void)testCopyAllAutoChainedClasses {
  NSArray* chainedClasses = [ZNExtUIApplication copyAllAutoChainedClasses];
  STAssertTrue([chainedClasses containsObject:[ZNExtUIApplicationTestAuto
                                               class]],
               @"copyAllAutoChainedClasses missed an auto-chaining delegate");
  STAssertFalse([chainedClasses containsObject:[ZNExtUIApplicationTestManual
                                                class]],
                @"copyAllAutoChainedClasses has a manual-chaining delegate");
}

-(void)testSharedDelegate {
  STAssertTrue([[ZNExtUIApplication sharedApplication]
                isKindOfClass:[ZNExtUIApplication class]],
               @"[UIApplication sharedApplication] not a ZNExtUIApplication");
}

@end
