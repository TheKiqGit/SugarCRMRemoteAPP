//
//  SRASugarCRMRemoteAuthenticationViewController.h
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 2/20/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRASugarCRMRemoteAuthenticationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *serverURL;

- (IBAction)SignIn:(id)sender;
- (IBAction)ForgotPassword:(id)sender;

@end
