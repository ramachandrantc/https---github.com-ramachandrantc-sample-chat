//
//  ServicesViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/8/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "ServicesViewController.h"

@interface ServicesViewController ()

@end

@implementation ServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"SERVICES";
    
    self.filters.layer.cornerRadius = 4;
    
    // drop shadow
    [self.filters.layer setShadowColor:[UIColor colorWithRed:(154.0/255) green:(154.0/255) blue:(154.0/255) alpha:1].CGColor];
    [self.filters.layer setShadowOpacity:0.8];
    [self.filters.layer setShadowRadius:1.0];
    [self.filters.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.optionButton.layer.cornerRadius = 4.0f;
    
    self.options = [[NSMutableArray alloc] init];
    NSMutableDictionary *optionDict = [[NSMutableDictionary alloc] init];
    [optionDict setObject:@"1" forKey:@"id"];
    [optionDict setObject:@"Active" forKey:@"name"];
    [self.options addObject:optionDict];
    
    optionDict = [[NSMutableDictionary alloc] init];
    [optionDict setObject:@"0" forKey:@"id"];
    [optionDict setObject:@"Awarded" forKey:@"name"];
    [self.options addObject:optionDict];
    
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
    
    self.filters.delegate = self;
    self.filters.dataSource = self;
    self.services.delegate = self;
    self.services.dataSource = self;
    
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"all_jobs"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *post = [NSString stringWithFormat:@"cust_id=%@&selected_id=%@", [defaults objectForKey:@"cust_id"], @"1"];
    
    self.selectedOption = @"1";
    [self.option setText:@"Active"];
    
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            self.activeData = [response objectForKey:@"jobs"];
            [self.services reloadData];
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                              message:@"Something went wrong. Please try again later.."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }];
    
    post = [NSString stringWithFormat:@"cust_id=%@&selected_id=%@", [defaults objectForKey:@"cust_id"], @"0"];
    
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            self.acceptedData = [response objectForKey:@"jobs"];
            [self.services reloadData];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [menu setImage:[UIImage imageNamed:@"menu_bar.png"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    self.navigationItem.leftBarButtonItem = menuButton;
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
    NSInteger count;
    if(tableView == self.filters) {
        count = 2;
    } else {
        if([self.selectedOption isEqualToString:@"1"]) {
            count = [self.activeData count];
        } else {
            count = [self.acceptedData count];
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == self.filters) {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        NSDictionary *dict = [self.options objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict objectForKey:@"name"];
    } else {
        static NSString *CellIdentifier = @"ServicesTableViewCell";
    
        ServicesTableViewCell *cell1 = (ServicesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"ServicesTableViewCell" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        NSDictionary *dict1;
        if([self.selectedOption isEqualToString:@"1"]) {
            dict1 = [self.activeData objectAtIndex:indexPath.row];
            NSURL *imageURL = [NSURL URLWithString:[dict1 objectForKey:@"service_image"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            [cell1.image setImage:[UIImage imageWithData:imageData]];
            [cell1.jobID setText:[NSString stringWithFormat:@"Job ID : %@", [dict1 objectForKey:@"unique_reqid"]]];
            [cell1.service setText:[dict1 objectForKey:@"service_name"]];
            NSString *count = [NSString stringWithFormat:@"%ld", [[dict1 objectForKey:@"count_of_applications"] integerValue]];
            [cell1.applied setText:count];
        } else {
            dict1 = [self.acceptedData objectAtIndex:indexPath.row];
            NSURL *imageURL = [NSURL URLWithString:[dict1 objectForKey:@"service_image"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            [cell1.image setImage:[UIImage imageWithData:imageData]];
            
            [cell1.jobID setText:[NSString stringWithFormat:@"Job ID : %@", [dict1 objectForKey:@"unique_reqid"]]];
            [cell1.service setText:[dict1 objectForKey:@"service_name"]];
            NSString *count = [NSString stringWithFormat:@"%ld", [[dict1 objectForKey:@"count_of_applications"] integerValue]];
            [cell1.applied setText:count];
            
            [cell1.cellView setBackgroundColor:[UIColor orangeColor]];
        }
        cell1.image.layer.cornerRadius = 35.0f;
        cell1.image.clipsToBounds = YES;
        cell1.applied.layer.cornerRadius = 15.0f;
        cell1.applied.clipsToBounds = YES;
        cell = cell1;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.filters) {
        NSDictionary *dict = [self.options objectAtIndex:indexPath.row];
        self.selectedOption = [dict objectForKey:@"id"];
        [self.option setText:[dict objectForKey:@"name"]];
        [self.filters setHidden:YES];
        [self.services reloadData];
    } else {
        if([self.selectedOption isEqualToString:@"1"]) {
            NSDictionary *dict = [self.activeData objectAtIndex:indexPath.row];
            ActiveNotificationTableViewController *active = [[ActiveNotificationTableViewController alloc] initWithNibName:@"ActiveNotificationTableViewController" bundle:nil];
            active.reqId = [dict objectForKey:@"request_id"];
            /*active.providerId = ;
            active.providerName = ;
            active.imageUrl = [dict1 objectForKey:@"service_image"];*/
            [self.navigationController pushViewController:active animated:YES];
        } else {
            NSDictionary *dict = [self.acceptedData objectAtIndex:indexPath.row];
            AwardedNotificationTableViewController *awarded = [[AwardedNotificationTableViewController alloc] initWithNibName:@"AwardedNotificationTableViewController" bundle:nil];
            awarded.reqId = [dict objectForKey:@"request_id"];
            /*awarded.providerId = ;
            awarded.providerName = ;
            awarded.imageUrl = ;*/
            [self.navigationController pushViewController:awarded animated:YES];
        }
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

- (IBAction)filter:(id)sender {
    if([self.filters isHidden]) {
        [self.filters setHidden:NO];
    } else {
        [self.filters setHidden:YES];
    }
}
@end
