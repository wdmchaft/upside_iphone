//
//  NamedAccountViewController.m
//  StockPlay
//
//  Created by Victor Costan on 5/9/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "NamedAccountViewController.h"

#import "ActivationState.h"
#import "ServiceError.h"
#import "User.h"
#import "UserQueryCommController.h"
#import "UserUpdateCommController.h"


@interface NamedAccountViewController () <UITextViewDelegate>
-(void)setNameAvailabilityUnknown;
-(void)setNameAvailability:(BOOL)isNameAvailable;
-(void)availabilitySearchNeeded;
-(void)availabilitySearchResults:(NSArray*)results;
@end

@implementation NamedAccountViewController
@synthesize lastQueryResponse, lastQueryName;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    queryCommController = [[UserQueryCommController alloc]
                           initWithTarget:self
                           action:@selector(availabilitySearchResults:)];
    lastQueryTime = 0.0;
    updateCommController = [[UserUpdateCommController alloc]
                            initWithTarget:self
                            action:@selector(userUpdateResult:)];
  }
  return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Claim User Name";
  [self setNameAvailabilityUnknown];
  [userNameText becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}


-(void)dealloc {
  [queryCommController release];
  [lastQueryResponse release];
  [super dealloc];
}

-(IBAction)passwordVisibleChanged {
  [passwordText setSecureTextEntry:(!passwordVisibleSwitch.on)];
}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
  if (textField == userNameText) {
    // TODO(overmind): prohibit characters that don't work in user names
    [self performSelector:@selector(availabilitySearchNeeded)
               withObject:nil
               afterDelay:0.2];
  }
  return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (textField == userNameText) {
    [passwordText becomeFirstResponder];
  }
  return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UIView* view in self.view.subviews) {
    if ([view isKindOfClass:[UITextField class]])
      [view resignFirstResponder];
  }
}

-(void)setNameAvailabilityUnknown {
  nameAvailabilityLabel.text = @"";
  nameAvailabilityImage.image = nil;
}
-(void)setNameAvailability:(BOOL)isNameAvailable {
  nameAvailabilityLabel.text = isNameAvailable ? @"" : @"taken";
  nameAvailabilityLabel.textColor = isNameAvailable ?
      [UIColor greenColor] : [UIColor redColor];
  nameAvailabilityImage.image = isNameAvailable ?
      [UIImage imageNamed:@"GreenTick.png"] : [UIImage imageNamed:@"RedX.png"];
}

-(IBAction)claimNameTapped {
  User* user = [[User alloc] initWithName:userNameText.text
                                 password:passwordText.text];
  [updateCommController updateUser:user];
  [user release];
  [progressIndicatorView setHidden:NO];
}
-(void)userUpdateResult:(NSArray*)results {
  [progressIndicatorView setHidden:YES];
  
  // HTTP errors.
  if ([results isKindOfClass:[NSError class]]) {
    NSString* title = [(NSError*)results localizedDescription];
    NSString* message = [(NSError*)results localizedFailureReason];
    if (!message) {
      if (title) {
        message = title;
        title = nil;
      }
      else {
        message = @"Something went horribly wrong.";
      }
    }
    if (!title) {
      title = @"Account upgrade error";
    }
    
    UIAlertView* alertView =
        [[UIAlertView alloc] initWithTitle:title
                                   message:message
                                  delegate:self
                         cancelButtonTitle:@"Retry"
                         otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    return;
  }
  // Service errors.
  NSObject* result = [results objectAtIndex:0];
  if ([result isKindOfClass:[ServiceError class]]) {
    UIAlertView* alertView = 
        [[UIAlertView alloc] initWithTitle:@"Account upgrade error"
                                   message:[(ServiceError*)result message]
                                  delegate:self
                         cancelButtonTitle:@"Retry"
                         otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    return;
  }
  
  // Rename succeeded... replace activation information.
  NSAssert([result isKindOfClass:[User class]],
           @"Non-error result should be a User instance");
  ActivationState* activation = [ActivationState sharedState];
  User* newUser = [[User alloc] initWithUser:(User*)result
                                    password:passwordText.text];
  [activation setUser:newUser];
  [newUser release];
  [activation save];
  
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)availabilitySearchNeeded {
  // Do not issue duplicate queries.
  if ([lastQueryName isEqualToString:userNameText.text]) {
    return;
  }
  NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
  if (now - lastQueryTime < 0.6) {
    // Do not fire more than one search per 0.6 seconds.
    [self performSelector:@selector(availabilitySearchNeeded)
               withObject:nil
               afterDelay:0.2];
    return;
  }
  lastQueryTime = now;
  self.lastQueryName = userNameText.text;
  [queryCommController startQueryForName:lastQueryName];
}
-(void)availabilitySearchResults:(NSArray*)results {
  if (![results isKindOfClass:[NSArray class]]) {
    // TODO(overmind): handle transport error
  }
  UserQueryResponse* response = [results objectAtIndex:0];
  if ([response isKindOfClass:[ServiceError class]]) {
    // TODO(overmind): handle service error
  }

  if ([response.name isEqualToString:lastQueryName]) {
    self.lastQueryResponse = response;
    if ([response.name isEqualToString:userNameText.text]) {
      [self setNameAvailability:(!response.taken)];
    }
  }
}
@end
