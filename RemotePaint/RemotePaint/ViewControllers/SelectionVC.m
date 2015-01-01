//
//  SelectionVC.m
//  RemotePaint
//
//  Created by santhosh lakkanpalli on 01/01/15.
//  Copyright (c) 2015 com.santhosh. All rights reserved.
//

#import "SelectionVC.h"
#import "MainVC.h"

@interface SelectionVC ()

@end

@implementation SelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Selection Phase";
}


- (IBAction)masterClicked:(id)sender {
    MainVC *mainVC = [[MainVC alloc] init];
    mainVC.isMaster = true;
    [self.navigationController pushViewController:mainVC animated:true];
    [mainVC startConnecting];
}

- (IBAction)slaveClicked:(id)sender {
    
    MainVC *mainVC = [[MainVC alloc] init];
    mainVC.isMaster = false;
    [self.navigationController pushViewController:mainVC animated:true];
    [mainVC startConnecting];    
}

@end
