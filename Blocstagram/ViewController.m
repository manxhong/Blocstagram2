//
//  ViewController.m
//  Blocstagram
//
//  Created by Man Hong Lee on 1/28/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import "ViewController.h"
#import "BLCMediaFullScreenViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BLCMediaFullScreenViewController *mediaFullScreenVC = [[BLCMediaFullScreenViewController alloc] init];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:mediaFullScreenVC action:nil];
    [mediaFullScreenVC.navigationItem setRightBarButtonItem:rightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
