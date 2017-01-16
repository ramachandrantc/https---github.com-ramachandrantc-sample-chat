//
//  LoginViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 11/29/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Login";
    self.remember = @"No";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=self.view.center;
    [self.view bringSubviewToFront:self.activityView];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
    
    self.email.delegate = self;
    self.password.delegate = self;
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Forgot Password?"];
    
     [commentString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[commentString length])];
    [self.forgotPasswordButton setAttributedTitle:commentString forState:UIControlStateNormal];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"remember_me"]  isEqual: @"Yes"]) {
        self.email.text = [defaults objectForKey:@"email"];
        self.password.text = [defaults objectForKey:@"password"];
        [self.rememberMeButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        self.remember = @"Yes";
    }
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.loginForm.layer.cornerRadius = 4;
    
    self.loginButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.loginButton.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.loginButton.layer setShadowOpacity:1.0];
    [self.loginButton.layer setShadowRadius:1.0];
    [self.loginButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.registerButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.registerButton.layer setShadowColor:[UIColor colorWithRed:(62.0/255) green:(102.0/255) blue:(16.0/255) alpha:1].CGColor];
    [self.registerButton.layer setShadowOpacity:1.0];
    [self.registerButton.layer setShadowRadius:1.0];
    [self.registerButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    [self registerForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, (keyboardSize.height + 420.0f))];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    //[self.scrollView setContentOffset:CGPointZero animated:YES];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 420.0f)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    NSError *error;
    [self.emailValidator validateSyntaxOfEmailAddress:self.email.text withError:&error];
    
    if([[self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || [[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
         message:@"Email and Password are mandatory fields."
         delegate:self
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         [message show];
    } else if(error) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"Please enter valid e-mail address."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                              message:@"Check you connection and try again."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        } else {
            [self.activityView startAnimating];
            NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
            NSString *url = [urlDictionary objectForKey:@"login"];
            
            NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", self.email.text, self.password.text];
            
            [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
                [self.activityView stopAnimating];
                NSLog(@"%@", response);
                
                if([[response objectForKey:@"status"] isEqualToString: @"Success"]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    if([self.remember isEqualToString:@"Yes"]) {
                        [defaults setObject:self.email.text forKey:@"email"];
                        [defaults setObject:self.password.text forKey:@"password"];
                        [defaults setObject:@"Yes" forKey:@"remember_me"];
                    } else {
                        [defaults setObject:@"" forKey:@"email"];
                        [defaults setObject:@"" forKey:@"password"];
                        [defaults setObject:@"No" forKey:@"remember_me"];
                    }
                    NSDictionary *dict = [response objectForKey:@"all_details"];
                    [defaults setObject:[dict objectForKey:@"quick_email"] forKey:@"quick_email"];
                    [defaults setObject:[dict objectForKey:@"id"] forKey:@"cust_id"];
                    [defaults setObject:[dict objectForKey:@"quick_pass"] forKey:@"quick_pass"];
                    [defaults setObject:[dict objectForKey:@"quick_id"] forKey:@"quick_id"];
                    [defaults setObject:[dict objectForKey:@"customer"] forKey:@"customer"];
                    [defaults setObject:@"IN" forKey:@"logged"];
                    
                    NSString *respUrl = [urlDictionary objectForKey:@"add_device"];
                    
                    NSString *respPost = [NSString stringWithFormat:@"device_id=%@&api_key=%@&cust_id=%@", @"02:00:00:00:00:00", [defaults objectForKey:@"device_token"], [dict objectForKey:@"id"]];
                    [[[Network alloc] init] POSTBlockWebservicewithParameters:respPost URL:respUrl  block:^(NSDictionary * response) {
                        NSLog(@"%@", response);
                        
                    }];
                    
                    HomeViewController *home;
                    
                    home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                    
                    [self.email setText:@""];
                    [self.password setText:@""];
                    
                    [self.navigationController pushViewController:home animated:YES];
                } else {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                      message:[response objectForKey:@"response"]
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                }
            }];
        }
    }
}

- (IBAction)signup:(id)sender {
    RegisterViewController *signup = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:signup animated:YES];
}

- (IBAction)forgotPassword:(id)sender {
    ForgotPasswordViewController *forgot = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgot animated:YES];
}

- (IBAction)rememberMe:(id)sender {
    if([self.remember isEqualToString:@"No"]) {
        [self.rememberMeButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        self.remember = @"Yes";
    } else {
        [self.rememberMeButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        self.remember = @"No";
    }
}
@end
