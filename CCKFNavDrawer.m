//
//  CCKFNavDrawer.m
//  CCKFNavDrawer
//
//  Created by calvin on 23/1/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.


#import "CCKFNavDrawer.h"
#import "DrawerView.h"
#import "CustomCellForSlider.h"
#import "AppDelegate.h"
#import "EditProfile.h"
#import "DataClass.h"
#import "NSString+FontAwesome.h"
#import "About.h"
#import "PrivacyPolicy.h"
#import "Submission.h"
#import "SubmitForReview.h"
#import "FAImageView.h"
#import "UIImage+FontAwesome.h"
#import "LoginView.h"



#define SHAWDOW_ALPHA 0.5
#define MENU_DURATION 0.3
#define MENU_TRIGGER_VELOCITY 350
#define ISIPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface CCKFNavDrawer (){
    
  //  DataClass *dClassObject;
    DataClass * objectDataClass;
    NSString *feedType ;
    NSString* feedID;
    NSString * sideIconType;
    NSString* sideFAType;
    NSString* iconImageUrl;
    NSString* FAValue;
    UILabel *subCategoryLabel;
    UIImageView *imageViewIcon;
    
    
}
@property (nonatomic, strong) NSMutableArray *menuItems;
@property(nonatomic,strong)NSArray* staticMenuItems;

@property (nonatomic, strong) NSArray *menuItemsImages;
@property(nonatomic,strong)NSMutableArray * temporaryInnerFeeds;



@property (nonatomic) BOOL isOpen;
@property (nonatomic) float meunHeight;
@property (nonatomic) float menuWidth;

@property (nonatomic) CGRect outFrame;
@property (nonatomic) CGRect inFrame;
@property (strong, nonatomic) UIView *shawdowView;
@property (strong, nonatomic) DrawerView *drawerView;
@property(nonatomic,assign) int DoCheck;
@end

@implementation CCKFNavDrawer
@synthesize DoCheck,menuItems;



@synthesize menuItemsImages;
#pragma mark - VC lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    
    
    
    NSLog(@"nibNameOrNil = %@",nibNameOrNil);
    NSLog(@"bundle is = %@",nibBundleOrNil);
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    objectDataClass = [DataClass getInstance];
    sectionTitleArray = [[NSMutableArray alloc] init];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
   // [self.drawerView.drawerTableView deselectRowAtIndexPath:[self.drawerView.drawerTableView indexPathForSelectedRow] animated:YES];
    [self setUpDrawer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - push & pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    // disable gesture in next vc
    [self.pan_gr setEnabled:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    // enable gesture in root vc
    if ([self.viewControllers count]==1){
        [self.pan_gr setEnabled:YES];
    }
    return vc;
}

#pragma mark - drawer

- (void)setUpDrawer {
    
    self.isOpen = NO;
    
    // load drawer view
    self.drawerView = [[[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil] objectAtIndex:0];
    
    self.meunHeight = self.drawerView.frame.size.height;
    self.menuWidth =  self.drawerView.frame.size.width;
    
    
    
    self.outFrame = CGRectMake(-self.menuWidth,0,self.menuWidth,self.meunHeight);
    self.inFrame = CGRectMake (0,0,self.menuWidth,self.meunHeight);
    
    // drawer shawdow and assign its gesture
    self.shawdowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.shawdowView.hidden = YES;
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOnShawdow:)];
    [self.shawdowView addGestureRecognizer:tapIt];
    self.shawdowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shawdowView];
    
    // add drawer view
    [self.drawerView setFrame:self.outFrame];
    [self.view addSubview:self.drawerView];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] == nil)
    {
        self.drawerView.lblUserName.text = @"";
        [self.drawerView.lblUserBelowLine setHidden:YES];

    }
    else
    {
        self.drawerView.lblUserName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
        [self.drawerView.lblUserBelowLine setHidden:NO];

    }

    // drawer list
   // [self.drawerView.drawerTableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)]; // statuesBarHeight+navBarHeight
    
    // [self.drawerView.drawerTableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)]; // statuesBarHeight+navBarHeight
    self.drawerView.drawerTableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    self.drawerView.drawerTableView.dataSource = self;
    self.drawerView.drawerTableView.delegate = self;
    
    // gesture on self.view
    self.pan_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
    
    
    // 15 may changed to prevent root view control presentation......;/
    
    self.pan_gr.maximumNumberOfTouches = 0;     //1;
    self.pan_gr.minimumNumberOfTouches = 0 ;      // 1;
    
    // 15 may changed to prevent root view control presentation......;/

    
    //self.pan_gr.delegate = self;
    [self.view addGestureRecognizer:self.pan_gr];
    [self.view bringSubviewToFront:self.navigationBar];
    
