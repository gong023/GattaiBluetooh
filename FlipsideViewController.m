//
//  FlipsideViewController.m
//  GattaiBlueTooth
//
//  Created by 荻原 翔 on 10/12/06.
//  Copyright 2010 waseda-university. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController
@synthesize delegate;


- (IBAction)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[switchButton1 addTarget:self action:@selector(gouseiButton) forControlEvents:UIControlEventValueChanged];
	[switchButton2 addTarget:self action:@selector(suretigaiButton) forControlEvents:UIControlEventValueChanged];
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	int integer = [defaults integerForKey:@"INTEGER"];
	/*
	if (![defaults integerForKey:@"INTEGER"]){
		integer=1;		
	}else*/ 
	if(integer==1){
		[switchButton1 setOn:YES animated:NO];
	}else if(integer==0){
		[switchButton1 setOn:NO animated:NO];
	}
	
	NSUserDefaults* suretigaidefaults = [NSUserDefaults standardUserDefaults];
	BOOL suretigai = [suretigaidefaults integerForKey:@"isValid"];
	
	if (suretigai==YES) {
		[switchButton2 setOn:YES animated:NO];
	}else if (suretigai==NO) {
		[switchButton2 setOn:NO animated:NO];
	}

}
-(void)gouseiButton{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	if(switchButton1.on==YES){
		[defaults setInteger:1 forKey:@"INTEGER"];//[defaults setBool:gouseiFlag forKey:@"isValid"];
	}else  {
		[defaults setInteger:0 forKey:@"INTEGER"];//[defaults setBool:gouseiFlag forKey:@"isValid"];
	}
	NSLog(@"合成スイッチ");
	[defaults synchronize];

}

-(void)suretigaiButton{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	if(switchButton2.on==YES){
		[defaults setBool:YES forKey:@"isValid"];
	}else  {
		[defaults setBool:NO forKey:@"isValid"];
	}
	NSLog(@"すれ違いスイッチ");
	[defaults synchronize];
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
