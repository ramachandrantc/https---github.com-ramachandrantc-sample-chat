//
//  Network.h
//  WebService NEW
//
//  Created by NikhilRaj on 10/18/14.
//  Copyright (c) 2014 NikhilRaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StateObject.h"

@class Network;

// define the protocol for the delegate
@protocol NetworkDelegate

// define protocol functions that can be used in any class using this delegate
-(void)uploadComplete:(Network *)customClass;

@end

@interface Network : NSObject<NSURLConnectionDataDelegate>{


    NSMutableData* _receivedData;
    NSMutableDictionary* callbacks;


}
@property (nonatomic, assign) id  delegate;

typedef void (^Completionhandler)();


- (Network *)init;

- (void)POSTBlockWebservicewithParameters:(NSString *)params  URL:(NSString *)url block:(void (^)(NSDictionary *response))blck ;
- (void)POSTBlockWebservicewithJsonParameters:(NSString *)params  URL:(NSString *)url block:(void (^)(NSDictionary *response))blck ;
- (void)POSTBlockWebservicewithImageParameters:(NSMutableDictionary *)params image:(UIImage *)img  URL:(NSString *)url block:(void (^)(NSDictionary *response))blck ;

- (void)GETBlockWebservicewithParameters:(NSString *)params  URL:(NSString *)url  block:(void (^)(NSDictionary *response))blck ;

@end
