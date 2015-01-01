//
//  IPConnectionView.m
//  RemotePaint
//
//  Created by santhosh lakkanpalli on 01/01/15.
//  Copyright (c) 2015 com.santhosh. All rights reserved.
//

#import "IPConnectionView.h"

extern NSString * getIPAddress(BOOL preferIPv4);

@implementation IPConnectionView{
    BOOL _isMaster;
}

-(instancetype)initWithFrame:(CGRect)frame isMaster:(BOOL)master{
    self = [super initWithFrame:frame];
    if (self) {
        _isMaster = master;

        UIFont *font = [UIFont systemFontOfSize:20];
        if (_isMaster) {
            UILabel *helperLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, frame.size.width - 40, 60)];
            helperLabel.font = font;
            helperLabel.textColor = [UIColor whiteColor];
            helperLabel.text = @"Please find the ip of slave and enter in this device";
            helperLabel.textAlignment = NSTextAlignmentCenter;

            UITextField *ipEntryTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 170, frame.size.height - 120, 40)];
            ipEntryTextField.textColor = [UIColor whiteColor];
            ipEntryTextField.borderStyle = UITextBorderStyleRoundedRect;
            ipEntryTextField.textAlignment = NSTextAlignmentLeft;
            ipEntryTextField.font = [UIFont systemFontOfSize:23];

            [self addSubview:helperLabel];
            [self addSubview:ipEntryTextField];
        }
        else{
            NSString *ipv4 = getIPAddress(true);
            NSString *message = [NSString stringWithFormat:@"ip address of your device - %@.\nPlease enter in master device",ipv4];
            
            UILabel *ipDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, frame.size.width - 40, 100)];
            ipDisplayLabel.text = message;
            ipDisplayLabel.textColor = [UIColor whiteColor];
            ipDisplayLabel.textAlignment = NSTextAlignmentCenter;
            ipDisplayLabel.font = font;
            [self addSubview:ipDisplayLabel];
        }
    }
    return self;
}



@end
