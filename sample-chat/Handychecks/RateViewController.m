//
//  RateViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/9/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "RateViewController.h"

@interface RateViewController ()

@end

@implementation RateViewController

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
    
    self.popupView.layer.cornerRadius = 6.0f;
    self.submitButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.submitButton.layer setShadowColor:[UIColor colorWithRed:(62.0/255) green:(102.0/255) blue:(16.0/255) alpha:1].CGColor];
    [self.submitButton.layer setShadowOpacity:1.0];
    [self.submitButton.layer setShadowRadius:1.0];
    [self.submitButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.cancelButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.cancelButton.layer setShadowColor:[UIColor colorWithRed:(62.0/255) green:(102.0/255) blue:(16.0/255) alpha:1].CGColor];
    [self.cancelButton.layer setShadowOpacity:1.0];
    [self.cancelButton.layer setShadowRadius:1.0];
    [self.cancelButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.comment setText:@""];
    _starRating.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.maxRating = 5.0;
    _starRating.delegate = self;
    _starRating.horizontalMargin = 15.0;
    _starRating.editable=YES;
    _starRating.rating= 2.5;
    _starRating.displayMode=EDStarRatingDisplayHalf;
    [_starRating  setNeedsDisplay];
    _starRating.tintColor = [UIColor orangeColor];
    [self starsSelectionChanged:_starRating rating:2.5];
    
    // Setup control using image
    _starRatingImage.backgroundImage=[UIImage imageNamed:@"starsbackground iOS.png"];
    _starRatingImage.starImage = [UIImage imageNamed:@"star.png"];
    _starRatingImage.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
    _starRatingImage.maxRating = 5.0;
    _starRatingImage.delegate = self;
    _starRatingImage.horizontalMargin = 12;
    _starRatingImage.editable=YES;
    _starRatingImage.rating= 2.5;
    _starRatingImage.displayMode=EDStarRatingDisplayAccurate;
    [self starsSelectionChanged:_starRatingImage rating:2.5];
    // This one will use the returnBlock instead of the delegate
    _starRatingImage.returnBlock = ^(float rating )
    {
        NSLog(@"ReturnBlock: Star rating changed to %.1f", rating);
        // For the sample, Just reuse the other control's delegate method and call it
        [self starsSelectionChanged:_starRatingImage rating:rating];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    //NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)submit:(id)sender {
    if([self.comment.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"Please enter comments."
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
            NSString *url = [urlDictionary objectForKey:@"add_rating"];
            
            NSDate *today = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormat stringFromDate:today];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *post = [NSString stringWithFormat:@"custid=%@&provider_rating=%f&provider_comment=%@&provider_id=%@&date=%@&request_id=%@", [defaults objectForKey:@"cust_id"], self.starRating.rating, self.comment.text, self.provider_id, dateString, self.request_id];
            
            [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
                [self.activityView stopAnimating];
                NSLog(@"%@", response);
                if([[response objectForKey:@"status"] isEqualToString: @"Success"]) {
                    [self.delegate processCompleted:self.index];
                    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
                     {
                         self.view.alpha = 0;
                     }
                                     completion:^(BOOL finished)
                     {
                         [self.view removeFromSuperview];
                     }];
                } else if([[response objectForKey:@"status"] isEqualToString: @"already_rated"]){
                    [self.view removeFromSuperview];
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                      message:@"Job already rated."
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                } else {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                      message:@"Something went wrong. Please try again.."
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                }
            }];
        }
    }
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
