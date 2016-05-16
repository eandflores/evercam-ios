//
//  WelcomeViewController.h
//  evercamPlay
//
//  Created by jw on 3/8/15.
//  Copyright (c) 2015 Evercam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface WelcomeViewController : GAITrackedViewController

@property (nonatomic, strong) IBOutlet UIView *tutorialView;
@property (nonatomic, strong) IBOutlet UIScrollView *tutorialScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *playerContainerView;
- (IBAction)onSignIn:(id)sender;
- (IBAction)onSignUp:(id)sender;

@end
