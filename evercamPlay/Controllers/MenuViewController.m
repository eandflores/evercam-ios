
/*
 
 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
 */

#import "MenuViewController.h"

#import "SWRevealViewController.h"
#import "CamerasViewController.h"
#import "AccountsViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "GlobalSettings.h"
#import "GAIDictionaryBuilder.h"
#import "Config.h"
#import "MenuViewControllerCell.h"
#import "PreferenceUtil.h"
#import "AboutViewController.h"
#import "Struts.h"
#import "GravatarServiceFactory.h"
#import "CamerasViewController.h"
@interface MenuViewController()
{
    NSInteger _presentedRow;
    CGRect portraitTableFrame;
}

@end

@implementation MenuViewController

@synthesize rearTableView = _rearTableView;


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    portraitTableFrame = self.rearTableView.frame;
    self.rearTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.rearTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.rearTableView setContentInset:UIEdgeInsetsMake(15, 0, 0, 0)];
    
    SWRevealViewController *revealController = [self revealViewController];
    UINavigationController *navigation = (UINavigationController *)revealController.frontViewController;
    
    NSLog(@"%@",revealController.frontViewController);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    self.appVersion.text = [NSString stringWithFormat:@"v%@", ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])];
    self.name.text =  [NSString stringWithFormat:@"%@ %@", ([APP_DELEGATE defaultUser].firstName), ([APP_DELEGATE defaultUser].lastName)];
    self.email.text = [APP_DELEGATE defaultUser].email;
    [GravatarServiceFactory requestUIImageByEmail:[APP_DELEGATE defaultUser].email defaultImage:gravatarServerImageMysteryMan size:72 delegate:self];
    
//    [self changeFrame];
    if ([PreferenceUtil isShowOfflineCameras]) {
        [self.cameraOffOn_Switch setOn:YES];
    } else {
        [self.cameraOffOn_Switch setOn:NO];
    }
    
}

-(void)gravatarServiceDone:(id<GravatarService>)gravatarService
                 withImage:(UIImage *)image{
    NSLog(@"gravatarServiceDone");
    self.profileImage.image = image;
}

-(void)gravatarService:(id<GravatarService>)gravatarService
      didFailWithError:(NSError *)error{
    NSLog(@"gravatarService");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    [self changeFrame];
}

-(void)changeFrame
{
    if ([GlobalSettings sharedInstance].isPhone)
    {
        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
        
        if (UIDeviceOrientationIsLandscape(deviceOrientation))
        {
            [self.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.height, self.view.frame.size.width)];
            CGRect frame = self.rearTableView.frame;
            frame.size.height = 191;
            self.rearTableView.frame = frame;
            
            frame = self.containerView.frame;
            frame.origin.y = 0;
            self.containerView.frame = frame;
        }
        else
        {
            self.rearTableView.frame = portraitTableFrame;
        }
    }
}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    MenuViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    
    if (cell == nil)
    {
        cell = [[MenuViewControllerCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    }
    
    NSString *text = nil;
    if (row == 0)
    {
        text = @"Accounts";
        cell.imageView.image = [UIImage imageNamed:@"ic_accounts.png"];
    }else if (row == 1)
    {
        text = @"Scan for cameras";
        cell.imageView.image = [UIImage imageNamed:@"ic_search.png"];
    }else if (row == 2)
    {
        text = @"Public cameras";
        cell.imageView.image = [UIImage imageNamed:@"ic_compass.png"];
    }
    else if (row == 3)
    {
        text = @"Settings";
        cell.imageView.image = [UIImage imageNamed:@"ic_settings.png"];
    }
    else if (row == 4)
    {
        text = @"Live Support";
        cell.imageView.image = [UIImage imageNamed:@"ic_feedback.png"];
    }
    cell.textLabel.text = NSLocalizedString( text,nil );
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    _presentedRow = row;  // <- store the presented row
    // otherwise we'll create a new frontViewController and push it with animation
    
    UIViewController *newFrontController = nil;
    
    if (row == 0 || row == 1 || row == 2 || row == 3 || row == 4)
    {
        row += 1;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"K_LOAD_SIDE_MENU_CONTROLLERS" object:[NSNumber numberWithInteger:row]];
        
        return;
    }
    
    else if (row == 4)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sign out", nil) message:NSLocalizedString(@"Are you sure you want to sign out?", nil) delegate:self cancelButtonTitle:@"No" otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
            simpleAlert.tag = 102;
            [simpleAlert show];
        });
        
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 102 && buttonIndex == 1) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category_menu
                                                              action:action_logout
                                                               label:label_user_logout
                                                               value:nil] build]];
        
        [APP_DELEGATE logout];
        _presentedRow = 0;
    }
}

- (IBAction)showOfflineModeChanged:(id)sender {
    NSLog(@"Navigation: %@",self.navigationController.viewControllers);
    UISwitch *switchView = (UISwitch *)sender;
    if ([switchView isOn]) {
        [PreferenceUtil setIsShowOfflineCameras:YES];
    } else {
        [PreferenceUtil setIsShowOfflineCameras:NO];
    }
    SWRevealViewController *revealController = [self revealViewController];
    UINavigationController *navigation = (UINavigationController *)revealController.frontViewController;
    CamerasViewController *cVC = (CamerasViewController *)navigation.viewControllers[0];
    [cVC onRefresh:cVC];
}

@end