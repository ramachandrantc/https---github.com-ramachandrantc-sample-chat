//
//  PasswordViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/14/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // drop shadow
    [self.poupView.layer setShadowColor:[UIColor colorWithRed:(154.0/255) green:(154.0/255) blue:(154.0/255) alpha:1].CGColor];
    [self.poupView.layer setShadowOpacity:0.8];
    [self.poupView.layer setShadowRadius:1.0];
    [self.poupView.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.changePasswordButton.layer.cornerRadius = 4;
    // drop shadow
    [self.changePasswordButton.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.changePasswordButton.layer setShadowOpacity:1.0];
    [self.changePasswordButton.layer setShadowRadius:1.0];
    [self.changePasswordButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.cancelButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.cancelButton.layer setShadowColor:[UIColor colorWithRed:(62.0/255) green:(102.0/255) blue:(16.0/255) alpha:1].CGColor];
    [self.cancelButton.layer setShadowOpacity:1.0];
    [self.cancelButton.layer setShadowRadius:1.0];
    [self.cancelButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=self.view.center;
    [self.view bringSubviewToFront:self.activityView];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.frame = self.poupView.frame;
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
    self.poupView.frame = CGRectMake(self.frame.origin.x, (self.frame.origin.y - 80), self.frame.size.width, self.frame.size.height);
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    //[self.scrollView setContentOffset:CGPointZero animated:YES];
    self.poupView.frame = self.frame;
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

- (IBAction)changePassword:(id)sender {
    if([[self.oldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || [self.password.text isEqualToString:@""] || [self.confirmPassword.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"Please fill all mandatory fields."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else if(![self.password.text isEqualToString:self.confirmPassword.text]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"Password mismatch."
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
            NSString *url = [urlDictionary objectForKey:@"new_password"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *post = [NSString stringWithFormat:@"new_password=%@&custid=%@&current_password=%@", self.password.text, [defaults objectForKey:@"cust_id"], self.oldPassword.text];
            
            [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
                [self.activityView stopAnimating];
                NSLog(@"%@", response);
                
                if([[response objectForKey:@"status"] isEqualToString: @"Success"]) {
                    self.flag = @"success";
                    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
                     {
                         self.view.alpha = 0;
                     }
                                     completion:^(BOOL finished)
                     {
                         [self.view removeFromSuperview];
                     }];
                    [self.view removeFromSuperview];
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                      message:@"Password updated successfully."
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                } else if([[response objectForKey:@"status"] isEqualToString: @"Failure"]) {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                      message:[response objectForKey:@"response"]
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                } else {
                    self.flag = @"failure";
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                      message:@"Something went wrong. Please try again."
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                }
            }];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        if([self.flag  isEqualToString:@"success"]) {
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
             {
                 self.view.alpha = 0;
             }
                             completion:^(BOOL finished)
             {
                 [self.view removeFromSuperview];
             }];
            [self.view removeFromSuperview];
        }
    }
}

- (IBAction)cancel:(id)sender {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         self.view.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
     }];
    [self.view removeFromSuperview];
}
@end
