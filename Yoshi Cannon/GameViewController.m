//
//  ViewController.m
//  Yoshi Cannon
//
//  Created by MMstudent on 4/6/14.
//  Copyright (c) 2014 mmstudent. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Get sound effect for launch
    NSString *path = [[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.rocketSFX = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_rocketSFX prepareToPlay];

    //get sound effect for power up
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"ding" ofType:@"mp3"];
    NSURL *url2 = [NSURL fileURLWithPath:path2];
    self.bugSFX= [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    [_bugSFX prepareToPlay];
    
    //get sound effect for bouncing off ground
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"bounce" ofType:@"mp3"];
    NSURL *url3 = [NSURL fileURLWithPath:path3];
    self.hitGroundSFX= [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:nil];
    [_hitGroundSFX prepareToPlay];
    
    //animation for fish and bug
    flyAnim = [self loadImagesForFilename:@"g" type:@"png" count:2];
    bugAnim = [self loadImagesForFilename:@"b" type:@"png" count:2];
    
    //gesture recognition for swiping
    UIPanGestureRecognizer *oneFingerSwipeRight = [[UIPanGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(oneFingerSwipeRight:)];
    //[oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    //set the size of the fish image
    _fish.frame=CGRectMake(37,157,60,40);
    _fish.contentMode = UIViewContentModeScaleAspectFit;
    
    // Property List.plist code
    //Gets paths from root direcory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //Get documents path.
    NSString *documentsPath = [paths objectAtIndex:0];
    
    //Get the path to our PList file.
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Score.plist"];
    
    //Check to see if Property List.plist exists in documents.
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        
        //If not in documents, get property list from main bundle.
        plistPath = [[NSBundle mainBundle] pathForResource:@"Score" ofType:@"plist"];
        
    }
    
    //Read property list into memory as an NSData object.
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    
    NSString *errorDesc = nil;
    
    NSPropertyListFormat format;
    
    //convert static property list into dictionary object.
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp){
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    //Assign values.
    NSString *tempStr = [temp objectForKey:@"score"];
    highScore = tempStr.intValue;
    _highScoreLabel.text = [NSString stringWithFormat:@"High Score: %d",highScore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)oneFingerSwipeRight:(UIPanGestureRecognizer *)recognizer {

    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {

    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {

    }
    
    else if (recognizer.state == UIGestureRecognizerStateEnded     ||
             recognizer.state == UIGestureRecognizerStateCancelled ||
             recognizer.state == UIGestureRecognizerStateFailed)
    {


        //Get speed depending on how fast the user swipes
        CGPoint velocity = [recognizer velocityInView: recognizer.view];
        speedX = velocity.x/80;
    }
    //Only read swipe when game hasn't started
    if (!gameStart) {
        [_rocketSFX play];
        UIImage * toImage = [UIImage imageNamed:@"j2.png"];
        [UIView transitionWithView:_flame duration:0.1f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _flame.frame = CGRectMake(-7, 186, 68, 45);
            _flame.image = toImage;
        } completion:^(BOOL finished) {
            _flame.hidden = true;
            _helpText.hidden = true;
            gameStart = true;
            [self flyToRight];
        }];
    }

}


- (void) flyToRight{
    _fish.transform = CGAffineTransformMakeRotation(-20 * M_PI/180);
    [UIView animateWithDuration:1 animations:^{
        _fish.frame=CGRectMake(398,20,60,40);
        _fish.contentMode = UIViewContentModeScaleAspectFit;
        _fish.transform = CGAffineTransformMakeRotation(0);
        
    } completion:^(BOOL finished) {
        [self flyDown];
    }];
}

- (void) flyDown{
    _fish.transform = CGAffineTransformMakeRotation(20 * M_PI/180);
    flyingDown = true;
    flyingUp = false;
}

- (void) flyUp {
    _fish.transform = CGAffineTransformMakeRotation(-20 * M_PI/180);
    flyingDown = false;
    flyingUp = true;
}

- (void) moveBackground {
    //
    
    _background1.frame = CGRectMake(_background1.frame.origin.x-speedX, 0, 568, 320);
    _background2.frame = CGRectMake(_background2.frame.origin.x-speedX, 0, 568, 320);
    
    
    if(_background1.frame.origin.x + _background1.frame.size.width <= 0){
        float whiteSpace = _background1.frame.origin.x + _background1.frame.size.width;
        
        
        _background1.frame = CGRectMake(_background1.frame.size.width + whiteSpace, 0, _background1.frame.size.width, _background1.frame.size.height);
        
        //_background2.frame = CGRectMake(_background2.frame.origin.x-speedX, 0, 568, 320);

    }
    else if (_background2.frame.origin.x + _background2.frame.size.width <= 0){

        float whiteSpace = _background2.frame.origin.x + _background2.frame.size.width;
        
        _background2.frame = CGRectMake(_background2.frame.size.width + whiteSpace, 0, _background2.frame.size.width, _background2.frame.size.height);


       // _background1.frame = CGRectMake(_background1.frame.origin.x-speedX, 0, 568, 320);
        
    }
}

- (void) moveBug {
    if (_bug.frame.origin.x < (-568+speedX)) {
        _bug.frame = CGRectMake(570+speedX, 147, 68, 64);
        bugInView = false;
    }
    _bug.frame = CGRectMake(_bug.frame.origin.x-speedX, 147, 68,64);
}

- (void) checkCollision{
    if(CGRectIntersectsRect(_fish.frame, _bug.frame)){
        [_bugSFX play];
        speedX = speedX + 30;
        _bug.frame = CGRectMake(570+speedX, 147, 68, 64);
        bugInView = false;
    }
}

- (void) update{
    _speedXLabel.text = [NSString stringWithFormat:@"SpeedX:%d",speedX];
   // _speedYLabel.text = [NSString stringWithFormat:@"SpeedY:%d",speedY];

    score++;
        score = score + 1;
        frameNum = frameNum + 1;
        /*Since we are working with ints we need to change the speed every 15 frames
         *instead of changing a decimal every frame*/
        if (frameNum > 15 && gameStart){
            /*drag slows you down 
             *in the future will implement actual drag*/
            speedX = speedX - 1;
            
            /*Simulate gravity, very basic*/
            if (flyingDown) {
                speedY = speedY + 2;
                //Simple implementation of terminal velocity
                if (speedY >= topSpeedY) {
                    speedY = topSpeedY;
                }
            }
            else{
                speedY = speedY - 4;
            }
            
            
            frameNum = 0;
        }

        if(_fish.frame.origin.y > 250 && flyingDown){
            [_hitGroundSFX play];
            speedX = speedX - 3;
            if (speedX <= 0) {
                [self endGame];
            }
            else{
                speedY =  speedY * .75 ;
                [self flyUp];
            }
        }
        
        if(speedY <= 0 && flyingUp){
            [self flyDown];
        }
    
        if (speedX>0) {

            if (bugInView && gameStart) {
                [self moveBug];
            }
            else if([self randomNumber0To1000] < 20 && gameStart){
                [self moveBug];
                bugInView = true;
            }
            [self moveBackground];
            [self checkCollision];
        }
        
        if (flyingDown) {
            _fish.frame = CGRectMake(398, _fish.frame.origin.y+speedY, 60, 40);
            
        }
        if (flyingUp) {
            _fish.frame = CGRectMake(398, _fish.frame.origin.y-speedY, 60, 40);
        }
    if (_fish.frame.origin.y < 0) {
        _upArrow.hidden =false;
        _upText.text = [NSString stringWithFormat:@"%3.0f", ((-1 *_fish.frame.origin.y)/10)];
        _upText.hidden = false;
    }
    else{
        _upArrow.hidden =true;
        _upText.hidden = true;
    }

}

- (void) endGame{
    [timer invalidate];
    _scoreLabel.text = [NSString stringWithFormat:@"Score: %d",score];
    [self setHighScore];
    [UIView animateWithDuration:2 animations:^{
        _scoreLabel.frame=CGRectMake(157,53,254,77);
        
    }
    completion:^(BOOL finished) {
                       _playAgainButton.hidden = false;
    }];
    
    
}

- (void) setHighScore {
    if (score > highScore) {
        highScore = score;
        _highScoreLabel.text = [NSString stringWithFormat:@"High Score: %d",highScore];
    }
    
    //Get paths from root direcory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //Get documents path.
    NSString *documentsPath = [paths objectAtIndex:0];
    
    //Get the path to our PList file.
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Score.plist"];

    
    //Create dictionary with values in UITextFields.
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: @(highScore), nil] forKeys:[NSArray arrayWithObjects: @"score", nil]];
    
    NSString *error = nil;
    
    //Create NSData from dictionary.
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    //Check is plistData exists.
    if(plistData){
        
        //Write plistData to our Properity List.plist file.
        [plistData writeToFile:plistPath atomically:YES];
        
    }
    else{
        NSLog(@"Error in saveData: %@", error);
    }
}


