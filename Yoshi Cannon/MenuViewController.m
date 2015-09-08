//
//  MenuViewController.m
//  Bird Cannon
//
//  Created by MMstudent on 4/6/14.
//  Copyright (c) 2014 mmstudent. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_backgroundMusic prepareToPlay];
    
    _backgroundMusic.numberOfLoops = -1;
    
    [_backgroundMusic play];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameViewController *gameViewController = segue.destinationViewController;
    
    gameViewController.menuViewController = self;
}*/

// this method checks the contents of the the nameTextField, filters out spaces, and if blank, displays an alert
/*
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSString *noWhiteSpace = [_nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(noWhiteSpace.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Your Name" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    return noWhiteSpace.length>0;
}*/

//this method dismisses the keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_nameTextField resignFirstResponder];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
