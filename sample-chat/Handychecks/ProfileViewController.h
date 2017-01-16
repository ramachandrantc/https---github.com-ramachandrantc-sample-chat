//
//  ProfileViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/12/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "SHEmailValidator.h"
#import "SHAutocorrectSuggestionView.h"
#import "Reachability.h"
#import "MFSideMenu/MFSideMenu.h"
#import "PasswordViewController.h"

@interface ProfileViewController : UIViewController<UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIImagePickerController *pickerController;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *email;
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
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (strong, nonatomic) IBOutlet UITableView *locationTable;
@property (nonatomic, strong) SHAutocorrectSuggestionView *suggestionView;
@property (nonatomic, strong) SHEmailValidator *emailValidator;
@property UIImage *image;
@property PasswordViewController *passordViewController;

- (IBAction)update:(id)sender;
- (IBAction)changepassword:(id)sender;
- (IBAction)changeLocation:(id)sender;
- (IBAction)uploadPhoto:(id)sender;

@end
