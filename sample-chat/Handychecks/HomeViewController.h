//
//  HomeViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/6/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "ServiceRequestViewController.h"

@interface HomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *getStartedButton;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)getStarted:(id)sender;
- (IBAction)close:(id)sender;
@end