//    for (id x in self.view.subviews){
//        NSLog(@"%@",NSStringFromClass([x class]));
//    }
}

- (void)drawerToggle:(int)myCheck
{

  //  [self.drawerView.drawerTableView reloadData];
    DoCheck=myCheck;
    NSLog(@"---mycheck is ====%i",DoCheck);
    NSLog(@"drawerToggle called!");
    
    self.menuItems = [NSMutableArray new];
    self.temporaryInnerFeeds = [NSMutableArray new];
    
    if (DoCheck==1) {
        NSLog(@"collected data in slider class --%@",objectDataClass.globalcompleteCategory);
       
        arrayForBool=[[NSMutableArray alloc]init];

        
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] != nil)
        {
            self.staticMenuItems = @[@"Profile",@"Terms and Conditions",@"Privacy Policy",@"About Us", @"My Submissions",@"Saved Articles",@"Logout"];
        }
        else
        {
            
            self.staticMenuItems = @[@"Profile",@"Terms and Conditions",@"Privacy Policy",@"About Us", @"My Submissions",@"Saved Articles"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] == nil)
        {
            self.drawerView.lblUserName.text = @"";
            [self.drawerView.lblUserBelowLine setHidden:YES];
        }
        else
        {
            self.drawerView.lblUserName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
            [self.drawerView.lblUserBelowLine setHidden:NO];

        }

        sectionTitleArray = objectDataClass.globalcompleteCategory;
        

        
        for (int count =0 ; count < (sectionTitleArray.count + self.staticMenuItems.count); count++) {
            

            
             [arrayForBool addObject:[NSNumber numberWithBool:NO]];
            
            NSLog(@"counter --%d",count);
            
            
        }

        if (objectDataClass.flag) {
            
            [arrayForBool replaceObjectAtIndex:objectDataClass.sectionIndex withObject:[NSNumber numberWithBool:YES]];
        }
        
       //[self.drawerView.drawerTableView reloadData];

    }
    else{
        
      //  self.menuItems = @[@"Admin Report", @"Add Organization", @"Question", @"Mail Content", @"Change Password",@"Email",@"Edit Organization",@"Sub Admin",@"Log Out"];
    }
    
    
    if (!self.isOpen) {
        
        [self openNavigationDrawer];
        
    }else{
        
        [self closeNavigationDrawer];
    }
}

#pragma open and close action

- (void)openNavigationDrawer{
    
    
//    NSLog(@"open x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*fabs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    

    
    // shawdow
    self.shawdowView.hidden = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHAWDOW_ALPHA];
                     }
                     completion:nil];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.inFrame;
                     }
                     completion:nil];
    
    self.isOpen= YES;
    
//    self.drawerView.drawerTableView.dataSource = self;
//    self.drawerView.drawerTableView.delegate = self;
    [self.drawerView.drawerTableView reloadData];
    
}


- (void)closeNavigationDrawer{
    
      float duration = MENU_DURATION/self.menuWidth*fabs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         self.shawdowView.hidden = YES;
                     }];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.outFrame;
                     }
                     completion:nil];
    self.isOpen= NO;
}

#pragma gestures

- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer {
    
    
    [self closeNavigationDrawer];
    
}

