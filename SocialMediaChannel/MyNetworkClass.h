//
//  MyNetworkClass.h
//
//  Created by Ashish Agrawal on 22/12/14.
//  Copyright (c) 2014 Finoit Technologies (I) Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAX_TIME_TO_WAIT_FOR_IMAGE 120.0 
typedef enum
{
    Get =1,
    POST,
    PUT,
    Delete, 
}RequestType;

#define getJobPackageList @"jobpackage"
#define User @"User/"
#define changePassword @"User/changepassword"
#define JobPackageDetails  @"jobpackage/"
#define JobPackageMarkDownload @"jobpackage/%@/markdownloaded"
#define JobPackageMarkComplete(jobId) @"jobpackage/(jobId)/markcompleted"

#define ImageID(imgID) @"GET/Image/(imgID)"
#define ImageIDDown(imgID) @"GET/Image/(imgID)/download"
#define PictureID(picID) @"GET/Picture/(picID)"
#define PictureIDDown(picID) @"GET/Picture/(picID)/download"
#define POSTRecommPackage @"POST/RecommendationPackage"
#define POSTPict @"POST/Picture"
#define UploadPic(picID) @"POST/Picture/(picID)/upload"
#define RecommPackDelCheck @"GET/RecommendationPackageDeleteCheck"

@interface MyNetworkClass : NSObject{
    NSMutableData *webData;
}

+(void)responseWithUrl:(NSString *)url postResponse:(NSDictionary *)parameter requestType:(RequestType)requestType tag:(NSString *)tag completetion:(void (^)(BOOL status,id responseObj, NSString *tag, NSError *error , NSInteger statusCode))completion;
+(void)uploadImageWithUrl:(NSString *)url withData:(NSData *)picData completetion:(void (^)(BOOL status,id responseObj, NSString *tag, NSError *error , NSInteger statusCode))completion;

@end
