//
//  Constants.m
//  USP
//
//  Created by Amit joshi on 30/12/15.
//  Copyright © 2015 Cynoteck. All rights reserved.
//

#import "Constants.h"

@implementation Constants



#ifdef DEBUG
NSString * const kBaseURL = @"http://prngapidev.cloudapp.net/";// Development Url
//NSString * const kBaseURL = @"http://prngapi.cloudapp.net/"; // production url..
#else
NSString * const kBaseURL = @"http://prngapidev.cloudapp.net/";// Development Url
//NSString * const kBaseURL = @"http://prngapi.cloudapp.net/";// production Url
#endif





NSString * const kAlertInternetCheck = @"You appear to be offline. Please check your internet settings.";

NSString * const kAPI = @"api";

NSString * const kUserDetails = @"UserDetails";

NSString * const kCategory=@"Category";

NSString * const kblobs =@"blobs";

NSString * const kRssFeed =@"RssFeed";

NSString * const kGetRssFeed =@"GetRssFeed";

@end
