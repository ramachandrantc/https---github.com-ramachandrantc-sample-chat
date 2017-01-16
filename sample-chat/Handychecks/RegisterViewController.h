//
//  RegisterViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 11/30/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "SHEmailValidator.h"
#import "SHAutocorrectSuggestionView.h"
#import "Reachability.h"

@interface RegisterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *registerForm;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *mobile;
@property (strong, nonatomic) IBOutlet UITextField *building;
@property (strong, nonatomic) IBOutlet UITextField *apartment;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UIButton *location;
@property UIActivityIndicatorView *activityView;
@property NSMutableArray *locations;
@property CGRect tableFrame;
@property NSString *tableVisible;
@property NSInteger selectedLocation;
@property NSString *flag;

@property (nonatomic, strong) SHAutocorrectSuggestionView *suggestionView;
@property (nonatomic, strong) SHEmailValidator *emailValidator;
@property (strong, nonatomic) IBOutlet UITableView *locationTable;

- (IBAction)signup:(id)sender;
- (IBAction)changeLocation:(id)sender;
@end
