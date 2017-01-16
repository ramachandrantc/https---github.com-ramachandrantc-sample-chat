//
//  RateViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/9/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "Network/Network.h"
#import "SHEmailValidator.h"
#import "SHAutocorrectSuggestionView.h"
#import "Reachability.h"
#import "MFSideMenuContainerViewController.h"
#import "AllCommentsTableViewController.h"

// Protocol definition starts here
@protocol RateDelegate <NSObject>
@required
- (void) processCompleted:(NSInteger)index;
@end

@interface RateViewController : UIViewController<EDStarRatingProtocol>
{
    // Delegate to respond back
    id <RateDelegate> _delegate;
}

@property (nonatomic,strong) id delegate;
@property (strong, nonatomic) NSString *request_id;
@property (strong, nonatomic) NSString *provider_id;
@property (strong, nonatomic) IBOutlet UIView *rateView;
@property (strong, nonatomic) IBOutlet UITextView *comment;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) NSMutableArray *data;
@property UIActivityIndicatorView *activityView;
@property NSInteger index;

@property (weak, nonatomic) IBOutlet EDStarRating *starRating;
@property (weak, nonatomic) IBOutlet EDStarRating *starRatingImage;
-(IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;
@end
