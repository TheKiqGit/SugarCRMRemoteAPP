//
//  ViewController.m
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 1/27/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import "ViewController.h"
#import "SRASugarCRMRemoteService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    SRASugarCRMRemoteService *SugarService = [SRASugarCRMRemoteService sharedInstance];
    NSURL *url = [NSURL URLWithString:@"http://localhost/Dev_SugarIntegracion-test/" ];
    
    [SugarService signInWithUserName:@"tecnisys_migrador" password:@"Prueba123" ServerURL:url success:^(NSDictionary *data) {
        NSLog(@"made it!");
        
    } failure:^(NSError *error) {
        NSLog(@"failed");
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
