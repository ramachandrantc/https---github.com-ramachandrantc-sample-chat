//
//  AllCommentsTableViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/13/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "AllCommentsTableViewController.h"

@interface AllCommentsTableViewController ()

@end

@implementation AllCommentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = @"PROVIDERS COMMENTS";
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=self.view.center;
    [self.view bringSubviewToFront:self.activityView];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"all_comments"];
    NSString *post = [NSString stringWithFormat:@"provider_id=%@", self.providerId];
    
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            
            NSDictionary *dict = [response objectForKey:@"response"];
            self.data = [dict objectForKey:@"result"];
            NSDictionary *review = [dict objectForKey:@"Ratingscount"];
            self.reviewCount = [review objectForKey:@"Ratingscount"];
            NSDictionary *rating = [dict objectForKey:@"Reviewscount"];
            self.ratingCount = [rating objectForKey:@"Reviewscount"];
            NSDictionary *avgRating = [dict objectForKey:@"AverageRating"];
            self.avgRating = [avgRating objectForKey:@"AverageRating"];
            
            if([self.imageUrl isEqualToString:@""]) {
                NSDictionary *pd = [self.data objectAtIndex:0];
                self.imageUrl = [pd objectForKey:@"provider_image"];
                self.providerName = [pd objectForKey:@"service_provider"];
            }
            
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
    return ([self.data count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell1;
    if(indexPath.row == 0) {
        static NSString *CellIdentifier = @"CommentHeaderTableViewCell";
        
        CommentHeaderTableViewCell *cell = (CommentHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"CommentHeaderTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if(![self.providerName isEqualToString:@""]) {
            NSURL *imageURL = [NSURL URLWithString:self.imageUrl];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            [cell.image setImage:[UIImage imageWithData:imageData]];
            cell.image.layer.cornerRadius = 50.0;
            cell.provider.text = self.providerName;
            cell.image.clipsToBounds = YES;
            cell.image.layer.borderWidth = 2.0f;
            cell.image.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            cell.starRating.rating = [self.avgRating floatValue];
            
            cell.commentNo.text = [NSString stringWithFormat:@"%@ Customer reviews", self.ratingCount];
            cell.reviewNo.text = [NSString stringWithFormat:@"%@ Comments", self.reviewCount];
        }
        cell1 = cell;
    } else {
        NSDictionary *dict = [self.data objectAtIndex:(indexPath.row - 1)];
        static NSString *CellIdentifier = @"CommentTableViewCell";
        
        CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSURL *imageURL = [NSURL URLWithString:[dict objectForKey:@"customer_image"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        [cell.image setImage:[UIImage imageWithData:imageData]];
        cell.image.layer.cornerRadius = 25.0f;
        cell.image.clipsToBounds = YES;
        cell.image.layer.borderWidth = 2.0f;
        cell.image.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        cell.customer.text = [dict objectForKey:@"customer"];
        cell.dateTime.text = [dict objectForKey:@"created_date"];
        cell.jobID.text = [dict objectForKey:@"unique_reqid"];
        cell.comment.text = [dict objectForKey:@"reviews"];
        cell.reply.text = [dict objectForKey:@"replied"];
        cell.provider.text = [dict objectForKey:@"service_provider"];
        cell.starRating.rating = [[dict objectForKey:@"ratings"] floatValue];
        
        if([[dict objectForKey:@"replied"] isEqualToString:@""]) {
            [cell.replyImage setHidden:YES];
            [cell.provider setHidden:YES];
            [cell.reply setHidden:YES];
        }
        
        cell1 = cell;
    }
    return cell1;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    if (indexPath.row == 0) {
        height = 298;
    } else {
        height = 175;
    }
    
    return height;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
