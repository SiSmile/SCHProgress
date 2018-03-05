//
//  SCHBluetoothViewController.m
//  SCHProgress
//
//  Created by Mike on 2018/1/22.
//  Copyright © 2018年 Mike. All rights reserved.
//


/*
 在做蓝牙开发之前，最好先了解一些概念：
 服务（services）：蓝牙外设对外广播的必定会有一个服务，可能也有多个，服务下面包含着一些特征，服务可以理解成一个模块的窗口；
 特征（characteristic）：存在于服务下面的，一个服务下面也可以存在多个特征，特征可以理解成具体实现功能的窗口，一般特征都会有value，也就是特征值，特征是与外界交互的最小单位；
 UUID：可以理解成蓝牙上的唯一标识符（硬件上肯定不是这个意思，但是这样理解便于我们开发），为了区分不同的服务和特征，或者给服务和特征取名字，我们就用UUID来代表服务和特征。
 
 蓝牙连接可以大致分为以下几个步骤
 1.建立一个Central Manager实例进行蓝牙管理
 2.搜索外围设备
 3.连接外围设备
 4.获得外围设备的服务
 5.获得服务的特征
 6.从外围设备读数据
 7.给外围设备发送数据
 */

#import "SCHBluetoothViewController.h"
//蓝牙头文件
#import <CoreBluetooth/CoreBluetooth.h>

@interface SCHBluetoothViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSString *strAlert;
}

@property (strong , nonatomic) UITableView *tableView;

@property (strong , nonatomic) CBCentralManager *manager;//中央设备

@property (strong , nonatomic) CBPeripheral * discoveredPeripheral;//周边设备
@property (strong , nonatomic) CBCharacteristic *characteristic1;//周边设备服务特性

@property (assign , nonatomic) BluetoothFailState bluetoothFailState;
@property (assign , nonatomic) BluetoothState bluetoothState;


@property (strong , nonatomic) NSMutableArray *BleViewPerArr;

@end

@implementation SCHBluetoothViewController

#pragma mark --- 创建tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 130;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
    
    //2.开始扫描按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"scan开始" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-150);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@(50));
    }];
    
    
    //创建实例,设置代理,创建数组管理外设
    self.manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    self.BleViewPerArr = [[NSMutableArray alloc]initWithCapacity:1];
    
    
}
/////////////////////////////////////代理方法////////////////////////////////////////
#pragma mark - tableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.BleViewPerArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    }
    // 将蓝牙外设对象接出，取出name，显示
    //蓝牙对象在下面环节会查找出来，被放进BleViewPerArr数组里面，是CBPeripheral对象
    CBPeripheral *per=(CBPeripheral *)_BleViewPerArr[indexPath.row];
//    NSString *bleName=[per.name substringWithRange:NSMakeRange(0, 9)];
    cell.textLabel.text =per.name;
    return cell;
}


