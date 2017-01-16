//
//  AcceptViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/16/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "Reachability.h"

// Protocol definition starts here
@protocol AcceptDelegate <NSObject>
@required
- (void) track:(NSDictionary *)response;
- (void) payment:(NSDictionary *)response;
@end

@interface AcceptViewController : UIViewController
{
    // Delegate to respond back
    id <AcceptDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
@property (strong, nonatomic) NSMutableArray *tableData;
@property UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UIView *poupView;
@property (strong, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) IBOutlet UIButton *acceptAndPayButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptAndTrackButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property NSInteger index;

-(IBAction)acceptTrack:(id)sender;
-(IBAction)acceptPay:(id)sender;
- (IBAction)cancel:(id)sender;
@end
