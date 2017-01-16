//
//  RegisterViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 11/30/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.emailValidator = [SHEmailValidator validator];
    
    self.title = @"Register";
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 600.0f)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.locations = [[NSMutableArray alloc] init];
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=self.view.center;
    [self.view bringSubviewToFront:self.activityView];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    
    self.tableVisible = @"No";
    
    self.locationTable.delegate = self;
    self.locationTable.dataSource = self;
    
    [self.activityView startAnimating];
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"request_link"];
    [self.scrollView setHidden:YES];
    [self.registerForm setHidden:YES];
    
    [[[Network alloc] init] GETBlockWebservicewithParameters:@"" URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            [self.scrollView setHidden:YES];
            [self.registerForm setHidden:YES];
            self.locations = [response objectForKey:@"locations"];
            NSDictionary *dict = [self.locations objectAtIndex:0];
            [self.location setTitle:[dict objectForKey:@"location_name_english"] forState:UIControlStateNormal];
            [self.scrollView setHidden:NO];
            [self.registerForm setHidden:NO];
            [self.locationTable reloadData];
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                              message:[response objectForKey:@"message"]
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }];
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
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, (keyboardSize.height + 600.0f))];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    //[self.scrollView setContentOffset:CGPointZero animated:YES];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 600.0f)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.registerForm.layer.cornerRadius = 4;
    
    self.signupButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.signupButton.layer setShadowColor:[UIColor colorWithRed:(62.0/255) green:(102.0/255) blue:(16.0/255) alpha:1].CGColor];
    [self.signupButton.layer setShadowOpacity:1.0];
    [self.signupButton.layer setShadowRadius:1.0];
    [self.signupButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [iconButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    UIBarButtonItem *icon = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
    
    [iconButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = icon;
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterFromKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];    
    self.tableFrame = self.locationTable.frame;
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

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *dict = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"location_name_english"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.locations objectAtIndex:indexPath.row];
    self.selectedLocation = indexPath.row;
    [self.location setTitle:[dict objectForKey:@"location_name_english"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5f animations:^{
        self.locationTable.frame = self.tableFrame;
    }];
    self.tableVisible = @"No";
}

- (IBAction)signup:(id)sender {
    NSError *error;
    [self.emailValidator validateSyntaxOfEmailAddress:self.email.text withError:&error];
    
    if([[self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || [self.name.text isEqualToString:@""] || [self.name.text isEqualToString:@""] || [self.password.text isEqualToString:@""] || [self.confirmPassword.text isEqualToString:@""] || [self.apartment.text isEqualToString:@""] || [self.mobile.text isEqualToString:@""] || [self.building.text isEqualToString:@""]) {
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
            NSString *url = [urlDictionary objectForKey:@"registration"];
            NSDictionary *loc = [self.locations objectAtIndex:self.selectedLocation];
            NSString *post = [NSString stringWithFormat:@"name=%@&emai=%@&pswrd=%@&mobno=%@&locn=%@&locn_name=%@&building=%@&apartment=%@&address=%@", self.name.text, self.email.text, self.password.text, self.mobile.text, [loc objectForKey:@"loc_id"], [loc objectForKey:@"location_name_english"], self.building.text, self.apartment.text, self.address.text];
            
            [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
                [self.activityView stopAnimating];
                NSLog(@"%@", response);
                
                if([[response objectForKey:@"status"] isEqualToString: @"Success"]) {
                    self.flag = @"success";
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                      message:@"Registration complete. Please verify your account from your mail!"
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                    [self.navigationController popViewControllerAnimated:YES];
                } else if([[response objectForKey:@"status"] isEqualToString: @"Failure"]) {
                    self.flag = @"failure";
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                      message:[response objectForKey:@"response"]
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    self.flag = @"failure";
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        if([self.flag  isEqualToString:@"success"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)changeLocation:(id)sender {
    if([self.tableVisible isEqualToString:@"No"]) {
        [UIView animateWithDuration:0.5f animations:^{
            self.locationTable.frame = CGRectMake(0, (self.view.frame.size.height - 128.0f), self.view.frame.size.width, 128.0f);
        }];
        self.tableVisible = @"Yes";
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            self.locationTable.frame = self.tableFrame;
        }];
        self.tableVisible = @"No";
    }
}
@end
