//
//  ViewController.m
//  RemotePaint
//
//  Created by santhosh lakkanpalli on 01/01/15.
//  Copyright (c) 2015 com.santhosh. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "PaintView.h"

extern NSString * getIPAddress(BOOL preferIPv4);

@interface ViewController ()<GCDAsyncSocketDelegate,PaintDelegate>{
    PaintView *paintView;
    BOOL isSendingSocket;
    GCDAsyncSocket *localSocket;
    GCDAsyncSocket *remoteSocket;
}
@property (nonatomic,strong) GCDAsyncSocket *socket;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"%@",getIPAddress(true));
    return;
    
    
    paintView = [[PaintView alloc] initWithFrame:self.view.bounds];
    paintView.delegate = self;
    [self.view addSubview:paintView];
    
    //    isSendingSocket = 1;
    
    if (!isSendingSocket) {
        localSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *e;
        if([localSocket acceptOnPort:1234 error:&e]){
            
        }
        else{
            NSLog(@"listen failed - %@",e);
        }
        
    }
    else{
        localSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *e;
        if([localSocket connectToHost:@"192.168.1.4" onPort:1234 error:&e]){
            
        }
        else{
            NSLog(@"connect failed - %@",e);
        }
        
    }
    
}


-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    remoteSocket = newSocket;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [newSocket readDataToLength:9 withTimeout:5 tag:1];
    });
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    char buffer[9];
    [data getBytes:&buffer length:9];
    
    Float32 x,y;
    char type;
    memcpy(&x, buffer, sizeof(Float32));
    memcpy(&y, buffer + 4, sizeof(Float32));
    memcpy(&type, buffer + 8, sizeof(char));
    
    NSLog(@" %f %f %c",x,y,type);
    
    if (type == '1') {
        [paintView receivedTouchBegan:CGPointMake(x, y)];
    }
    else if (type == '2')
        [paintView receivedTouchMoved:CGPointMake(x, y)];
    
    
    [sock readDataToLength:9 withTimeout:5 tag:1];
}


-(void)touchBeganAtPoint:(CGPoint)point{
    char buffer[9];
    Float32 x = point.x;
    Float32 y =point.y;
    memcpy(buffer, &x, sizeof(Float32));
    memcpy(buffer + 4, &y, sizeof(Float32));
    buffer[8] = '1';
    NSData *data = [[NSData alloc] initWithBytes:buffer length:9];
    [localSocket writeData:data withTimeout:5 tag:2];
}

-(void)touchMovedAtPoint:(CGPoint)point{
    char buffer[9];
    Float32 x = point.x;
    Float32 y =point.y;
    memcpy(buffer, &x, sizeof(Float32));
    memcpy(buffer + 4, &y, sizeof(Float32));
    buffer[8] = '2';
    NSData *data = [[NSData alloc] initWithBytes:buffer length:9];
    [localSocket writeData:data withTimeout:5 tag:2];
}

@end



















