//
//  Setting_Screen.m
//  pioneer
//
//  Created by Valeteck on 29/07/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import "Setting_Screen.h"
#import "EditProfile.h"
#import "About.h"
#import "PrivacyPolicy.h"
#import "Reachability.h"
#import "Submission.h"
#import "DataClass.h"



@interface Setting_Screen () {
    
    
    DataClass *objectDataClass;
    
}

@end

@implementation Setting_Screen
@synthesize setting_Table_View;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];

    objectDataClass =[DataClass getInstance];
    


}

#pragma mark viewWillAppear

-(void)viewWillAppear:(BOOL)animated{
    
 //   self.showTemperature.text = [NSString stringWithFormat:@"%0.0f", objectDataClass.temperature];
    
    
    [self.setting_Table_View setBackgroundView:nil];
    [self.setting_Table_View setBackgroundColor:[UIColor clearColor]];
    
    
    myData = [[NSMutableArray alloc]initWithObjects:@"My submission",
              @"Edit profile",@"About us",
              @"Privacy policy", nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *stringForCell;
    if (indexPath.section == 0) {
        stringForCell= [myData objectAtIndex:indexPath.row];
        
    }
    else if (indexPath.section == 1){
        stringForCell= [myData objectAtIndex:indexPath.row+ [myData count]/2];
        
    }
    [cell.textLabel setText:stringForCell];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
 //   [cell.imageView [setImage:@"arrow.png"];
    return cell;
}

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


#pragma mark - TableView delegate

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
    if(path.row==0)
    {
        return path;
    }
    else if (path.row==1)
    {
        return path;
        
    }else if(path.row==2){
        return path;
        
        
    }else if (path.row==3){
        return path;
        
    }
    
    return nil;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%ld Row:%ld selected and its data is %@",
          (long)indexPath.section,(long)indexPath.row,cell.textLabel.text);
    
    if(indexPath.row==0){
        
        CGSize size = [[UIScreen mainScreen]bounds].size;
        if (size.height==480) {
            
            
            Submission *submission=[[Submission alloc]initWithNibName:@"Submission3.5" bundle:nil];
            
            [self.navigationController pushViewController:submission animated:YES];
            
        }
        else{
            
            
            Submission *submission=[[Submission alloc]initWithNibName:@"Submission" bundle:nil];
            
            [self.navigationController pushViewController:submission animated:YES];
            
            
        }
    }
  
   else if (indexPath.row==1) {
       
       // NSString *server = [[NSUserDefaults standardUserDefaults]stringForKey:@"connection_Internet"];
       
       //if ([Utility connected] == YES) {

                    NSLog(   @"this is edit profile");
                    CGSize size = [[UIScreen mainScreen]bounds].size;
          
                    if (size.height==480) {
                        EditProfile *edit = [[EditProfile alloc]initWithNibName:@"EditProfile3.5" bundle:nil];
                        [self.navigationController pushViewController:edit animated:YES];
          
          
                    }else{
                        EditProfile *edit = [[EditProfile alloc]initWithNibName:@"EditProfile" bundle:nil];
                        [self.navigationController pushViewController:edit animated:YES];
                    }
       
       /*}
       else
       {
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                     [alert show];

           
       }*/
       
       
   }
   else if (indexPath.row==2){
       NSLog(@"this is about...");
       
       CGSize size = [[UIScreen mainScreen]bounds].size;
       
       if (size.height==480) {

           About *abt = [[About alloc]initWithNibName:@"About3.5" bundle:nil];
           [self.navigationController pushViewController:abt animated:YES];

       }else{
           
           About *abt = [[About alloc]initWithNibName:@"About" bundle:nil];
           [self.navigationController pushViewController:abt animated:YES];
 
           
       }

   }
   else if (indexPath.row==3){
       NSLog(@"this privacy policy");
       
       CGSize size = [[UIScreen mainScreen]bounds].size;
       
       if (size.height==480) {
           PrivacyPolicy *termsOfUse = [[PrivacyPolicy alloc]initWithNibName:@"PrivacyPolicy3.5" bundle:nil];
           [self.navigationController pushViewController:termsOfUse animated:YES];
           
           
       }else{
           
           
           PrivacyPolicy *termsOfUse = [[PrivacyPolicy alloc]initWithNibName:@"PrivacyPolicy" bundle:nil];
           [self.navigationController pushViewController:termsOfUse animated:YES];
           
           
       }
       
   }
    
}

- (IBAction)back_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}





@end
