//
//  ActiveNotificationTableViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/15/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "ActiveNotificationTableViewController.h"

@interface ActiveNotificationTableViewController ()

@end

@implementation ActiveNotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"NOTIFICATIONS";
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=self.view.center;
    [self.view bringSubviewToFront:self.activityView];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"notification"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *post = [NSString stringWithFormat:@"cust_id=%@&req_id=%@", [defaults objectForKey:@"cust_id"], self.reqId];
    
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            self.tableData = [response objectForKey:@"notifications"];
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
    
    UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [iconButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *icon = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
    [iconButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = icon;
}

- (IBAction)search:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ActiveNotificationTableViewCell";
    
    ActiveNotificationTableViewCell *cell = (ActiveNotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"ActiveNotificationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *dict = [self.tableData objectAtIndex:indexPath.row];
    
    if([[dict objectForKey:@"count_rating"] integerValue] != 0) {
        cell.overallRating.text = [dict objectForKey:@"avg_rating"];
        cell.starRating.rating = [[dict objectForKey:@"avg_rating"] floatValue];
    }
    cell.title.text = [dict objectForKey:@"message"];
    cell.reviewCount.text = [NSString stringWithFormat:@"( %@ )", [dict objectForKey:@"count_rating"]];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(comments:)];
    [cell.starRating addGestureRecognizer:singleFingerTap];
    [cell.starRating addGestureRecognizer:singleFingerTap];
    
    [cell.acceptButton setTag:indexPath.row];
    [cell.acceptButton addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.acceptButton.layer.cornerRadius = 13.0;
    
    return cell;
}

- (void)comments:(UITapGestureRecognizer *)recognizer {
    NSDictionary *dict = [self.tableData objectAtIndex:[self.tableView indexPathForRowAtPoint:[recognizer locationInView:self.tableView]].row];
    AllCommentsTableViewController *allComments = [[AllCommentsTableViewController alloc] initWithNibName:@"AllCommentsTableViewController" bundle:nil];
    allComments.imageUrl = @"";
    allComments.providerName = @"";
    if([[dict objectForKey:@"count_rating"] integerValue] != 0) {
        allComments.providerId = [dict objectForKey:@"provider_id"];
        [self.navigationController pushViewController:allComments animated:YES];
    }
}

-(void)accept:(UIButton *)sender {
    if(self.accept == nil) {
        self.accept = [[AcceptViewController alloc] initWithNibName:@"AcceptViewController" bundle:nil];
        self.accept.delegate = self;
    }
    self.accept.tableData = self.tableData;
    NSDictionary *dict = [self.tableData objectAtIndex:sender.tag];
    [self.accept.message setText:[NSString stringWithFormat:@"%@ and will be at your house at desired time", [dict objectForKey:@"message"]]];
    
    [self addChildViewController:self.accept];
    self.accept.view.frame = self.view.frame;
    [self.view addSubview:self.accept.view];
    self.accept.view.alpha = 0;
    [self.accept didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         self.accept.view.alpha = 1;
     }
                     completion:nil];
}

- (void) payment:(NSDictionary *)response {
    int randomNumber = (arc4random() % 9999999) + 1;
    CCWebViewController* controller = [[CCWebViewController alloc] initWithNibName:@"CCWebViewController" bundle:nil];
    
    controller.accessCode = @"AVLN02DG40BL54NLLB";
    controller.merchantId = @"43629";
    controller.amount = [response objectForKey:@"amount"];
    controller.accept_id = [response objectForKey:@"accept_id"];
    controller.currency = @"AED";
    controller.orderId = [NSString stringWithFormat:@"%d",randomNumber];
    controller.redirectUrl = @"http://handychecks.com/RSA/ccavResponseHandler.php";
    controller.cancelUrl = @"http://handychecks.com/RSA/ccavResponseHandler.php";
    controller.rsaKeyUrl = @"http://handychecks.com/RSA/GetRSA.php";
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) track:(NSDictionary *)response {
    TrackViewController *track = [[TrackViewController alloc] initWithNibName:@"TrackViewController" bundle:nil];
    track.latitude = [response objectForKey:@"latitude"];;
    track.longitude = [response objectForKey:@"longitude"];
    track.address = [response objectForKey:@"address"];
    [self.navigationController pushViewController:track animated:YES];
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
