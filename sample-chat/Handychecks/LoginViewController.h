//
//  LoginViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 11/29/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "SHEmailValidator.h"
#import "SHAutocorrectSuggestionView.h"
#import "Reachability.h"
#import "MFSideMenuContainerViewController.h"
#import "ForgotPasswordViewController.h"
#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *loginForm;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *rememberMeButton;
@property (strong, nonatomic) NSString *remember;
@property UIActivityIndicatorView *activityView;

@property (nonatomic, strong) SHAutocorrectSuggestionView *suggestionView;
@property (nonatomic, strong) SHEmailValidator *emailValidator;

- (IBAction)login:(id)sender;
- (IBAction)signup:(id)sender;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)rememberMe:(id)sender;
@end
