//
//  WebServiceClient.m
//  Instagram-Audible
//
//  Created by Chanikya on 27/07/2015.
//  Copyright (c) 2015 Chanikya Mandapathi. All rights reserved.
//

#import "WebServiceClient.h"

static NSString * const BaseURLString = @"https://api.instagram.com/v1/tags/";

@implementation WebServiceClient

NSMutableArray *resultArray;


//provides access to singleton object of the class
+ (WebServiceClient *)sharedWebServiceClient
{
    static WebServiceClient *_sharedWebServiceClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWebServiceClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    });
    
    return _sharedWebServiceClient;
}

// Initializes the object with Instagram API url
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        //self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

// Retrieves All Photos from Instagram API
- (void) retrievePhotos {
    
    [self GET:@"selfie/media/recent?access_token=647785057.1677ed0.4de58c986679455d95d7a74ed8c22d53"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          
          if ([self.delegate respondsToSelector:@selector(webServiceClient:didUpdateWithPics:)]) {
              [self.delegate webServiceClient:self didUpdateWithPics:responseObject];
              
          }
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          if ([self.delegate respondsToSelector:@selector(webServiceClient:didFailWithError:)]) {
              [self.delegate webServiceClient:self didFailWithError:error];
          }
      }];
    
}

@end

