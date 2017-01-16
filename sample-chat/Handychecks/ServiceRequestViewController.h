//
//  ServiceRequestViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/8/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "SHEmailValidator.h"
#import "SHAutocorrectSuggestionView.h"
#import "Reachability.h"
#import "MFSideMenu/MFSideMenu.h"
#import "HomeViewController.h"

@interface ServiceRequestViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *service;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextField *jobDescription;
@property (strong, nonatomic) IBOutlet UIButton *serviceButton;
@property (strong, nonatomic) IBOutlet UIButton *hourButton;
@property (strong, nonatomic) IBOutlet UIButton *countryButton;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UIButton *requestButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *serviceTableView;
@property (strong, nonatomic) IBOutlet UITableView *timeTableView;
@property (strong, nonatomic) IBOutlet UITableView *locationTableView;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *services;
@property (strong, nonatomic) NSMutableArray *times;
@property (strong, nonatomic) NSMutableArray *tableData;
@property UIActivityIndicatorView *activityView;
@property UIBarButtonItem *doneButton;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property NSString *flag;
@property NSString *jobAmount;

@property NSInteger selectedLocation;
@property NSInteger selectedTime;
@property NSInteger selectedService;

@property CGRect tableFrame;
@property NSString *serviceTableViewVisible;
@property NSString *timeTableViewVisible;
@property NSString *locationTableViewVisible;

- (IBAction)selectDate:(id)sender;
- (IBAction)selectTime:(id)sender;
- (IBAction)confirm:(id)sender;
- (IBAction)request:(id)sender;
- (IBAction)changeLocation:(id)sender;
- (IBAction)changeService:(id)sender;
- (IBAction)changeJobHours:(id)sender;
@end