-(void)moveDrawer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)recognizer velocityInView:self.view];
//    NSLog(@"velocity x=%f",velocity.x);
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
//        NSLog(@"start");
        if ( velocity.x > MENU_TRIGGER_VELOCITY && !self.isOpen) {
            [self openNavigationDrawer];
        }else if (velocity.x < -MENU_TRIGGER_VELOCITY && self.isOpen) {
            [self closeNavigationDrawer];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {
//        NSLog(@"changing");
        float movingx = self.drawerView.center.x + translation.x;
        if ( movingx > -self.menuWidth/2 && movingx < self.menuWidth/2){
            
            self.drawerView.center = CGPointMake(movingx, self.drawerView.center.y);
            [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
            
            float changingAlpha = SHAWDOW_ALPHA/self.menuWidth*movingx+SHAWDOW_ALPHA/2; // y=mx+c
            self.shawdowView.hidden = NO;
            self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:changingAlpha];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        
//        NSLog(@"end");
        if (self.drawerView.center.x>0){
            [self openNavigationDrawer];
        }else if (self.drawerView.center.x<0){
            [self closeNavigationDrawer];
        }
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return (sectionTitleArray.count + self.staticMenuItems.count);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        
        NSArray *tempFeedItemArray = sectionTitleArray[section][@"FeedsItem"];
        return tempFeedItemArray.count;
    }
    else
        return 0;
        
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *kCellID = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellID];
         //[cell.lbl_separatorLine setHidden:YES];
     if (DoCheck==1) {
         
        if (cell == nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
        }
        else
        {
            for (UIView *view in cell.subviews)
            {
                
                [view removeFromSuperview];
            }
            [cell prepareForReuse];
        }
        // cell.selectionStyle = UITableViewCellSelectionStyleDefault;
         
        BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        
        /********** If the section supposed to be closed *******************/
        if(!manyCells)
        {
            cell.backgroundColor=[UIColor clearColor];
            
            cell.textLabel.text=@"";
        }
        /********** If the section supposed to be Opened *******************/
        else
        {
            
            
            
   
            
          subCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0.0, 100.0, 35.0)]; // 30
            subCategoryLabel.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];
            subCategoryLabel.text=[NSString stringWithFormat:@"%@",[sectionTitleArray objectAtIndex:indexPath.section][@"FeedsItem"][indexPath.row][@"Name"]];
           
            subCategoryLabel.font=[UIFont systemFontOfSize:13.0f];//15
         
            
            subCategoryLabel.textColor=[UIColor grayColor];

            [cell addSubview: subCategoryLabel];
            if (objectDataClass.flag ) {
           
                if (indexPath.row == objectDataClass.rowIndex  && indexPath.section == objectDataClass.sectionIndex)
                {
                    subCategoryLabel.textColor = [UIColor whiteColor];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:objectDataClass.rowIndex inSection:objectDataClass.sectionIndex];
                    
                    [tableView selectRowAtIndexPath:indexPath
                                                animated:YES
                                          scrollPosition:UITableViewScrollPositionNone];
                     
                    
                  //  [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                }
            }
        }
         cell.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];

         UIView *bgColorView = [[UIView alloc] init];
         bgColorView.backgroundColor = [UIColor colorWithRed:(76.0/255.0) green:(161.0/255.0) blue:(255.0/255.0) alpha:1.0]; // perfect color suggested by @mohamadHafez
         bgColorView.layer.masksToBounds = YES;
         cell.selectedBackgroundView = bgColorView;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    /*************** Close the section, once the data is selected ***********************************/
    //[arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    NSLog(@"selected sub sub menu");
    
    objectDataClass.rowIndex = indexPath.row;

    feedType = [sectionTitleArray objectAtIndex:indexPath.section][@"FeedsItem"][indexPath.row][@"Type"];
    NSLog(@"feed type--%@",feedType);
    feedID= [sectionTitleArray objectAtIndex:indexPath.section][@"FeedsItem"][indexPath.row][@"Id_Feed"];
    NSLog(@"feed id--%@",feedID);
    objectDataClass.globalstaticLink = [sectionTitleArray objectAtIndex:indexPath.section][@"FeedsItem"][indexPath.row][@"URL"];
    NSLog(@"static link --%@",objectDataClass.globalstaticLink);
    
    
    objectDataClass.globalFeedID = feedID;
    objectDataClass.globalFeedType = feedType;
    NSLog(@"global feed id--%@ and type--%@",objectDataClass.globalFeedID,objectDataClass.globalFeedType);
    
    // PAYMETER API
    
    NSMutableDictionary *json= [[NSMutableDictionary alloc] init];
    [json setObject:@"YTliMzYyYTktMWMyZC00NTc0LWE4NWMtN2JkMTA2YjAyMGQ3" forKey:@"sessionId"];
    [json setObject:[sectionTitleArray objectAtIndex:indexPath.section][@"Menu"][@"MainCategory"] forKey:@"contentId"];
    [json setObject:@"" forKey:@"referrer"];
    [json setObject:@"IOS" forKey:@"clientInfo"];
    
    NSLog(@"%@",json);
    DataClass *obj = [DataClass getInstance];
    obj.jsonDict = json;
    NSLog(@"%@",obj.jsonDict);

    [self.CCKFNavDrawerDelegate CCKFNavDrawerSelection:[indexPath section]];
    [self closeNavigationDrawer];

   // [self.drawerView.drawerTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        
        if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
            return 35.0; // 40
        }
        return 0;
    }
    return 0;

}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 150,35)];
    sectionView.tag=section;
    
    imageViewIcon =[[UIImageView alloc]init];
     UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.drawerView.drawerTableView.frame.size.width, 35)];// change 40 to 30 in height .
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor=[UIColor whiteColor];
   
    viewLabel.font=[UIFont systemFontOfSize:15];
    if (sectionTitleArray.count >=section+1) {
        
       
        
        viewLabel.text=[NSString stringWithFormat:@"%@",[sectionTitleArray objectAtIndex:section][@"Menu"][@"MainCategory"]];
       
        dispatch_async(dispatch_get_main_queue(), ^{
        sideIconType= [[[sectionTitleArray objectAtIndex:section] valueForKey:@"Menu"] valueForKey:@"IconType"];
        iconImageUrl = [[[sectionTitleArray objectAtIndex:section] valueForKey:@"Menu"] valueForKey:@"ImageUrl"];
        FAValue  =[[[sectionTitleArray objectAtIndex:section] valueForKey:@"Menu"] valueForKey:@"FAValue"];
        sideFAType = [[[sectionTitleArray objectAtIndex:section] valueForKey:@"Menu"] valueForKey:@"FAClass"];
       // UILabel * iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0, 7.0, 20.0, 20.0)];
        UIImageView * iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(6.0, 7.0, 20.0, 20.0)];

            /*let label = UILabel(frame: CGRectMake(0, 0, 100, 100))
             label.font = UIFont(name: "FontAwesome", size: 40)
             let myChar: UniChar = 0xF180
             label.text = String(format: "%C", myChar)
             self.view.addSubview(label)*/
           
        NSLog(@"image url--%@",iconImageUrl);
            
        if ([sideIconType isEqualToString:@"Image"]) {
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconImageUrl]];
             
             [iconImage setImage:[UIImage imageWithData:data]];
            [sectionView addSubview:iconImage];
            
        }//else if ([sideFAType isEqualToString:@"fa-archive"]){
            
            UIImage *icon = [UIImage imageWithIcon:sideFAType backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:255] fontSize:20];
            NSLog(@"imageis......%@",icon);

            [iconImage setImage:icon];
            [sectionView addSubview:iconImage];
            
           });
        
    }
    else {
        
        if (!objectDataClass.flag )
        {
            
            if (-1 == objectDataClass.rowIndex  && section == objectDataClass.sectionIndex && section != (sectionTitleArray.count + self.staticMenuItems.count)-1)
            {
                sectionView.backgroundColor = [UIColor colorWithRed:(76.0/255.0) green:(161.0/255.0) blue:(255.0/255.0) alpha:1.0];
            }
            else
            {
                sectionView.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];
            }
        }
        imageViewIcon.frame = CGRectMake(8.0, 8.0, 18, 18);
        viewLabel.frame = CGRectMake(45.0, 0.0, self.drawerView.drawerTableView.frame.size.width, 35); // 40
        
        viewLabel.text=self.staticMenuItems[section-sectionTitleArray.count];
        if ([viewLabel.text isEqualToString:@"Profile"]) {
            imageViewIcon.image=[UIImage imageNamed:@"ProfileImg@2x.png"];
            viewLabel.font = [UIFont systemFontOfSize:15.0];
            viewLabel.textColor = [UIColor whiteColor];
                UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.drawerView.drawerTableView.frame.size.width, 1)];
                separatorLineView.backgroundColor = [UIColor whiteColor];
                [sectionView addSubview:separatorLineView];

            
                
            
        }else{
            if ([viewLabel.text isEqualToString:@"Privacy Policy"]){
                imageViewIcon.image=[UIImage imageNamed:@"PrivacyPoliceImg@2x.png"];

            
            }
            else if ([viewLabel.text isEqualToString:@"Saved Articles"]){
            
                imageViewIcon.image=[UIImage imageNamed:@"SavedArticleImg@2x.png"];


            }
            else if ([viewLabel.text isEqualToString:@"About Us"]){
                
                imageViewIcon.image=[UIImage imageNamed:@"AboutUsImg@2x.png"];

                
            }
            
            
            
            viewLabel.font =[UIFont systemFontOfSize:15.0];
            viewLabel.textColor = [UIColor whiteColor];
            if ([viewLabel.text isEqualToString:@"My Submissions"]) {
                imageViewIcon.image=[UIImage imageNamed:@"MySubmissionImg@2x.png"];


                
                UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0,0.0, self.drawerView.drawerTableView.frame.size.width, 1)];
                separatorLineView.backgroundColor = [UIColor whiteColor];
                [sectionView addSubview:separatorLineView];
                
            }
        }
    }
    [sectionView addSubview:viewLabel];
    [sectionView addSubview:imageViewIcon];

    /********** Add a custom Separator with Section view *******************/
    
   
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
    
    
}


