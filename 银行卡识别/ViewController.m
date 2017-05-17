//
//  ViewController.m
//  银行卡识别
//
//  Created by lalala on 2017/5/17.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "ViewController.h"
#import "CardIO.h"
#import "Masonry.h"


@interface ViewController ()<CardIOPaymentViewControllerDelegate>

@property (nonatomic,weak) UIButton *button;

@end

@implementation ViewController
-(UIButton *)button{
    if (_button == nil) {
       UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:@"扫描银行卡" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(scanBankCard:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        
        _button = button;
        [self.view addSubview:_button];
    }
    return _button;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //预加载
    [CardIOUtilities preload];
}
-(void)scanBankCard:(UIButton *)sender{
    CardIOPaymentViewController * cardIOPaymentViewController = [[CardIOPaymentViewController alloc]initWithPaymentDelegate:self];
    [self presentViewController:cardIOPaymentViewController animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@44);
        make.width.equalTo(@100);
    }];
}

#pragma mark -- CardIOPaymentViewControllerDelegate
//取消扫描的时候调用
-(void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
    NSLog(@"取消了扫描");
    [self dismissViewControllerAnimated:YES completion:nil];
}
//扫描完银行卡之后读到了相关信息后调用
-(void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
    //扫描到的相关的信息的处理
    NSString * redactedCardNumber = cardInfo.redactedCardNumber;
    NSUInteger expiryYear = cardInfo.expiryYear;
    NSUInteger expiryMonth = cardInfo.expiryMonth;
    NSString * cvv = cardInfo.cvv;
    
    NSLog(@"银行卡号%@,年%lu,月%lu, cvv%@",redactedCardNumber,expiryYear,expiryMonth,cvv);
    
}


@end
