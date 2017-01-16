//
//  PaymentTableViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/7/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "PaymentTableViewController.h"

@interface PaymentTableViewController ()

@end

@implementation PaymentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PAYMENT";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=self.view.center;
    [self.view bringSubviewToFront:self.activityView];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"payment"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *post = [NSString stringWithFormat:@"cust_id=%@", [defaults objectForKey:@"cust_id"]];
    
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            self.data = [response objectForKey:@"accepted_services"];
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
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PaymentTableViewCell";
    
    PaymentTableViewCell *cell = (PaymentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *dict = [self.data objectAtIndex:indexPath.row];
    cell.jobID.text = [NSString stringWithFormat:@"Job ID : %@", [dict objectForKey:@"unique_reqid"]];
    cell.message.text = [dict objectForKey:@"message"];
    cell.amount.text = [NSString stringWithFormat:@"%@ AED", [dict objectForKey:@"amount"]];
    [cell.paymentButton setTag:indexPath.row];
    [cell.paymentButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)pay:(UIButton *)sender{
    NSDictionary *dict = [self.data objectAtIndex:sender.tag];
        
    int randomNumber = (arc4random() % 9999999) + 1;
    
    CCWebViewController* controller = [[CCWebViewController alloc] initWithNibName:@"CCWebViewController" bundle:nil];
    
    controller.accessCode = @"AVLN02DG40BL54NLLB";
    controller.merchantId = @"43629";
    controller.amount = [dict objectForKey:@"amount"];
    controller.accept_id = [dict objectForKey:@"accept_id"];
    controller.currency = @"AED";
    controller.orderId = [NSString stringWithFormat:@"%d",randomNumber];
    controller.redirectUrl = @"http://handychecks.com/RSA/ccavResponseHandler.php";
    controller.cancelUrl = @"http://handychecks.com/RSA/ccavResponseHandler.php";
    controller.rsaKeyUrl = @"http://handychecks.com/RSA/GetRSA.php";
    
    [self.navigationController pushViewController:controller animated:YES];
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
