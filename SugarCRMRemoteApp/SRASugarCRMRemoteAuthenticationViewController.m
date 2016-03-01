//
//  SRASugarCRMRemoteAuthenticationViewController.m
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 2/20/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import "SRASugarCRMRemoteAuthenticationViewController.h"
#import "SRASugarCRMRemoteService.h"

@implementation SRASugarCRMRemoteAuthenticationViewController

#pragma mark - Login Methods

- (IBAction)SignIn:(id)sender
{
    __weak typeof(self) weakSelf = self;
    NSURL *URL = [NSURL URLWithString:self.serverURL.text];
    
    [[SRASugarCRMRemoteService sharedInstance] signInWithUserName:self.userName.text password:self.password.text ServerURL:URL success:^(NSDictionary *OauthData) {
        
    } failure:^(NSError *error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to sign in" message:@"Username or password incorrect" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@",error.localizedDescription);
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}


- (IBAction)ForgotPassword:(id)sender
{
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTexfieldsDelegate];
    self.serverURL.text = [[[SRASugarCRMRemoteService sharedInstance] ServerRoot] absoluteString]; ;

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - UITexfield Delegate methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private helper methods

- (void)setTexfieldsDelegate
{
    [self.userName setDelegate:self];
    [self.password setDelegate:self];
    [self.serverURL setDelegate:self];
}

@end
