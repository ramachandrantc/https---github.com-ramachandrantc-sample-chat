//
//  ProfileViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/12/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.emailValidator = [SHEmailValidator validator];
    
    self.title = @"PROFILE";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.locations = [[NSMutableArray alloc] init];
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center = self.view.center;
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
    
    url = [urlDictionary objectForKey:@"show_details"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *post = [NSString stringWithFormat:@"cust_id=%@", [defaults objectForKey:@"cust_id"]];
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"Success"]) {
            NSDictionary *data = [response objectForKey:@"response"];
            self.name.text = [data objectForKey:@"customer"];
            self.email.text = [data objectForKey:@"email"];
            self.mobile.text = [data objectForKey:@"mobile_num"];
            self.building.text = [data objectForKey:@"building"];
            self.apartment.text = [data objectForKey:@"apartment"];
            self.address.text = [data objectForKey:@"address"];
            [self.location setTitle:[data objectForKey:@"city"] forState:UIControlStateNormal];
            self.selectedLocation = [[data objectForKey:@"location_id"] integerValue];
            
            NSURL *imageURL = [NSURL URLWithString:[data objectForKey:@"org_image"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            [self.profileImage setImage:[UIImage imageWithData:imageData]];
            self.profileImage.layer.cornerRadius = 50.0f;
            self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
            self.profileImage.layer.borderWidth = 3.0f;
            self.profileImage.clipsToBounds = YES;
            
            [self.scrollView setHidden:NO];
            
            NSString *url = [urlDictionary objectForKey:@"request_link"];
            [[[Network alloc] init] GETBlockWebservicewithParameters:@"" URL:url  block:^(NSDictionary * response) {
                NSLog(@"%@", response);
                
                if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
                    self.locations = [response objectForKey:@"locations"];
                    NSDictionary *dict = [self.locations objectAtIndex:0];
                    [self.location setTitle:[dict objectForKey:@"location_name_english"] forState:UIControlStateNormal];
                    [self.locationTable reloadData];
                    
                    int i = 0;
                    for (NSDictionary *dict in self.locations) {
                        if([[dict objectForKey:@"loc_id"] integerValue] == self.selectedLocation) {
                            self.selectedLocation = i;
                        }
                        i++;
                    }
                } else {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                      message:[response objectForKey:@"message"]
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                }
            }];
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
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [menu setImage:[UIImage imageNamed:@"menu_bar.png"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.profileImage.layer.cornerRadius = 50.0f;
    self.updateButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.updateButton.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.updateButton.layer setShadowOpacity:1.0];
    [self.updateButton.layer setShadowRadius:1.0];
    [self.updateButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterFromKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.activityView.center = self.view.center;
    self.tableFrame = self.locationTable.frame;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 600.0f)];
}

- (IBAction)toggleMenu:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        nil;
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)update:(id)sender {
    NSError *error;
    [self.emailValidator validateSyntaxOfEmailAddress:self.email.text withError:&error];
    
    if([[self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || [self.name.text isEqualToString:@""] || [self.name.text isEqualToString:@""] || [self.apartment.text isEqualToString:@""] || [self.mobile.text isEqualToString:@""] || [self.building.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"Please fill all mandatory fields."
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
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
            [_params setObject:[defaults objectForKey:@"cust_id"] forKey:@"id"];
            [_params setObject:self.name.text forKey:@"name"];
            [_params setObject:self.email.text forKey:@"email"];
            [_params setObject:self.mobile.text forKey:@"mob"];
            [_params setObject:self.address.text forKey:@"address"];
            [_params setObject:self.building.text forKey:@"building"];
            [_params setObject:self.apartment.text forKey:@"apartment"];
            
            NSDictionary *loc = [self.locations objectAtIndex:self.selectedLocation];
            
            [_params setObject:[loc objectForKey:@"loc_id"] forKey:@"loc_id"];
            [_params setObject:[loc objectForKey:@"location_name_english"] forKey:@"city"];
            
            Network *network = [[Network alloc] init];
            NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
            NSString *url = [urlDictionary objectForKey:@"edit_profile"];
            self.image = self.profileImage.image;
            
            [network POSTBlockWebservicewithImageParameters:_params image:self.image URL:url  block:^(NSDictionary * response) {
                NSLog(@"%@", [response objectForKey:@"response"]);
                [self.activityView stopAnimating];
                if([[response objectForKey:@"status"] isEqualToString: @"Success"]) {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                      message:@"Profile data updated successfully."
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                } else if([[response objectForKey:@"status"] isEqualToString: @"Failure"]) {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                      message:[response objectForKey:@"response"]
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                } else {
                    self.flag = @"error";
                }
            }];
        }
    }
}

- (IBAction)changepassword:(id)sender {
    if(self.passordViewController == nil) {
        self.passordViewController = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController" bundle:nil];
    }
    
    [self addChildViewController:self.passordViewController];
    self.passordViewController.view.frame = self.view.frame;
    [self.view addSubview:self.passordViewController.view];
    self.passordViewController.view.alpha = 0;
    [self.passordViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         self.passordViewController.view.alpha = 1;
     }
                     completion:nil];
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

- (IBAction)uploadPhoto:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Choose"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Camera", @"Gallery", nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if  ([buttonTitle isEqualToString:@"Camera"]) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.pickerController = pickerController;
            [self.menuContainerViewController presentViewController:self.pickerController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera Available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        }
    }
    if ([buttonTitle isEqualToString:@"Gallery"]) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        self.pickerController = pickerController;
        [self.menuContainerViewController presentViewController:self.pickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.profileImage setImage:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
