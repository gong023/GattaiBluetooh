//
//  FlipsideViewController.h
//  GattaiBlueTooth
//
//  Created by 荻原 翔 on 10/12/06.
//  Copyright 2010 waseda-university. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UISwitch *switchButton1;
	//BOOL gouseiFlag;
	
	IBOutlet UISwitch *switchButton2;
	//BOOL suretigaiFlag;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end