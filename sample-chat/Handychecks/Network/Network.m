//
//  Network.m
//  WebService NEW
//
//  Created by NikhilRaj on 10/18/14.
//  Copyright (c) 2014 NikhilRaj. All rights reserved.
//

#import "Network.h"

@implementation Network
@synthesize delegate;

- (Network*)init {
         callbacks = [[NSMutableDictionary alloc] init];
         return self;
     
}
- (void)POSTBlockWebservicewithParameters:(NSString *)params  URL:(NSString *)url block:(void (^)(NSDictionary * response))blck {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];    
    
    NSURLConnection *conn = [[NSURLConnection alloc]
                             initWithRequest: request delegate:self];
    StateObject* connectionState = [[StateObject alloc] init];
    connectionState.receivedData = [[NSMutableData alloc] init];
    [connectionState.receivedData setLength:0];
    connectionState.callbackBlock = blck;
    [callbacks setValue:connectionState forKey:[NSString stringWithFormat:@"%lu", (unsigned long)conn.hash]];
    

}

- (void)POSTBlockWebservicewithJsonParameters:(NSString *)params  URL:(NSString *)url block:(void (^)(NSDictionary * response))blck {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[params length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *conn = [[NSURLConnection alloc]
                             initWithRequest: request delegate:self];
    StateObject* connectionState = [[StateObject alloc] init];
    connectionState.receivedData = [[NSMutableData alloc] init];
    [connectionState.receivedData setLength:0];
    connectionState.callbackBlock = blck;
    [callbacks setValue:connectionState forKey:[NSString stringWithFormat:@"%lu", (unsigned long)conn.hash]];
    
    
}
- (void)POSTBlockWebservicewithImageParameters:(NSMutableDictionary *)params image:(UIImage *)img  URL:(NSString *)url block:(void (^)(NSDictionary *response))blck {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"YOUR_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(img, 0.1f);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    //[request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest: request delegate:self];
    
    StateObject* connectionState = [[StateObject alloc] init];
    connectionState.receivedData = [[NSMutableData alloc] init];
    [connectionState.receivedData setLength:0];
    connectionState.callbackBlock = blck;
    [callbacks setValue:connectionState forKey:[NSString stringWithFormat:@"%lu", (unsigned long)conn.hash]];
    
}
- (void)GETBlockWebservicewithParameters:(NSString *)params  URL:(NSString *)url  block:(void (^)(NSDictionary *response))blck {

    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,params]];
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:URL
                                                                   cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSURLConnection *conn = [[NSURLConnection alloc]
                             initWithRequest: theRequest delegate:self];
    StateObject* connectionState = [[StateObject alloc] init];
    connectionState.receivedData = [[NSMutableData alloc] init];
    [connectionState.receivedData setLength:0];
    connectionState.callbackBlock = blck;
    [callbacks setValue:connectionState forKey:[NSString stringWithFormat:@"%lu", (unsigned long)conn.hash]];


}
-(void)connection:(NSConnection*)conn didReceiveResponse: (NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData: (NSData *)data
{
   // NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //  NSLog(@"%@",responseString);
    StateObject* connectionState = [callbacks objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)connection.hash]];
    [connectionState.receivedData appendData:data];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:
(NSError *)error
{
   
    
    
    NSString* connectionHash = [NSString stringWithFormat:@"%lu", (unsigned long)connection.hash];
     StateObject* connectionState = [callbacks objectForKey:connectionHash];
     NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:connectionState.receivedData
                          options:kNilOptions
                          error:nil];
     connectionState.callbackBlock(json);
    
    [callbacks removeObjectForKey:connectionHash];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* connectionHash = [NSString stringWithFormat:@"%lu", (unsigned long)connection.hash];
  //  NSLog(@"%@",connectionHash);
    StateObject* connectionState = [callbacks objectForKey:connectionHash];
    
    
    
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:connectionState.receivedData
                          options:kNilOptions
                          error:nil];
    connectionState.callbackBlock(json);
    [delegate uploadComplete:self];
    [callbacks removeObjectForKey:connectionHash];

}


@end
