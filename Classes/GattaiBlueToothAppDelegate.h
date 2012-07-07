//
//  GattaiBlueToothAppDelegate.h
//  GattaiBlueTooth
//
//  Created by 荻原 翔 on 10/10/11.
//  Copyright 2010 waseda-university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <AudioToolbox/AudioToolbox.h>
@class GattaiBlueToothViewController;

@interface GattaiBlueToothAppDelegate : NSObject <GKSessionDelegate,UIApplicationDelegate> {
    UIWindow *window;
    GattaiBlueToothViewController *viewController;
	
	UIBackgroundTaskIdentifier backgroundTask; // 下準備としてAppDelegateのメンバ変数を作っておきます。(マルチタスク用）
	GKSession *mySession;//GKSessionオブジェクトは、接続された2台のBluetoothデバイス間のセッションを表します。
	//このオブジェクトを使用して、2台のデバイス間でのデータの送受信を行います。
	int count;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GattaiBlueToothViewController *viewController;

@end

