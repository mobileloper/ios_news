//
//  NetworkClass.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 31/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

public enum RequestType:  Int{
    case OPTIONS = 1
    case GET
    case HEAD
    case POST
    case PUT
    case PATCH
    case DELETE
    case TRACE
    case CONNECT

    func getMethodType()-> Method {
        switch self{
        case .GET:
            return Method.GET
        case .POST:
            return Method.POST
        case .HEAD:
            return Method.HEAD
        case .PUT:
            return Method.PUT
        case .PATCH:
            return Method.PATCH
        case .DELETE:
            return Method.DELETE
        case .TRACE:
            return Method.TRACE
        case .CONNECT:
            return Method.CONNECT
        case .OPTIONS:
            return Method.OPTIONS
        }
        
    }
}

let Base_Url : String = "http://jhopadi.com/social_media/public/api/feed/"

import Alamofire
class NetworkClass: NSObject {
    class func responseWithUrl(url : String , parameter :[String: AnyObject]?, requestType : RequestType , tagString: String?,completion: ((status:Bool, responseObj : JSON?, error : NSError?, statusCode : NSInteger? , tag : String ) -> Void)){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let headerDict : [String : String]? = ["ApiKey":"secret123"]
      
        
        let methodtype : Method = requestType.getMethodType()
        let updatedUrl = Base_Url+url
        let urlConvert : URLStringConvertible = updatedUrl
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        _ = dispatch_get_global_queue(qualityOfServiceClass, 0)
//        let queue = dispatch_queue_create("com.cnoon.manager-response-queue", DISPATCH_QUEUE_CONCURRENT)

        /* Use URl in case of https url string type append (application/x-www-form-urlencoded)  else use Json when body set as json parameter (application/json)
         we can validate status code , content type and mime type here using validate Closure */
        
//        Alamofire.request(methodtype, urlConvert , parameters:parameter, encoding: ParameterEncoding.JSON, headers: headerDict).response{ request, response, dataObj, error in
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//
//            var status =  response?.statusCode
//            let jsonObj : JSON = JSON(data: dataObj!)
//            
//            if CommonFunctions.isSuccessfullyDone(status).flag {
//                completion(status: true,responseObj: jsonObj ,error: nil,statusCode: status!, tag: tagString!)
//            }else{
//                completion(status: false,responseObj:nil ,error: error,statusCode: nil , tag: tagString!)
//            }
//        }
        NSLog("Request Send")
        Alamofire.request(methodtype, urlConvert , parameters:parameter, encoding: ParameterEncoding.JSON, headers: headerDict).responseJSON { response in
            debugPrint(response)     // prints detailed description of all response properties
            
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            //                var jsonObj : JSON
            NSLog("Request success %@",response.data!);
            
            let data: AnyObject = response.data!
            let jsonObj = JSON(data: data as! NSData)
            let status =  response.response?.statusCode
            if CommonFunctions.isSuccessfullyDone(status).flag {
                //                    let jsonObj : JSON = JSON(jsonObject!)
                completion(status: true,responseObj: jsonObj ,error: nil,statusCode: status!, tag: tagString!)
            }else{
                completion(status: false,responseObj:nil ,error: nil,statusCode: nil , tag: tagString!)
            }
        }
        return;
        /*
       Alamofire.request(methodtype, urlConvert , parameters:parameter, encoding: ParameterEncoding.JSON, headers: headerDict).response(queue: queue, responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
            completionHandler: { request, response , jsonObject, error in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                // You are now running on the concurrent `queue` you created earlier.
                
                print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
                
                // Validate your JSON response and convert into model objects if necessary
                println(JSON)
                var status =  response?.statusCode
                
                if CommonFunctions.isSuccessfullyDone(status).flag {
                   let jsonObj : JSON = JSON(jsonObject!)
                    completion(status: true,responseObj: jsonObj ,error: nil,statusCode: status!, tag: tagString!)
                }else{
                    completion(status: false,responseObj:nil ,error: error,statusCode: nil , tag: tagString!)
                }
                

                // To update anything on the main thread, just jump back on like so.
                
            }
        )*/
    }
    class func uploadPictureFromUploadType(uploadType : UploadType ,url : String , filePath : NSURL? , data: NSData?,  completion: ((status:Bool, responseObj : JSON?, error : NSError, statusCode : NSInteger? , tag : String ) -> Void)){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let headerDict : [String : String]? = ["ApiKey":"secret123"]
        let updatedUrl = Base_Url+url
        let urlConvert : URLStringConvertible = updatedUrl
        
        switch uploadType {
            
        case .DataUpload:
            Alamofire.upload(.POST, urlConvert , headers: headerDict, data: data!).progress{
                bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                }.responseJSON { response in
                    debugPrint(response)     // prints detailed description of all response properties
                    
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                     UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        case .FileUpload:
            Alamofire.upload(.POST, urlConvert, headers: headerDict, file: filePath!).progress{
                bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                }.responseJSON { response in
                    debugPrint(response)     // prints detailed description of all response properties
                    
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                     UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
        case  .MultipartFormData:
            Alamofire.upload(.POST, urlConvert, headers: headerDict, multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: filePath!, name: "filePath")
                },encodingMemoryThreshold: 2, encodingCompletion: { encodingResult in
                     UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)     // prints detailed description of all response properties
                            
                            print(response.request)  // original URL request
                            print(response.response) // URL response
                            print(response.data)     // server data
                            print(response.result)   // result of response serialization
                            
//                            print(JSON)
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
            })
        case .Streamload:
            Alamofire.upload(.POST, urlConvert, headers: headerDict, stream: NSInputStream(data: data!)).progress{
                bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                }.responseJSON { response in
                    debugPrint(response)     // prints detailed description of all response properties
                    
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                     UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        default:
            print("default", terminator: "")
        }
    }
    class func downloadPicture(url : String , completion: ((status:Bool, responseObj : JSON?, error : NSError, statusCode : NSInteger? , tag : String ) -> Void)){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        let updatedUrl = Base_Url+url
        let urlConvert : URLStringConvertible = updatedUrl
        Alamofire.download(.GET,urlConvert , destination: destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                print(totalBytesRead)
            }
            .response { request, response, _, error in
                print(response)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }

}