- (void) flyAnimate{
    [_fish stopAnimating];
    
    _fish.animationImages = flyAnim;
    _fish.animationDuration = 0.25;
    _fish.animationRepeatCount = 0;
    [_fish startAnimating];
}

- (void) bugAnimate{
    [_bug stopAnimating];
    
    _bug.animationImages = bugAnim;
    _bug.animationDuration = 0.25;
    _bug.animationRepeatCount = 0;
    [_bug startAnimating];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self flyAnimate];
    [self bugAnimate];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    topSpeedX = 80;
    topSpeedY = 20;
    flyingDown = false;
    flyingUp = false;
    gameStart = false;
    frameNum = 0;
    /* Future implementation of actual drag*/
    dragC = .10;
    speedX = 4;
    speedY = 5;
    timer = [NSTimer scheduledTimerWithTimeInterval:1/30.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
 
    
}

-(NSMutableArray*)loadImagesForFilename:(NSString *)filename type:(NSString*)extension count:(int)count {
    NSMutableArray *images = [NSMutableArray array];
    for(int i=1; i<= count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d.%@", filename, i, extension]];
        if(image != nil)
            [images addObject:image];
    }
    return images;
}

-(float)randomNumber0To1000 {
    return (arc4random()%1000);
}

//Old way of keeping data using standardUserDefaults
-(void)addScore {
    NSMutableArray *scores = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"scores"]];
    [scores addObject:@{@"score" : @(score)}];
    [[NSUserDefaults standardUserDefaults] setObject:scores forKey:@"scores"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (IBAction)playAgain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
