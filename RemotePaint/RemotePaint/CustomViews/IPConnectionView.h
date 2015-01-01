//
//  IPConnectionView.h
//  RemotePaint
//
//  Created by santhosh lakkanpalli on 01/01/15.
//  Copyright (c) 2015 com.santhosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPConnectionViewDelegate <NSObject>

@required
-(void)ipAddressOfSlave:(NSString *)addr;
-(NSString *)ipAddressOfSelf;

@end

@interface IPConnectionView : UIView

@property (nonatomic,assign) BOOL isMaster;
@property (nonatomic,weak) id<IPConnectionViewDelegate> delegate;

-(void)setUpView;

@end
