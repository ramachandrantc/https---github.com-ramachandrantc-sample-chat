//
//  PasswordViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/14/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "Reachability.h"

@interface PasswordViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *poupView;
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property UIActivityIndicatorView *activityView;
@property NSString *flag;
@property CGRect frame;

- (IBAction)changePassword:(id)sender;
- (IBAction)cancel:(id)sender;
@end
