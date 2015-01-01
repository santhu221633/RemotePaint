//
//  MainVC.m
//  RemotePaint
//
//  Created by santhosh lakkanpalli on 01/01/15.
//  Copyright (c) 2015 com.santhosh. All rights reserved.
//

#import "MainVC.h"
#import "IPConnectionView.h"
#import "GCDAsyncSocket.h"
#import "PaintView.h"

extern NSString * getIPAddress(BOOL preferIPv4);

@interface MainVC ()<IPConnectionViewDelegate,GCDAsyncSocketDelegate,PaintDelegate>
@property (nonatomic,strong) GCDAsyncSocket *localSocket;
@property (nonatomic,strong) GCDAsyncSocket *remoteSocket;
@property (nonatomic,strong) PaintView *paintView;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) IPConnectionView *connectionView;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
}

-(void)startConnecting{
    
    _paintView = [[PaintView alloc] initWithFrame:self.view.bounds];
    _paintView.delegate = self;
    [self.view addSubview:_paintView];
    
    _connectionView = [[IPConnectionView alloc] initWithFrame:self.view.frame];
    _connectionView.isMaster = _isMaster;
    _connectionView.delegate = self;
    [_connectionView setUpView];
    [self.view addSubview:_connectionView];
    
    if (!_isMaster) {
        _paintView.userInteractionEnabled = false;
        _localSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *e;
        if([_localSocket acceptOnPort:1234 error:&e]){
            
        }
        else{
            NSLog(@"listen failed - %@",e);
        }
    }
}

#pragma mark - GCDSocket Delegate

-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    _remoteSocket = newSocket;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.connectionView removeFromSuperview];
        [newSocket readDataToLength:9 withTimeout:5 tag:1];
    });
}

/*
 To send CGPoint and whether it is touchBegan or touchMoved type of touch, we send them in a buffer
 We copy byte values stored in floats using memcpy
 To send touchBegan message, type=1, we attach it to the buffer and send it, similarly touchMoved is of type 2.
 
 So when we decode, we get the buffer and copy the bytes to floats to get CGPoint values.
 */

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    char buffer[9];
    [data getBytes:&buffer length:9];
    
    Float32 x,y;
    char type;
    memcpy(&x, buffer, sizeof(Float32));
    memcpy(&y, buffer + 4, sizeof(Float32));
    memcpy(&type, buffer + 8, sizeof(char));
    
//    NSLog(@" %f %f %c",x,y,type);
    
    if (type == '1') {
        [_paintView receivedTouchBegan:CGPointMake(x, y)];
    }
    else if (type == '2')
        [_paintView receivedTouchMoved:CGPointMake(x, y)];
    
    [sock readDataToLength:9 withTimeout:5 tag:1];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView removeFromSuperview];
    [self.connectionView removeFromSuperview];
}

-(void)hideConnectionView{

}

#pragma mark - IpConnectionViewDelegate Methods

-(NSString*)ipAddressOfSelf{
    return getIPAddress(true);
}

-(void)ipAddressOfSlave:(NSString *)addr{
    if (_isMaster) {    //ofcourse it will be master
        _localSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *e;
        if([_localSocket connectToHost:addr onPort:1234 error:&e]){
            _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            _activityIndicatorView.center = self.view.center;
            [_activityIndicatorView startAnimating];
            
            [self.view addSubview:_activityIndicatorView];
        }
        else{
            NSLog(@"connect failed - %@",e);
        }
    }
}

#pragma mark - PaintViewDelegate Methods

/*
 To send CGPoint and whether it is touchBegan or touchMoved type of touch, we send them in a buffer
 We copy byte values stored in floats using memcpy
 To send touchBegan message, type=1, we attach it to the buffer and send it, similarly touchMoved is of type 2
 */

-(void)touchBeganAtPoint:(CGPoint)point{
    char buffer[9];
    Float32 x = point.x;
    Float32 y =point.y;
    memcpy(buffer, &x, sizeof(Float32));
    memcpy(buffer + 4, &y, sizeof(Float32));
    buffer[8] = '1';
    NSData *data = [[NSData alloc] initWithBytes:buffer length:9];
    [_localSocket writeData:data withTimeout:5 tag:2];
}

-(void)touchMovedAtPoint:(CGPoint)point{
    char buffer[9];
    Float32 x = point.x;
    Float32 y =point.y;
    memcpy(buffer, &x, sizeof(Float32));
    memcpy(buffer + 4, &y, sizeof(Float32));
    buffer[8] = '2';
    NSData *data = [[NSData alloc] initWithBytes:buffer length:9];
    [_localSocket writeData:data withTimeout:5 tag:2];
}

@end












