//
//  SCHBluetoothViewController.h
//  SCHProgress
//
//  Created by Mike on 2018/1/22.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "SCHBaseViewController.h"
typedef NS_ENUM(NSInteger, BluetoothState){
    BluetoothStateDisconnect = 0,
    BluetoothStateScanSuccess,
    BluetoothStateScaning,
    BluetoothStateConnected,
    BluetoothStateConnecting
};

typedef NS_ENUM(NSInteger, BluetoothFailState){
    BluetoothFailStateUnExit = 0,
    BluetoothFailStateUnKnow,
    BluetoothFailStateByHW,
    BluetoothFailStateByOff,
    BluetoothFailStateUnauthorized,
    BluetoothFailStateByTimeout
};

@interface SCHBluetoothViewController : SCHBaseViewController

@end
