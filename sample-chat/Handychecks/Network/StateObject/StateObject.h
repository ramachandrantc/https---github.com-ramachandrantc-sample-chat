//
//  StateObject.h
//  WebService NEW
//
//  Created by NikhilRaj on 10/18/14.
//  Copyright (c) 2014 NikhilRaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateObject : NSObject
    @property (nonatomic, copy) void (^ callbackBlock)(NSDictionary *response);
    @property (nonatomic, retain) NSMutableData* receivedData;
@end
