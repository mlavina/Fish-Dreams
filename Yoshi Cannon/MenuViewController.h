//
//  MenuViewController.h
//  Bird Cannon
//
//  Created by MMstudent on 4/6/14.
//  Copyright (c) 2014 mmstudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface MenuViewController : UIViewController <UITextFieldDelegate>  {
   }

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) AVAudioPlayer *backgroundMusic;


@end
