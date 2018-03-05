//
//  SCHMvvmViewController.m
//  SCHProgress
//
//  Created by Mike on 2018/1/16.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "SCHMvvmViewController.h"
#import "SCHMvvmViewModel.h"
#import "SCHMvvmCell.h"

@interface SCHMvvmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) SCHTableView *tableView;
@end

@implementation SCHMvvmViewController

#pragma mark --- 创建tableView
- (SCHTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SCHTableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"SCHMvvmCell" bundle:nil] forCellReuseIdentifier:@"MvvmCellID"];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.初始化tableview
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
    
    
    //2.初始化 viewModel
    SCHMvvmViewModel *viewModel = [[SCHMvvmViewModel alloc] init];
    [viewModel loadProjectListData];
    [viewModel setDataBlockWithRetureSuccessBlock:^(id successValue) {
        //传递给tableView的数据源
        self.tableView.dataArray = [NSMutableArray arrayWithArray:successValue];
        [self.tableView reloadData];
        
    } RetureFailureBlock:^(id errorCode) {
        NSLog(@"errorCode == %@",errorCode);
    }];
    
    
}
/////////////////////////////////////代理方法////////////////////////////////////////
#pragma mark - tableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SCHMvvmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MvvmCellID"];
    cell.model = self.tableView.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
