//
//  Utility.m
//  LeadTransformed
//
//  Created by Justin Mohit on 05/06/14.
//  Copyright (c) 2014 Justin Mohit. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"
@implementation Utility

+ (id)cleanJsonToObject:(id)data {
    NSError* error;
    if (data == (id)[NSNull null]){
        return [[NSObject alloc] init];
    }
    id jsonObject;
    if ([data isKindOfClass:[NSData class]]){
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    } else {
        jsonObject = data;
    }
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [jsonObject mutableCopy];
        for (int i = (int)array.count-1; i >= 0; i--) {
            id a = array[i];
            if (a == (id)[NSNull null]){
                [array removeObjectAtIndex:i];
            } else {
                array[i] = [self cleanJsonToObject:a];
            }
        }
        return array;
    } else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictionary = [jsonObject mutableCopy];
        for(NSString *key in [dictionary allKeys]) {
            id d = dictionary[key];
            if (d == (id)[NSNull null]){
                dictionary[key] = @"";
            } else {
                dictionary[key] = [self cleanJsonToObject:d];
            }
        }
        return dictionary;
    } else {
        return jsonObject;
    }
}
//>---------------------------------------------------------------------------------------------------
// Author Name      :   Caleb Kapil
// Date             :   Sep, 29 2014
// Input Parameters :   N/A.
// Purpose          :   For Check the Network status wheather network is avilable or not.
//>---------------------------------------------------------------------------------------------------
+ (BOOL)connected
{
        //return NO; // force for offline testing
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    return !(netStatus == NotReachable);
}

@end
