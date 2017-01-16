//
//  CoreUtility.h
//  Street Voter
//
//  Created by NikhilRaj on 9/17/14.
//  Copyright (c) 2014 NikhilRaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreUtility : NSObject
+(BOOL)validateEmailAddress:(NSString*)emailAddress;
+(BOOL)checkNetworkConnection;
+ (void)Alert:(NSString *)message withDelegate:(id)delegate;
+ (void)AlertWithTitle:(NSString *)title withMessage:(NSString *)message withDelegate:(id)delegate;

@end
