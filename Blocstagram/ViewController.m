//
//  ViewController.m
//  Blocstagram
//
//  Created by Man Hong Lee on 1/28/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import "ViewController.h"
#import "BLCMediaFullScreenViewController.h"
#import <Crashlytics/Crashlytics.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 50, 100, 30);
    [button setTitle:@"Crash" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    BLCMediaFullScreenViewController *mediaFullScreenVC = [[BLCMediaFullScreenViewController alloc] init];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:mediaFullScreenVC action:nil];
    [mediaFullScreenVC.navigationItem setRightBarButtonItem:rightButton];
}

- (IBAction)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
