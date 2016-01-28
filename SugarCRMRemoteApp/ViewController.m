//
//  ViewController.m
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 1/27/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import "ViewController.h"
#import "SugarCrmAPIRepository.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SugarCrmAPIRepository *crmRepo = [[SugarCrmAPIRepository alloc] init];
    [crmRepo requestTokenWithUserName:@"" andPassword:@""];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
