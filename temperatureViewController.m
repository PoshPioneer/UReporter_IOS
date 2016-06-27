//
//  temperatureViewController.m
//  Pioneer
//
//  Created by Deepankar Parashar on 22/02/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "temperatureViewController.h"

@interface temperatureViewController (){
    
    NSURL *url;
    NSURLRequest *urlRequest;
    NSMutableData *responseData;
    
}

@end

@implementation temperatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.view setUserInteractionEnabled:NO];
    spinner=[SpinnerView loadSpinnerIntoView:self.view];
    
    NSLog(@"loading web url");
    [self load_webView_Url];

}


-(void)load_webView_Url {
    
    
    
//    NSString *urlString = @"http://www.goskagit.com/weather/?weather_zip=98274&amp;f=rss&amp;altf=doapp2";
//     url = [NSURL URLWithString:urlString];
//     urlRequest = [NSURLRequest requestWithURL:url];
//    [self.Temperature_webView loadRequest:urlRequest];
    
    NSError *error = nil;
    
    NSMutableDictionary * getData =[NSMutableDictionary dictionary];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:getData
                        
                                                       options:kNilOptions
                                                         error:&error];
    //timesgroupcrapi  http://timesgroupcrapi.cloudapp.net/api/UserDet
    
    
    
    
    url = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?zip=98274,us&appid=025fd416c44e35caa638609d50f6c056&units=metric"];
    
   // NSLog(@"DICT IS===%@",getData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSError *jsonError;
                               
                               NSLog(@"data = %@",data);
                               NSLog(@"response = %@",response);
                               NSLog(@"error = %@",error);
                               
                               if (data==nil || response==nil) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"inside main thread!");
                                       NSLog(@"An error occured: %@", jsonError);
                                       [self.view setUserInteractionEnabled:YES];
                                       [spinner removeSpinner];
                                   });
                                   
                                   
                               }else{
                                   
                                   
                                   id  json = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                                error:&jsonError];
                                   NSLog(@"json is for UserDetails== %@",json);
                                   
                                   NSString * temperature  = [NSString stringWithFormat:@"%@",[[json valueForKey:@"main"] valueForKey:@"temp"]];
                                   NSLog(@"temperature is --%@",temperature);
                                   
                                   
                                   if ( error ==nil) {
                                       
                                       if (json) {
                                           
                                          // NSLog(@"json is --%@",json);                                    }
                                       
                                   } // error == nil check !!!end
                                   else{
                                       
                                    NSLog(@"json 2--%@",json);
                                   
                                   }
                               }
                           

                               }
                           }];
    
     
    
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];
    
    
    
}

#pragma marks NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error is %@",[error localizedDescription]);
    
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData  appendData:data];
    
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    responseData = [[NSMutableData alloc]initWithLength:0];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];
    
    // all the checks regarding otp, if it throws error or come some unusual response, or nil !
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:responseData
                                              options:kNilOptions
                                                error:&error];
    
    if (json) {
        
        
        NSLog(@"json 3---%@",json);
    }else {
        
        
        NSLog(@"nothing");
    }
    
    
    
}



#pragma mark --WEbView delegate
-(void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"web view did started  ");
    

    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"error is --%@",error );
    
    
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"finish loading");
    
    

}


- (IBAction)backButtonTap:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
    
    
}
@end

