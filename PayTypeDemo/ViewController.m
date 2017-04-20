//
//  ViewController.m
//  PayTypeDemo
//
//  Created by 宇玄丶 on 2017/4/20.
//  Copyright © 2017年 北京116科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "AppPay.h"

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSArray *titleArray;
@property(nonatomic,assign)NSInteger selectedPaymentIndex;
@property(nonatomic,strong)UIView *bottomBar;
@property(nonatomic,strong)UIButton *confirmPayBtn;
@property(nonatomic,copy)NSString *order_id;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, 44);
    [confirmBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    confirmBtn.backgroundColor = [UIColor redColor];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn addTarget:self action:@selector(confirmPayBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmBtn];

    self.tableView.tableFooterView = footerView;
    
    
    [self loadData];
    
}

- (void)loadData {
    self.titleArray = @[@"支付宝",@"微信"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"OrderPayCell%ld%ld", indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
   if (indexPath.section==0) {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        cell.textLabel.text = @"请选择支付方式：";
    }
    else if (indexPath.section==1) {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [selectedBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
            [selectedBtn setImage:[UIImage imageNamed:@"ic_selected"] forState:UIControlStateSelected];
            selectedBtn.tag = 100;
            selectedBtn.userInteractionEnabled = NO;
            [cell.contentView addSubview:selectedBtn];
            selectedBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH - 10, 44);

        }
        cell.textLabel.text = self.titleArray[indexPath.row];
        UIButton *selectedBtn = [cell.contentView viewWithTag:100];
        selectedBtn.selected = indexPath.row==self.selectedPaymentIndex;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 44;
    }
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        NSLog(@"%ld",(long)self.selectedPaymentIndex);
        self.selectedPaymentIndex = indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)confirmPayBtnAction {
    /**
       order_id : 一般在做支付的情况下都是传一个order_id
       type     : 如图所示，有两种常用的支付方式,"微信支付"、"支付宝支付"，因为接口给的是上传的参数需要type，所以这么写的，根据自己需求改一改即可。
     */
    [[AppPay sharedInstance] payWithOrderId:self.order_id type:self.selectedPaymentIndex+1  payFinishBlock:^{
        NSLog(@"%ld",(long)self.selectedPaymentIndex+1);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