#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSLog(@"sub menu  tapped");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.section >= sectionTitleArray.count) {
        
        NSLog(@"static data cell");
        if (indexPath.section == sectionTitleArray.count) {
            //NSString* index= [NSString stringWithFormat:@"%lu",(unsigned long)indexPath.section];
           // NSDictionary *sendingDict= [[NSDictionary alloc] initWithObjectsAndKeys:@{index: @"indexKey"}, nil];
            
            NSLog(@"nothing -- %lu",(unsigned long)indexPath.section);
            NSLog(@"Edit profile slider--%lu",(unsigned long)indexPath.section);
            [self.CCKFNavDrawerDelegate StaticMenuItems:indexPath.section];
            [self closeNavigationDrawer];
            

        }
        else if (indexPath.section == sectionTitleArray.count+1) {
            
            NSLog(@"Edit profile slider--%lu",(unsigned long)indexPath.section);
            [self.CCKFNavDrawerDelegate StaticMenuItems:indexPath.section];
            [self closeNavigationDrawer];
            
            
        }
        else if (indexPath.section == sectionTitleArray.count+2) {
            
            NSLog(@"About us slider--%lu",(unsigned long)indexPath.section);
            [self.CCKFNavDrawerDelegate StaticMenuItems:indexPath.section];
            [self closeNavigationDrawer];
            
            
        }
        
        else if (indexPath.section == sectionTitleArray.count+3) {
            
            NSLog(@"terms and conition--%lu",(unsigned long)indexPath.section);
            [self.CCKFNavDrawerDelegate StaticMenuItems:indexPath.section];
            [self closeNavigationDrawer];
            
        
        }
        else if (indexPath.section == sectionTitleArray.count+4) {
            
            NSLog(@"privacy policy-%lu",(unsigned long)indexPath.section);
            [self.CCKFNavDrawerDelegate StaticMenuItems:indexPath.section];
            [self closeNavigationDrawer];
            
           
            
        }else if (indexPath.section == sectionTitleArray.count+5) {
            
            NSLog(@"my submission --%lu",(unsigned long)indexPath.section);
            [self.CCKFNavDrawerDelegate StaticMenuItems:indexPath.section];
            [self closeNavigationDrawer];
        }
        else if (indexPath.section == sectionTitleArray.count+6) {
            
            [self.drawerView.drawerTableView reloadData];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert!"
                                                                           message:@"Are you sure you want to logout?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Yes Sure"
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      NSLog(@"You pressed button one");
                                                                      
                                                                      [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userName"];
                                                                      LoginView *loginView=[[LoginView alloc]initWithNibName:@"LoginView" bundle:nil];
                                                                      [self presentViewController:loginView animated:YES completion:nil];
                                                                      [self closeNavigationDrawer];
                                                                  }];
            UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Not Yet"
                                                                   style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                       NSLog(@"You pressed button two");
                                                                   }];
            
            [alert addAction:firstAction];
            [alert addAction:secondAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        objectDataClass.rowIndex = -1;
        objectDataClass.sectionIndex = indexPath.section;
        objectDataClass.flag = NO;
    }
    else {
      
        
        
     objectDataClass.sectionIndex = indexPath.section;
  
        
        
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        objectDataClass.flag = !collapsed;
        if (objectDataClass.flag) {
            
            objectDataClass.rowIndex = -1;

        }
        
        
        
        
        for (int i=0; i<[sectionTitleArray count]; i++) {
            
            if (indexPath.section==i) {
                NSLog(collapsed ? @"Yes" : @"No");
               
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
            else
            {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            }
            
        }
        if ([[[sectionTitleArray objectAtIndex:indexPath.section] valueForKey:@"FeedsItem"] count] == 1) {
            
            NSLog(@"selected sub sub menu");
            objectDataClass.rowIndex = 0;
            feedType = [sectionTitleArray objectAtIndex:indexPath.section][@"FeedsItem"][0][@"Type"];
            NSLog(@"feed type--%@",feedType);
            feedID= [sectionTitleArray objectAtIndex:indexPath.section][@"FeedsItem"][0][@"Id_Feed"];
            NSLog(@"feed id--%@",feedID);
            objectDataClass.globalstaticLink = [sectionTitleArray objectAtIndex:indexPath.section][@"FeedsItem"][0][@"URL"];
            NSLog(@"static link --%@",objectDataClass.globalstaticLink);
            
            
            
            objectDataClass.globalFeedID = feedID;
            objectDataClass.globalFeedType = feedType;
            NSLog(@"global feed id--%@ and type--%@",objectDataClass.globalFeedID,objectDataClass.globalFeedType);
            
            // PAYMETER API
            
            NSMutableDictionary *json= [[NSMutableDictionary alloc] init];
            [json setObject:@"YTliMzYyYTktMWMyZC00NTc0LWE4NWMtN2JkMTA2YjAyMGQ3" forKey:@"sessionId"];
            [json setObject:[sectionTitleArray objectAtIndex:indexPath.section][@"Menu"][@"MainCategory"] forKey:@"contentId"];
            [json setObject:@"" forKey:@"referrer"];
            [json setObject:@"IOS" forKey:@"clientInfo"];
            
            NSLog(@"%@",json);
            DataClass *obj = [DataClass getInstance];
            obj.jsonDict = json;
            NSLog(@"%@",obj.jsonDict);
            
            [self.CCKFNavDrawerDelegate CCKFNavDrawerSelection:[indexPath section]];
            [self closeNavigationDrawer];
        }

        [self.drawerView.drawerTableView reloadData];
        
        //[self.drawerView.drawerTableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        
        
        
        }
        
    }
    
    
}

/*
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    
    CustomCellForSlider *cell = (CustomCellForSlider *)[tableView cellForRowAtIndexPath:indexPath];
  [self setCellColor:[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0] ForCell:cell];

    subCategoryLabel.textColor = [UIColor whiteColor];
    subCategoryLabel.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];

}


- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    
    CustomCellForSlider *cell = (CustomCellForSlider *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self setCellColor:[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0]  ForCell:cell];
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

*/

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
    
}



- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%ld",(long)indexPath.row);
       // subCategoryLabel.textColor = [UIColor whiteColor];
       // subCategoryLabel.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];
        
    //objectDataClass.rowIndex = indexPath.row;
    
    return YES;
}







@end

