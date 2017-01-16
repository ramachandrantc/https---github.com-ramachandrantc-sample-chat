//
//  ForgotPasswordViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/2/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Forgot Password";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.emailValidator = [SHEmailValidator validator];
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=self.view.center;
    [self.view bringSubviewToFront:self.activityView];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.submitButon.layer.cornerRadius = 4;
    
    // drop shadow
    [self.submitButon.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.submitButon.layer setShadowOpacity:1.0];
    [self.submitButon.layer setShadowRadius:1.0];
    [self.submitButon.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [iconButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    UIBarButtonItem *icon = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
    
    [iconButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = icon;
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
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, (self.scrollView.frame.size.height + 80.0f))];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    //[self.scrollView setContentOffset:CGPointZero animated:YES];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)submit:(id)sender {
    [self.activityView startAnimating];
    
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"forgot_password"];
    
    NSString *post = [NSString stringWithFormat:@"email=%@", self.email.text];
    
    NSError *error;
    [self.emailValidator validateSyntaxOfEmailAddress:self.email.text withError:&error];
    
    if([self.email.text isEqualToString:@""] ){
        [self.activityView stopAnimating];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"Please enter valid e-mail address."
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
        
        [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
            [self.activityView stopAnimating];
            NSLog(@"%@", response);
            
            if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
                [self.email setText:@""];                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                  message:[response objectForKey:@"response"]
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
            } else {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                  message:@"Something went wrong. Please try again later.."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
            }
        }];
    }
}
@end
