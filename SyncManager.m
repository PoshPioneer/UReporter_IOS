//
//  SyncManager.m
//  Petofy
//
//  Created by Mohit Bisht on 10/02/16.
//  Copyright © 2016 Cynoteck. All rights reserved.
//

#import "SyncManager.h"
#import "AFNetworking.h"

@interface SyncManager ()

@end

@implementation SyncManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) serviceCall:(NSString*)url withParams:(NSDictionary*) params {
    
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *json = [Utility cleanJsonToObject:responseObject];
         [self.delegate syncSuccess:json];
      
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.delegate syncFailure:error];
    }];
    

}

//PUT request

-(void) putServiceCall:(NSString*)url withParams:(NSDictionary*) params {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager PUT:url parameters:params success:^(NSURLSessionTask *task, id responseObject){
        
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *json = [Utility cleanJsonToObject:responseObject];
        [self.delegate syncSuccess:json];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.delegate syncFailure:error];
    }];

    
}


//GET request

-(void) getServiceCall:(NSString*)url withParams:(NSDictionary*) params {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *json = [Utility cleanJsonToObject:responseObject];
        [self.delegate syncSuccess:json];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.delegate syncFailure:error];
    }];
    
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
