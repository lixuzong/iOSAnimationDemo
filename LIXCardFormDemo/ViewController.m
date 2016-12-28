//
//  ViewController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/11/28.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "ViewController.h"
#import "LIXCardForm.h"
#import "LIXDynamicViewController.h"

@interface ViewController ()<LIXCardFormDataSource>

@property (nonatomic, strong) LIXCardForm *cardForm;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UISegmentedControl *layoutChangeSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"liner",@"coverFlow"]];
    layoutChangeSegmentControl.selectedSegmentIndex = 1;
    [layoutChangeSegmentControl addTarget:self  action:@selector(layoutChangeSegmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = layoutChangeSegmentControl;
    
    self.cardForm = [[LIXCardForm alloc] initWithFrame:self.view.bounds];
    _cardForm.translatesAutoresizingMaskIntoConstraints = YES;
    _cardForm.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _cardForm.dataSource = self;
    [self.view addSubview:_cardForm];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)layoutChangeSegmentedControlDidChangeValue:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        self.cardForm.type = LIXCardFormType_Linear;
    }
    else {
        self.cardForm.type = LIXCardFormType_CoverFlow;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - LIXCardFormDataSource

- (NSInteger)numberOfItemsInCardForm:(LIXCardForm *)cardForm {
    return 30;
}

- (UIView *)cardForm:(LIXCardForm *)cardForm viewForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor yellowColor];
        view;
    });
}

@end
