//
//  ViewController.h
//  Yoshi Cannon
//
//  Created by MMstudent on 4/6/14.
//  Copyright (c) 2014 mmstudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "MenuViewController.h"

@interface GameViewController : UIViewController{
    NSMutableArray *flyAnim, *bugAnim;
    NSTimer *timer;
    BOOL flyingDown;
    BOOL flyingUp;
    BOOL gameStart;
    BOOL bugInView;
    CGFloat screenWidth;
    CGFloat screenHeight;
    int speedX;
    int speedY;
    int topSpeedX;
    int topSpeedY;
    int score;
    int highScore;
    int frameNum;
    double dragC;
}

@property (weak, nonatomic) MenuViewController *menuViewController;

@property (strong, nonatomic) AVAudioPlayer *rocketSFX;
@property (strong, nonatomic) AVAudioPlayer *hitGroundSFX;
@property (strong, nonatomic) AVAudioPlayer *bugSFX;


@property (strong, nonatomic) IBOutlet UIImageView *background1;
@property (strong, nonatomic) IBOutlet UIImageView *background2;
@property (strong, nonatomic) IBOutlet UIImageView *fish;
@property (strong, nonatomic) IBOutlet UIImageView *flame;
@property (strong, nonatomic) IBOutlet UIImageView *bug;

@property (strong, nonatomic) IBOutlet UILabel *upText;
@property (strong, nonatomic) IBOutlet UIImageView *upArrow;
@property (strong, nonatomic) IBOutlet UILabel *speedXLabel;
@property (strong, nonatomic) IBOutlet UILabel *speedYLabel;
@property (strong, nonatomic) IBOutlet UILabel *helpText;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *playAgainButton;
- (IBAction)playAgain:(id)sender;

@end
