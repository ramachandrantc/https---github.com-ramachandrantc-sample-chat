//
//  ForgotPasswordViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/2/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "SHEmailValidator.h"
#import "SHAutocorrectSuggestionView.h"

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *submitButon;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) SHAutocorrectSuggestionView *suggestionView;
@property (nonatomic, strong) SHEmailValidator *emailValidator;

- (IBAction)submit:(id)sender;
@end
