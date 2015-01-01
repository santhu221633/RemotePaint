//
//  MainVC.h
//  RemotePaint
//
//  Created by santhosh lakkanpalli on 01/01/15.
//  Copyright (c) 2015 com.santhosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainVC : UIViewController

@property (nonatomic,assign) BOOL isMaster;

-(void)startConnecting;

@end
