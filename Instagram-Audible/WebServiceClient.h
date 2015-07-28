//
//  WebServiceClient.h
//  Instagram-Audible
//
//  Created by Chanikya on 27/07/2015.
//  Copyright (c) 2015 Chanikya Mandapathi. All rights reserved.
//


#import "AFHTTPSessionManager.h"

@protocol WebServiceClientDelegate;

@interface WebServiceClient : AFHTTPSessionManager

@property (nonatomic, weak) id<WebServiceClientDelegate>delegate;

+ (WebServiceClient *)sharedWebServiceClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

- (void) retrievePhotos;

@end

@protocol WebServiceClientDelegate <NSObject>

@optional
-(void)webServiceClient:(WebServiceClient *)client didUpdateWithPics:(id)pis;
-(void)webServiceClient:(WebServiceClient *)client didFailWithError:(NSError *)error;

@end
