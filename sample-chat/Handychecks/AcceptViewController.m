//
//  AcceptViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/16/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "AcceptViewController.h"

@interface AcceptViewController ()

@end

@implementation AcceptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=self.view.center;
    [self.view bringSubviewToFront:self.activityView];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
    
    self.poupView.layer.cornerRadius = 8;    
    
    self.acceptAndPayButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.acceptAndPayButton.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.acceptAndPayButton.layer setShadowOpacity:1.0];
    [self.acceptAndPayButton.layer setShadowRadius:1.0];
    [self.acceptAndPayButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.acceptAndTrackButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.acceptAndTrackButton.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.acceptAndTrackButton.layer setShadowOpacity:1.0];
    [self.acceptAndTrackButton.layer setShadowRadius:1.0];
    [self.acceptAndTrackButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.cancelButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.cancelButton.layer setShadowColor:[UIColor colorWithRed:(62.0/255) green:(102.0/255) blue:(16.0/255) alpha:1].CGColor];
    [self.cancelButton.layer setShadowOpacity:1.0];
    [self.cancelButton.layer setShadowRadius:1.0];
    [self.cancelButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
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

-(IBAction)acceptPay:(id)sender {
    NSDictionary *dict = [self.tableData objectAtIndex:self.index];
    
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"direct_payment"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *post = [NSString stringWithFormat:@"cust_id=%@&req_id=%@", [defaults objectForKey:@"cust_id"], [dict objectForKey:@"id"]];
    
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            [self.delegate payment:response];
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
             {
                 self.view.alpha = 0;
             }
                             completion:^(BOOL finished)
             {
                 [self.view removeFromSuperview];
             }];
            [self.view removeFromSuperview];
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

-(IBAction)acceptTrack:(id)sender {
    NSDictionary *dict = [self.tableData objectAtIndex:self.index];
    [self.activityView startAnimating];
    
    NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"customer_accepted"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *post = [NSString stringWithFormat:@"cust_id=%@&accpt_id=%@", [defaults objectForKey:@"cust_id"], [dict objectForKey:@"id"]];
    
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        [self.activityView stopAnimating];
        NSLog(@"%@", response);
        
        if([[response objectForKey:@"status"] isEqualToString: @"success"]) {
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
             {
                 self.view.alpha = 0;
             }
                             completion:^(BOOL finished)
             {
                 [self.view removeFromSuperview];
             }];
            [self.view removeFromSuperview];
            [self.delegate track:response];
        } else if([[response objectForKey:@"status"] isEqualToString: @"Failure"]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:[response objectForKey:@"status"]
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
