//
//  OpenAndCloseViewController.m
//  IOSCategory
//
//  Created by Jeff on 2020/10/29.
//

#import "OpenAndCloseViewController.h"

#import "NSString+OpenAndClose.h"

@interface OpenAndCloseViewController ()

@end

@implementation OpenAndCloseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 0)];
    lbl.font = [UIFont systemFontOfSize:16];
    lbl.textColor = [UIColor blackColor];
    lbl.backgroundColor = [UIColor redColor];
    lbl.numberOfLines = 0;
    [self.view addSubview:lbl];
 
    //关闭
    lbl.attributedText = [@"测试测试测试测试测试测试测试测试测\n试测test试测试测试测试测试测试测试test测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测test试测试" getAttributeStrWithLblWidth:200 font:[UIFont systemFontOfSize:16] lineSpacing:5 paragraphSpacing:10 lineBreakMode:NSLineBreakByWordWrapping closeLineNum:3 openState:NO];
    //展开
    lbl.attributedText = [@"测试测试测试测试测试测试测试测试测\n试测test试测试测试测试测试测试测试test测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测test试测试" getAttributeStrWithLblWidth:200 font:[UIFont systemFontOfSize:16] lineSpacing:5 paragraphSpacing:10 lineBreakMode:NSLineBreakByWordWrapping closeLineNum:3 openState:YES];
    
    //调整frame
    [lbl sizeToFit];
    
    lbl.center = self.view.center;

}



@end
