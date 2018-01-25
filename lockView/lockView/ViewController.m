//
//  ViewController.m
//  lockView
//
//  Created by Shaoting Zhou on 2018/1/24.
//  Copyright © 2018年 Shaoting Zhou. All rights reserved.
//

#import "ViewController.h"
#import "NineLockView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <NineLockViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    NineLockView * lockView = [[NineLockView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    lockView.delegete = self;
    [self.view addSubview:lockView];
}

-(void)lockView:(NineLockView *)lockView didFinishPath:(NSString *)path{
    if(path.length <= 3){
        NSLog(@"请至少连4个点");
        return;
    }
    if([path isEqualToString:@"01258"]){
        NSLog(@"OK");
    }else{
        NSLog(@"error");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
