//
//  IPConnectionView.m
//  RemotePaint
//
//  Created by santhosh lakkanpalli on 01/01/15.
//  Copyright (c) 2015 com.santhosh. All rights reserved.
//

#import "IPConnectionView.h"


@interface IPConnectionView ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *ipEntryTextField;
@end

@implementation IPConnectionView

@synthesize ipEntryTextField = ipEntryTextField;
-(void)setUpView{
    self.backgroundColor = [UIColor colorWithWhite:.3 alpha:.7];
    
    UIFont *font = [UIFont systemFontOfSize:20];
    if (_isMaster) {
        UILabel *helperLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.frame.size.width - 40, 60)];
        helperLabel.font = font;
        helperLabel.textColor = [UIColor whiteColor];
        helperLabel.text = @"Please find the ip of slave and enter in this device";
        helperLabel.textAlignment = NSTextAlignmentCenter;
        helperLabel.numberOfLines =0;
        
        ipEntryTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 170, self.frame.size.width - 120, 40)];
        ipEntryTextField.textColor = [UIColor blackColor];
        ipEntryTextField.borderStyle = UITextBorderStyleRoundedRect;
        ipEntryTextField.textAlignment = NSTextAlignmentLeft;
        ipEntryTextField.font = [UIFont systemFontOfSize:23];
        ipEntryTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        ipEntryTextField.returnKeyType = UIReturnKeyDone;
        ipEntryTextField.delegate = self;
        [self addSubview:helperLabel];
        [self addSubview:ipEntryTextField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybooardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    else{
        NSString *ipv4 = [self.delegate ipAddressOfSelf];
        NSString *message = [NSString stringWithFormat:@"ip address of your device :\n%@\nPlease enter in master device",ipv4];
        
        UILabel *ipDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.frame.size.width - 40, 100)];
        ipDisplayLabel.text = message;
        ipDisplayLabel.numberOfLines = 0;
        ipDisplayLabel.textColor = [UIColor whiteColor];
        ipDisplayLabel.textAlignment = NSTextAlignmentCenter;
        ipDisplayLabel.font = font;
        [self addSubview:ipDisplayLabel];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [ipEntryTextField resignFirstResponder];
    return YES;
}

-(void)keybooardDidHide:(NSNotification *)notif{
    NSString *ip = [ipEntryTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.delegate ipAddressOfSlave:ip];
}


@end
