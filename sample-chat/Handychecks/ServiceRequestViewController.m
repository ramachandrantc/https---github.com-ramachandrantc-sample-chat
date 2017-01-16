//
//  ServiceRequestViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/8/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "ServiceRequestViewController.h"

@interface ServiceRequestViewController ()

@end

@implementation ServiceRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"POST A SERVICE";
    
    [self.scrollView setHidden:YES];
    self.locationTableViewVisible = @"No";
    self.timeTableViewVisible = @"No";
    self.serviceTableViewVisible = @"No";
    
    self.amount.layer.cornerRadius = 4.0f;
    
    self.serviceTableView.delegate = self;
    self.serviceTableView.dataSource = self;
    self.locationTableView.delegate = self;
    self.locationTableView.dataSource = self;
    self.timeTableView.delegate = self;
    self.timeTableView.dataSource = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [self.datePicker addTarget:self
                    action:@selector(datePickerDateChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    [self.timePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [self.timePicker addTarget:self
                        action:@selector(timePickerTimeChanged:)
              forControlEvents:UIControlEventValueChanged];
    
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
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"request_link"];
    
    [[[Network alloc] init] GETBlockWebservicewithParameters:@"" URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            [self.scrollView setHidden:YES];
            self.locations = [response objectForKey:@"locations"];
            self.times = [response objectForKey:@"time"];
            self.services = [response objectForKey:@"services"];
            
            NSDictionary *dict = [self.locations objectAtIndex:0];
            [self.location setText:[dict objectForKey:@"location_name_english"]];
            self.selectedLocation = 0;
            
            dict = [self.times objectAtIndex:0];
            [self.time setText:[dict objectForKey:@"in_hour"]];
            self.selectedTime = 0;
            
            dict = [self.services objectAtIndex:0];
            [self.service setText:[dict objectForKey:@"service_name"]];
            self.selectedService = 0;
            
            [self.scrollView setHidden:NO];
            
            [self.locationTableView reloadData];
            [self.serviceTableView reloadData];
            [self.timeTableView reloadData];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self registerForKeyboardNotifications];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [menu setImage:[UIImage imageNamed:@"menu_bar.png"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.serviceButton.layer.cornerRadius = 4;
    self.hourButton.layer.cornerRadius = 4;
    self.countryButton.layer.cornerRadius = 4;
    self.dateButton.layer.cornerRadius = 4;
    self.timeButton.layer.cornerRadius = 4;
    self.amount.layer.cornerRadius = 4;
    
    self.requestButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.requestButton.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.requestButton.layer setShadowOpacity:1.0];
    [self.requestButton.layer setShadowRadius:1.0];
    [self.requestButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.confirmButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.confirmButton.layer setShadowColor:[UIColor colorWithRed:(62.0/255) green:(102.0/255) blue:(16.0/255) alpha:1].CGColor];
    [self.confirmButton.layer setShadowOpacity:1.0];
    [self.confirmButton.layer setShadowRadius:1.0];
    [self.confirmButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
}

- (IBAction)toggleMenu:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        nil;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterFromKeyboardNotifications];
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
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, (keyboardSize.height + 450.0f))];
    
    self.serviceTableView.frame = self.tableFrame;
    self.timeTableView.frame = self.tableFrame;
    self.locationTableView.frame = self.tableFrame;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    //[self.scrollView setContentOffset:CGPointZero animated:YES];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 450)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.tableFrame = self.locationTableView.frame;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 450)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    if(tableView == self.locationTableView) {
        count = [self.locations count];
    } else if(tableView == self.timeTableView) {
        count = [self.times count];
    } else if(tableView == self.serviceTableView) {
        count = [self.services count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(tableView == self.locationTableView) {
        NSDictionary *dict = [self.locations objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict objectForKey:@"location_name_english"];
    } else if(tableView == self.timeTableView) {
        NSDictionary *dict = [self.times objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict objectForKey:@"in_hour"];
    } else if(tableView == self.serviceTableView) {
        NSDictionary *dict = [self.services objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict objectForKey:@"service_name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.locationTableView) {
        self.selectedLocation = indexPath.row;
        NSDictionary *dict = [self.locations objectAtIndex:indexPath.row];
        [self.location setText:[dict objectForKey:@"location_name_english"]];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 450)];
        [UIView animateWithDuration:0.5f animations:^{
            self.locationTableView.frame = self.tableFrame;
        }];
        self.locationTableViewVisible = @"No";
    } else if(tableView == self.timeTableView) {
        self.selectedTime = indexPath.row;
        NSDictionary *dict = [self.times objectAtIndex:indexPath.row];
        [self.time setText:[dict objectForKey:@"in_hour"]];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 450)];
        [UIView animateWithDuration:0.5f animations:^{
            self.timeTableView.frame = self.tableFrame;
        }];
        self.timeTableViewVisible = @"No";
    } else if(tableView == self.serviceTableView) {
        self.selectedService = indexPath.row;
        NSDictionary *dict = [self.services objectAtIndex:indexPath.row];
        [self.service setText:[dict objectForKey:@"service_name"]];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 450)];
        [UIView animateWithDuration:0.5f animations:^{
            self.serviceTableView.frame = self.tableFrame;
        }];
        self.serviceTableViewVisible = @"No";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectDate:(id)sender {
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.datePicker.frame = CGRectMake(0, (self.view.frame.size.height - 116.0f), self.view.frame.size.width, 116.0f);
        self.timePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
        self.locationTableView.frame = self.tableFrame;
        self.serviceTableView.frame = self.tableFrame;
        self.timeTableView.frame = self.tableFrame;
    }];
    
    //create the navigation button if it doesn't exists
    if(self.doneButton == nil){
        UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 22)];
        [done setBackgroundColor:self.requestButton.backgroundColor];
        [done setTitle:@"Done" forState:UIControlStateNormal];
        [done.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        done.layer.cornerRadius = 4;
        
        // drop shadow
        [done.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
        [done.layer setShadowOpacity:1.0];
        [done.layer setShadowRadius:1.0];
        [done.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
        [done addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        self.doneButton = [[UIBarButtonItem alloc] initWithCustomView:done];
    }
    //add the "Done" button to the right side of the navigation bar
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (IBAction)selectTime:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5f animations:^{
        self.datePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
        self.timePicker.frame = CGRectMake(0, (self.view.frame.size.height - 116.0f), self.view.frame.size.width, 116.0f);
        self.locationTableView.frame = self.tableFrame;
        self.serviceTableView.frame = self.tableFrame;
        self.timeTableView.frame = self.tableFrame;
    }];
    
    //create the navigation button if it doesn't exists
    if(self.doneButton == nil){
        UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 22)];
        [done setBackgroundColor:self.requestButton.backgroundColor];
        [done setTitle:@"Done" forState:UIControlStateNormal];
        [done.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        done.layer.cornerRadius = 4;
        
        // drop shadow
        [done.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
        [done.layer setShadowOpacity:1.0];
        [done.layer setShadowRadius:1.0];
        [done.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
        [done addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        self.doneButton = [[UIBarButtonItem alloc] initWithCustomView:done];
        //self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dateSelected:)];
    }
    //add the "Done" button to the right side of the navigation bar
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

//method to call when the "Done" button is clicked
- (void)dateSelected:(id)sender {
    
    //remove the "Done" button in the navigation bar
    [self.navigationItem setHidesBackButton:YES];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.datePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
        self.timePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
        self.locationTableView.frame = self.tableFrame;
        self.serviceTableView.frame = self.tableFrame;
        self.timeTableView.frame = self.tableFrame;
    }];
    self.navigationItem.rightBarButtonItem = nil;
}

//listen to changes in the date picker and just log them
- (void)datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    if ([paramDatePicker isEqual:self.datePicker]){
        NSLog(@"Selected date = %@", paramDatePicker.date);
    }
    [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *formatedDate = [self.dateFormatter stringFromDate:paramDatePicker.date];
    
    [self.dateButton setTitle:formatedDate forState:UIControlStateNormal];
}

//listen to changes in the date picker and just log them
- (void)timePickerTimeChanged:(UIDatePicker *)paramDatePicker{
    if ([paramDatePicker isEqual:self.timePicker]){
        NSLog(@"Selected time = %@", paramDatePicker.date);
    }
    [self.dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *formatedDate = [self.dateFormatter stringFromDate:paramDatePicker.date];
    
    [self.timeButton setTitle:formatedDate forState:UIControlStateNormal];
}

- (IBAction)confirm:(id)sender {
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
        NSString *url = [urlDictionary objectForKey:@"price_calculation"];
        NSDictionary *location = [self.locations objectAtIndex:self.selectedLocation];
        NSDictionary *time = [self.times objectAtIndex:self.selectedTime];
        NSDictionary *service = [self.services objectAtIndex:self.selectedService];
        NSString *post = [NSString stringWithFormat:@"service_id=%@&time=%@&location_id=%@", [service objectForKey:@"id"], [time objectForKey:@"value"], [location objectForKey:@"loc_id"]];
        
        [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
            [self.activityView stopAnimating];
            NSLog(@"%@", response);
            
            if([[response objectForKey:@"status"] isEqualToString: @"Success"]) {
                [self.amount setText:[NSString stringWithFormat:@"%@ AED", [response objectForKey:@"response"]]];
                self.jobAmount =  [response objectForKey:@"response"];
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

- (IBAction)request:(id)sender {
    if([self.jobDescription.text isEqualToString:@""] || [self.dateButton.titleLabel.text isEqualToString:@"Select Date"] || [self.timeButton.titleLabel.text isEqualToString:@"Select Time"]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"Please fill all fields"
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
            NSString *url = [urlDictionary objectForKey:@"request_service"];
            NSDictionary *location = [self.locations objectAtIndex:self.selectedLocation];
            NSDictionary *time = [self.times objectAtIndex:self.selectedTime];
            NSDictionary *service = [self.services objectAtIndex:self.selectedService];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *post = [NSString stringWithFormat:@"service_id=%@&time=%@&location_id=%@&amount=%@&cust_id=%@&comment=%@&service_date=%@&service_time=%@", [service objectForKey:@"id"], [time objectForKey:@"value"], [location objectForKey:@"loc_id"], self.jobAmount, [defaults objectForKey:@"cust_id"], self.jobDescription.text, self.dateButton.titleLabel.text, self.timeButton.titleLabel.text];
            
            [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
                [self.activityView stopAnimating];
                NSLog(@"%@", response);
                
                if([[response objectForKey:@"status"] isEqualToString: @"Success"]) {
                    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                    home.message = @"Successfully submitted. Your request is being received. Please wait for provider acceptance.";
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

- (IBAction)changeLocation:(id)sender {
    [self.view endEditing:YES];
    if([self.locationTableViewVisible isEqualToString:@"No"]) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, (128.0f + 450.0f))];
        [UIView animateWithDuration:0.5f animations:^{
            self.locationTableView.frame = CGRectMake(0, (self.view.frame.size.height - 128.0f), self.view.frame.size.width, 128.0f);
            self.serviceTableView.frame = self.tableFrame;
            self.timeTableView.frame = self.tableFrame;
            self.datePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
            self.timePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
        }];
        self.locationTableViewVisible = @"Yes";
    } else {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 450)];
        [UIView animateWithDuration:0.5f animations:^{
            self.locationTableView.frame = self.tableFrame;
        }];
        self.locationTableViewVisible = @"No";
    }
}

- (IBAction)changeService:(id)sender {
    [self.view endEditing:YES];
    if([self.serviceTableViewVisible isEqualToString:@"No"]) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, (128.0f + 450.0f))];
        [UIView animateWithDuration:0.5f animations:^{
            self.serviceTableView.frame = CGRectMake(0, (self.view.frame.size.height - 128.0f), self.view.frame.size.width, 128.0f);
            self.locationTableView.frame = self.tableFrame;
            self.timeTableView.frame = self.tableFrame;
            self.datePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
            self.timePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
        }];
        self.serviceTableViewVisible = @"Yes";
    } else {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 450)];
        [UIView animateWithDuration:0.5f animations:^{
            self.serviceTableView.frame = self.tableFrame;
        }];
        self.serviceTableViewVisible = @"No";
    }
}

- (IBAction)changeJobHours:(id)sender {
    [self.view endEditing:YES];
    if([self.timeTableViewVisible isEqualToString:@"No"]) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, (128.0f + 450.0f))];
        [UIView animateWithDuration:0.5f animations:^{
            self.timeTableView.frame = CGRectMake(0, (self.view.frame.size.height - 128.0f), self.view.frame.size.width, 128.0f);
            self.locationTableView.frame = self.tableFrame;
            self.serviceTableView.frame = self.tableFrame;
            self.datePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
            self.timePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 116.0f);
        }];
        self.timeTableViewVisible = @"Yes";
    } else {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 450)];
        [UIView animateWithDuration:0.5f animations:^{
            self.timeTableView.frame = self.tableFrame;
        }];
        self.timeTableViewVisible = @"No";
    }
}
@end