#pragma mark -- CBCentralManagerDelegate代理方法 判断当前设备蓝牙状态中央设备开始扫描
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
        switch (central.state) {
            case CBCentralManagerStatePoweredOff:
                NSLog(@"连接失败了\n请您再检查一下您的手机蓝牙是否开启，\n然后再试一次吧");
                strAlert = @"连接失败了\n请您再检查一下您的手机蓝牙是否开启，\n然后再试一次吧";
                _bluetoothFailState = BluetoothFailStateByOff;
                break;
            case CBCentralManagerStateResetting:
                _bluetoothFailState=BluetoothFailStateByTimeout;
                strAlert = @"蓝牙连接超时";
                break;
            case CBCentralManagerStateUnsupported:
                NSLog(@"检测到您的手机不支持蓝牙4.0\n所以建立不了连接.建议更换您\n的手机再试试。");
                strAlert = @"检测到您的手机不支持蓝牙4.0\n所以建立不了连接.建议更换您\n的手机再试试。";
                _bluetoothFailState = BluetoothFailStateByHW;
                break;
            case CBCentralManagerStateUnauthorized:
                NSLog(@"连接失败了\n请您再检查一下您的手机蓝牙是否开启，\n然后再试一次吧");
                strAlert = @"连接失败了\n请您再检查一下您的手机蓝牙是否开启，\n然后再试一次吧";
                _bluetoothFailState = BluetoothFailStateUnauthorized;
                break;
            case CBCentralManagerStateUnknown:
                _bluetoothFailState = BluetoothFailStateUnKnow;
                strAlert = @"蓝牙连接发生了未知名错误";
                break;
                
            case CBCentralManagerStatePoweredOn:
                _bluetoothFailState = BluetoothFailStateUnExit;
                strAlert = @"蓝牙关闭";
                // ... so start scanning
//                [self scan];
                break;
            default:
                break;
        }
}
- (void)scan{
    //如果蓝牙状态未开启，提示开启蓝牙
    if(_bluetoothFailState != BluetoothFailStateUnExit)
    {
        NSLog(@"%@",@"检查您的蓝牙是否开启后重试");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:strAlert preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        //    [alertController addAction:action];
        [alertVC addAction:action1];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
    //判断状态开始扫瞄周围设备 第一个参数为空则会扫瞄所有的可连接设备  你可以
    //指定一个CBUUID对象 从而只扫瞄注册用指定服务的设备
    //scanForPeripheralsWithServices方法调用完后会调用代理CBCentralManagerDelegate的
    //- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI方法
    //@[[CBUUID UUIDWithString:@"FF15"]]
    //@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }
    
    [self.manager scanForPeripheralsWithServices:nil options:nil];
    //记录目前是扫描状态
    _bluetoothState = BluetoothStateScaning;
    //清空所有外设数组
    [self.BleViewPerArr removeAllObjects];
    
    
}
//中央设备开始扫描之后，我们需要实现 centralManager:didDiscoverPeripheral:advertisementData:RSSI: 通过该回调来获取发现设备。
//这个回调说明着广播数据和信号质量(RSSI-Received Signal Strength Indicator)的周边设备被发现。通过信号质量，可以用判断周边设备离中央设备的远近。
/*
 *  发现外围设备调用
 *  @param central           中央设备管理器
 *  @param peripheral        外围设备
 *  @param advertisementData 设备信息
 *  @param RSSI              信号质量（信号强度）
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI方法{
    if (peripheral == nil||peripheral.identifier == nil/*||peripheral.name == nil*/)
    {
        return;
    }
    
    if([_BleViewPerArr containsObject:peripheral]==NO){
         [_BleViewPerArr addObject:peripheral];
    }
    
    /*
    NSString *pername=[NSString stringWithFormat:@"%@",peripheral.name];
    //判断是否存在@"你的设备名"
    NSRange range=[pername rangeOfString:@"SCHiPhone"];
    //如果从搜索到的设备中找到指定设备名，和BleViewPerArr数组没有它的地址
    //加入BleViewPerArr数组
    if(range.location!=NSNotFound&&[_BleViewPerArr containsObject:peripheral]==NO){
        [_BleViewPerArr addObject:peripheral];
    }
     */
     
    _bluetoothFailState = BluetoothFailStateUnExit;
    _bluetoothState = BluetoothStateScanSuccess;
    [_tableView reloadData];
}

//扫描到设备之后当然是链接设备了
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CBPeripheral *peripheral=(CBPeripheral *)_BleViewPerArr[indexPath.row];
    //设定周边设备，指定代理者
    _discoveredPeripheral = peripheral;
    _discoveredPeripheral.delegate = self;
    //连接设备
    //@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}
    [_manager connectPeripheral:peripheral
                        options:nil];
    
}
// 获取当前设备 已经连接上该设备，就可以获取当前设备的信息
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%@",peripheral);
    
    // 设置设备代理
    [peripheral setDelegate:self];
    // 大概获取服务和特征
    [peripheral discoverServices:nil];
    
    //或许只获取你的设备蓝牙服务的uuid数组，一个或者多个
    //[peripheral discoverServices:@[[CBUUID UUIDWithString:@""],[CBUUID UUIDWithString:@""]]];
    
    
    NSLog(@"Peripheral Connected");
    
    [_manager stopScan];
    
    NSLog(@"Scanning stopped");
    _bluetoothState=BluetoothStateConnected;
    
}
//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"error ==%@",error);
}
// 获取当前设备服务services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        return;
    }
    
    NSLog(@"所有的servicesUUID%@",peripheral.services);
    
    //遍历所有service
    for (CBService *service in peripheral.services)
    {
        
        NSLog(@"服务%@",service.UUID);
        
        //找到你需要的servicesuuid
//        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"你的设备服务的uuid"]])
//        {
            //监听它
            [peripheral discoverCharacteristics:nil forService:service];
//        }
    
        
        
    }
    NSLog(@"此时链接的peripheral：%@",peripheral);
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    NSLog(@"服务：%@",service.UUID);
    // 特征
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"%@",characteristic.UUID);
        //发现特征
        //注意：uuid 分为可读，可写，要区别对待！！！
        
        
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"你的特征uuid"]])
//        {
            NSLog(@"监听：%@",characteristic);//监听特征
            //保存characteristic特征值对象
            //以后发信息也是用这个uuid
            _characteristic1 = characteristic;
            
            [_discoveredPeripheral setNotifyValue:YES forCharacteristic:characteristic];
//        }
        
        //当然，你也可以监听多个characteristic特征值对象
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"你的特征uuid"]])
//        {
            //同样用一个变量保存，demo里面没有声明变量，要去声明
            //            _characteristic2 = characteristic;
            //            [peripheral setNotifyValue:YES forCharacteristic:_characteristic2];
            //            NSLog(@"监听：%@",characteristic);//监听特征
//        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"收到的数据：%@",characteristic.value);
}

@end
