//
//  MyNetworkClass.m
//
//  Copyright (c) 2014 Finoit Technologies (I) Pvt Ltd. All rights reserved.
//

#import "MyNetworkClass.h"
 
@implementation MyNetworkClass
+(void)responseWithUrl:(NSString *)url postResponse:(NSDictionary *)parameter requestType:(RequestType)requestType tag:(NSString *)tag completetion:(void (^)(BOOL status,id responseObj, NSString *tag, NSError *error , NSInteger statusCode))completion{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestManager.requestSerializer setValue:@"secret123" forHTTPHeaderField:@"ApiKey"];
    [requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accepts"];
    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_Url,url];
    NSString *urlString = @"";
    Dlog(@"REQUEST URL: %@",urlString);
    switch (requestType){
        case Get:{
            [requestManager GET:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
               // Dlog(@"RESPONSE: %@",responseObject);
                [operation.response statusCode];
                if([responseObject valueForKey:@"data"])
                completion(true,[responseObject valueForKey:@"data"],tag,nil,operation.response.statusCode);
                else
                completion(false,nil,tag,[responseObject valueForKey:@"errors"],operation.response.statusCode);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                completion(false,nil,tag,error,operation.response.statusCode);
            }];
            break;
        }
        case POST:{
            [requestManager POST:urlString  parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
               // Dlog(@"RESPONSE: %@",responseObject);

                if([responseObject valueForKey:@"data"])
                    completion(true,[responseObject valueForKey:@"data"],tag,nil,operation.response.statusCode);
                else
                    completion(false,nil,tag,[responseObject valueForKey:@"errors"],operation.response.statusCode);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                completion(false,nil,tag,error,operation.response.statusCode);
            }];
            break;
        }
        case PUT:{
            [requestManager PUT:urlString  parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                //Dlog(@"RESPONSE: %@",responseObject);

                if([responseObject valueForKey:@"data"])
                    completion(true,[responseObject valueForKey:@"data"],tag,nil,operation.response.statusCode);
                else
                    completion(false,nil,tag,[responseObject valueForKey:@"errors"],operation.response.statusCode);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                completion(false,nil,tag,error,operation.response.statusCode);
            }];
            break;
        }
        case Delete:{
            [requestManager DELETE:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
               // Dlog(@"RESPONSE: %@",responseObject);

                if([responseObject valueForKey:@"data"])
                    completion(true,[responseObject valueForKey:@"data"],tag,nil,operation.response.statusCode);
                else
                    completion(false,nil,tag,[responseObject valueForKey:@"errors"],operation.response.statusCode);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                completion(false,nil,tag,error,operation.response.statusCode);
            }];
            break;
        }
        default:
            break;
    }
}

+(void)uploadImageWithUrl:(NSString *)url withData:(NSData *)picData completetion:(void (^)(BOOL status,id responseObj, NSString *tag, NSError *error , NSInteger statusCode))completion{
    NSString *bytesArr = [picData base64Encoding];
    NSData *postData = [bytesArr dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"secret123" forHTTPHeaderField:@"ApiKey"];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(theConnection){
//        _webData = [[NSMutableData alloc] init];
    }
    else{
        NSLog(@"theConnection is NULL");
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    webData = [[NSMutableData alloc]init];
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mydata{
    [webData appendData:mydata];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"Did Fail with error");
    
    //UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Network Required" message:@"App.  requires an active internet connection to work .\nEDGE,3G and Wi-Fi are supported connection." delegate:nil cancelButtonTitle:@"Dismiss"  otherButtonTitles:nil,nil];
    //	[myAlertView show];
    //[myAlertView release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *returnString = [[NSString alloc] initWithData:webData encoding:NSASCIIStringEncoding];
    NSLog(@"Return String %@",returnString);
    if (webData) {
    }
}
- (NSData *)loadFileFromNetwork:(NSString *)url {
    // spawn a new thread to load the image in the background, from the network
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url ] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:MAX_TIME_TO_WAIT_FOR_IMAGE];
    [request setValue:@"secret123" forHTTPHeaderField:@"ApiKey"];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error == nil){
        // Parse data here
    }
    return data;
}
@end
