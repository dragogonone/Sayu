//
//  GameViewController.h
//  Sayu
//
//  Created by USER on 2014/02/09.
//  Copyright (c) 2014年 USER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultViewController.h"
#import "AppDelegate.h"

@interface GameViewController : UIViewController{
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) UILabel *ScoreLbl;
@property (strong, nonatomic) UILabel *FlickLbl;
@property (strong, nonatomic) UILabel *spuplbl;
@property (strong, nonatomic) UILabel *flklbl;

//@property NSInteger score;
//@property NSInteger tgcnt;

//- (IBAction)kaributton:(id)sender;
//- (IBAction)Testbtn:(id)sender;

- (void) Start;
- (void) Moveyaji:(NSTimer *)timer;
- (void) Plusyaji;
- (void) Swiped:(int)swipedirection;
- (void) SwipeFailure;
- (void) TimerStop;

@end
