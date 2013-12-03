//
//  ViewController.m
//  whiteWay
//
//  Created by Marcelo Sampaio on 11/9/13.
//  Copyright (c) 2013 Marcelo Sampaio. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

@synthesize backgroundMusicPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // configure Sound Track
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"whiteWay2" withExtension:@"caf"];
    
    
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
    // Configure the view.
    [self configureAndPresentView];
}

-(void)configureAndPresentView
{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}


// Esconder atatus bar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    NSLog(@"****************** device foi RODADO ********************");
//    NSLog(@"Width=%f",self.view.frame.size.width);
//    NSLog(@"Height=%f",self.view.frame.size.height);
//
//}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
@end
