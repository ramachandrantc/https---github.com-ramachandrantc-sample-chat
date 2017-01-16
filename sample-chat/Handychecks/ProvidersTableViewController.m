//
//  ProvidersTableViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/8/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "ProvidersTableViewController.h"

@interface ProvidersTableViewController ()

@end

@implementation ProvidersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"PROVIDERS LIST";
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=self.view.center;
    [self.view bringSubviewToFront:self.activityView];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"providers_list"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *post = [NSString stringWithFormat:@"custid=%@", [defaults objectForKey:@"cust_id"]];
    
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            self.data = [response objectForKey:@"response"];
            [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProviderTableViewCell";
    
    ProviderTableViewCell *cell = (ProviderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"ProviderTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *dict = [self.data objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[dict objectForKey:@"profile_image"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [cell.image setImage:[UIImage imageWithData:imageData]];
    cell.image.layer.cornerRadius = 10.0;
    cell.serviceID.text = [dict objectForKey:@"jobid"];
    cell.provider.text = [dict objectForKey:@"service_provider"];
    cell.status.text = [dict objectForKey:@"job_status"];
    
    [cell.rateButton setTag:indexPath.row];
    [cell.rateButton addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.image.layer.cornerRadius = 25.0f;
    cell.image.clipsToBounds = YES;
    cell.image.layer.borderWidth = 2.0f;
    cell.image.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    return cell;
}

-(void)review:(UIButton *)sender {
    if(self.rate == nil) {
        self.rate = [[RateViewController alloc] initWithNibName:@"RateViewController" bundle:nil];
        self.rate.delegate = self;
    }
    NSDictionary *dict = [self.data objectAtIndex:sender.tag];
    self.rate.request_id = [dict objectForKey:@"request_id"];
    self.rate.provider_id = [dict objectForKey:@"provider_id"];
    [self.rate.submitButton setTag:sender.tag];
    self.rate.data = self.data;
    self.rate.index = sender.tag;
    [self addChildViewController:self.rate];
    self.rate.view.frame = self.view.frame;
    [self.view addSubview:self.rate.view];
    [self.view bringSubviewToFront:self.rate.view];
    self.rate.view.alpha = 0;
    [self.rate didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         self.rate.view.alpha = 1;
     }
                     completion:nil];
}

- (void) processCompleted:(NSInteger)index {
    NSDictionary *dict = [self.data objectAtIndex:index];
    AllCommentsTableViewController *allComments = [[AllCommentsTableViewController alloc] initWithNibName:@"AllCommentsTableViewController" bundle:nil];
    allComments.imageUrl = [dict objectForKey:@"profile_image"];
    allComments.providerName = [dict objectForKey:@"service_provider"];
    allComments.providerId = [dict objectForKey:@"provider_id"];
    [self.navigationController pushViewController:allComments animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
