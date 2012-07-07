//
//  GattaiBlueToothViewController.h
//  GattaiBlueTooth
//
//  Created by 荻原 翔 on 10/10/11.
//  Copyright 2010 waseda-university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FlipsideViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GattaiBlueToothViewController : UIViewController
<GKSessionDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate,FlipsideViewControllerDelegate>{
	IBOutlet UIButton *connect;
	IBOutlet UIButton *disconnect;
	IBOutlet UIImageView *imageView;
	UIImage*    shrinkedImage;
	
	IBOutlet UIActivityIndicatorView *indicator;
	IBOutlet UILabel *label;
	
	GKSession *mySession;
	
	IBOutlet UIImageView *hozon;
	IBOutlet UILabel *label2;
}

@property (nonatomic, retain) GKSession *mySession;
@property (nonatomic, retain) UIButton *connect;
@property (nonatomic, retain) UIButton *disconnect;
@property(nonatomic,retain) NSData* sendData;
@property(nonatomic,retain)UIActionSheet*  actionsheet1;
@property(nonatomic,retain)UIActionSheet*  actionsheet2;
@property(nonatomic,retain)UIAlertView *saveAlert;
@property(nonatomic,retain)UIAlertView *connectionAlert;
@property(nonatomic,retain)UIAlertView *sendAlert;

-(IBAction) btnSend:(id) sender;
-(IBAction) btnConnect:(id) sender;
-(IBAction) btnDisconnect:(id) sender;

-(IBAction)showCameraSheet;
-(IBAction)saveImage:(id)sender;

- (IBAction)showInfo:(id)sender;

-(IBAction)itazura:(id)sender;

-(void)showactionSheet1;
-(void)showactionSheet2;

@end

