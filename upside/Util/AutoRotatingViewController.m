//
//  AutoRotatingViewController.m
//  upside
//
//  Created by Victor Costan on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AutoRotatingViewController.h"


@implementation AutoRotatingViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 	// Will rotate any way the user wants us to.
  return YES;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview
  [super didReceiveMemoryWarning]; 
  // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end