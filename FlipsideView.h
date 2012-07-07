//
//  FlipsideView.h
//  GattaiBlueTooth
//
//  Created by 荻原 翔 on 10/12/06.
//  Copyright 2010 waseda-university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GattaiBluetoothViewcontroller.h"

 

@protocol FlipsideViewDelegate;
@interface FlipsideView : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <FlipsideViewDelegate> delegate;
- (IBAction)done:(id)sender;
@end


@protocol FlipsideViewDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
