//
//  CoreUtility.m
//  Street Voter
//
//  Created by NikhilRaj on 9/17/14.
//  Copyright (c) 2014 NikhilRaj. All rights reserved.
//

#import "CoreUtility.h"
#import "Reachability.h"
@implementation CoreUtility

+(BOOL)validateEmailAddress:(NSString*)emailAddress{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:emailAddress]){
        return TRUE;
    }
    return FALSE;
    
}

+(BOOL)checkNetworkConnection{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    [Reachability reachabilityWithHostname:@"https://www.google.co.in/"];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - AlertView
+ (void)Alert:(NSString *)message withDelegate:(id)delegate{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}
+ (void)AlertWithTitle:(NSString *)title withMessage:(NSString *)message withDelegate:(id)delegate{
    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert1 show];
}


@end
