//
//  GattaiBlueToothViewController.m
//  GattaiBlueTooth
//
//  Created by 荻原 翔 on 10/10/11.
//  Copyright 2010 waseda-university. All rights reserved.
//

#import "GattaiBlueToothViewController.h"
#import "FlipsideViewController.h"
#define kSessionID @"_tashounoen"


@implementation GattaiBlueToothViewController
@synthesize mySession,connect,disconnect,sendData,actionsheet1,actionsheet2,saveAlert,connectionAlert,sendAlert;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[connect setHidden:NO];
    [disconnect setHidden:YES];
	
	//indicatorの準備
	indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.frame = CGRectMake(130.0f, 180.0f, 60.0, 60.0);
	[self.view addSubview:indicator];
	[indicator setHidden:YES];
	
	label.text=@"カメラロールから写真を選んでくれよな";
	label2.hidden=YES;
	hozon.hidden=YES;
	
	NSString *path = [[NSBundle mainBundle]pathForResource:@"mascot"
													ofType:@"jpg"];
	shrinkedImage= [[UIImage alloc] initWithContentsOfFile:path];
	imageView.image=shrinkedImage;
	 
}
//**********************************************************************************//
//***************************画面きりかえ**********************************************//

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}
//**********************************************************************************//
//******************************画像の送受信*******************************************//

//↓のメソッドはアラートでOKが出された時にしか作動しないようにする
//”When two users with a device running the application attempt to connect, 
//it automatically sends photos via BlueTooth without confirming the users' intention to connect to other devices in the vicinity.”
- (void) mySendDataToPeers
{
    if (mySession) 
        [mySession sendDataToAllPeers:sendData 
						 withDataMode:GKSendDataReliable 
								error:nil];
    NSLog(@"data is sent");
}

//ここではアラートを出すだけ。
-(IBAction) btnSend:(id) sender
{
	sendAlert =	[[UIAlertView alloc] initWithTitle:@"送信" message:@"このまま送信していいか？"
										  delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"はい", nil];
	[sendAlert show];
	
}

- (void)receiveData:(NSData *)data 
		   fromPeer:(NSString *)peer 
		  inSession:(GKSession *)session 
			context:(void *)context {
	
	UIImage *receivedImage = [UIImage imageWithData:data];
	NSLog(@"data is received");
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	int integer = [defaults integerForKey:@"INTEGER"];
	
    if(integer==1){
		CGSize size = { 320, 460 };
		UIGraphicsBeginImageContext(size);
		CGRect rect;
		rect.origin = CGPointZero;
		rect.size = size;
		
		// レイヤー１　ベースになる画像
		[shrinkedImage drawInRect:rect];
		// レイヤー２ 透明度を指定して重ね合わせる
		[receivedImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:0.5];
		
		UIImage* kasaneImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		shrinkedImage=kasaneImage;
		imageView.image = kasaneImage;
		NSLog(@"integre=1");
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"写真を受信したぞ！" 
														message:@"お前の写真にいたずらしたぞ!"//str 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		
	}else if(integer==0){
		imageView.image=receivedImage;
		shrinkedImage=receivedImage;
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"写真を受信したぞ！" 
														message:@"今回はいたずらしなかったぞ"//str 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		NSLog(@"integre=0");
	}else {
		NSLog(@"else");
	}
	
    label.text=@"ちゃんと交換できたな。うん。";
	
}




//**********************************************************************************//
//***************************接続（GKSession）***************************************//


-(IBAction) btnConnect:(id) sender {
    [connect setHidden:YES];
    [disconnect setHidden:NO];
    
	mySession = [[GKSession alloc] initWithSessionID:kSessionID displayName:nil sessionMode:GKSessionModePeer];
	mySession.delegate = self;
	[mySession setDataReceiveHandler:self withContext:nil];
	mySession.available = YES;
	
	[indicator setHidden:NO];
	[indicator startAnimating];
	//label.hidden=NO;
	label.text=@"他のiPhoneを探しているぞ";
        
}

-(IBAction)btnDisconnect:(id)sender{
	[mySession disconnectFromAllPeers];
    [mySession release];
    mySession = nil;
	mySession.available = NO;
    
    [connect setHidden:NO];
    [disconnect setHidden:YES];
	
	if(indicator.hidden==NO){
		[indicator stopAnimating];
	}else {
		
	}
	
	label.text=@"上のボタンで接続するぞ";
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	BOOL suretigai = [defaults integerForKey:@"isValid"];
	//マルチタスク用メソッド	//////////////	//////////////	//////////////
	
	if(suretigai==YES){
		UILocalNotification *localNotif = [[UILocalNotification alloc] init];
		if (localNotif) {
			localNotif.alertBody = @"周りのiPhoneから接続したいと言われたぞ！";
			localNotif.alertAction = @"接続を許可する";
			localNotif.soundName = @"alarmsound.caf";
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
			[localNotif release];
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		}
	}else {
		
	}
	
	//////////////	//////////////	//////////////
	
	
	NSError *error;
	if(![mySession acceptConnectionFromPeer:peerID error:&error]) {
		label.text=@"エラーで接続できなかったぞ";
		NSLog(@"%@ と接続できなかった",peerID);
	} else {
		NSLog(@"%@ と接続できた",peerID);
	}
}

//デバイスが接続したり、切断したり、とにかく接続の状態が変化したときに呼ばれるメソッド
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	
	
	switch (state) {
		case GKPeerStateAvailable:
			
			NSLog(@"%@ を見つけた",peerID);		
			NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
			BOOL suretigai = [defaults integerForKey:@"isValid"];
			//マルチタスク用メソッド				
			if(suretigai==YES){
				UILocalNotification *localNotif = [[UILocalNotification alloc] init];
				if (localNotif) {
					localNotif.alertBody = @"周りにiPhoneがあるぞ！";
					localNotif.alertAction = @"接続しにいく";
					//localNotif.soundName = @"alarmsound.caf";
					[[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
					[localNotif release];
					AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
				}
			}else {
				
			}
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			/////////ここでアラートを出してユーザーに許可を求めます。この時点では接続はしません。///////////////////////////////////////////////////////////////////
			//App Store Review Guidelines 22.6 "Apps that enable anonymous or prank phone calls or SMS/MMS messaging will be rejected" /////////////
			/*ここはアップストア申請用の処理なので技術課題提出時は削らせてもらいます。
			connectionAlert =	[[UIAlertView alloc] initWithTitle:@"周りにiPhoneを見つけたぞ" message:@"このまま接続していいか？"
														delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:(@"%@",peerID), nil];
			[connectionAlert show];
			 */
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			[mySession connectToPeer:peerID withTimeout:10.0f];
			
			
			
			break;
		case GKPeerStateUnavailable:
			
			NSLog(@"%@ を見失った",peerID);
			break;
		case GKPeerStateConnected:
			
			NSLog(@"%@ が接続した",peerID);
			label.text=@"接続したぜ。";
			[indicator setHidden:YES];
			[indicator stopAnimating];
			
			disconnect.hidden=NO;
			connect.hidden=YES;
			
			//GKPeerStateAvailable:で[mySession connectToPeer:peerID withTimeout:10.0f];と接続してしまい、
			//ここでデータを送るようにすれば煩わしいステップ踏まず画像交換できるが審査に通るかどうかが不安。
			//とりあえず一度審査に通ればこの部分を実装させてトライしたい。
			 sendData = UIImageJPEGRepresentation( shrinkedImage,0.1 );	
			 [self mySendDataToPeers];
			 
			break;
		case GKPeerStateDisconnected:
			
			NSLog(@"%@ が切断された",peerID);
			label.text=@"接続がきれちゃったぞ";
			[connect setHidden:NO];
            [disconnect setHidden:YES];
			
			break;
		case GKPeerStateConnecting:
			
			label.text=@"接続しているぞ";
			
			NSLog(@"%@ が接続中",peerID);
			break;
		default:
			break;
	}
}

//**********************************************************************************//
//****************UIImageについての処理（shrinkedImageをどうするか）**********************//


- (IBAction)showCameraSheet
{
	[self showactionSheet1];
    
}

-(void)showactionSheet1{
	
    actionsheet1 = [[[UIActionSheet alloc] init] 
			 initWithTitle:@"choose sourse"
			 delegate:self 
			 cancelButtonTitle:@"Cancel" 
			 destructiveButtonTitle:nil 
			 otherButtonTitles:@"カメラロールから選ぶ", @"写真を撮る",  nil];
    [actionsheet1 autorelease];
	
    
    [actionsheet1 showInView:self.view];
}

-(IBAction)itazura:(id)sender{
	
	[self showactionSheet2];
	
}

-(void)showactionSheet2{
	// アクションシートを作る
    actionsheet2 = [[[UIActionSheet alloc] init]
					initWithTitle:@"choose effect" 
					delegate:self 
					cancelButtonTitle:@"Cancel" 
					destructiveButtonTitle:nil 
					otherButtonTitles:@"モノクロ", @"ネガ", nil];
    [actionsheet2 autorelease];
	
    // アクションシートを表示する
    [actionsheet2 showInView:self.view];
	
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//呼び出されるデリゲートメソッドは常に同じなので出されたアクションシートによって処理を変える。
	if ( buttonIndex == actionSheet.cancelButtonIndex ) {
		// キャンセルされたとき
	} else if(actionSheet==actionsheet1){
		// ボタンインデックスをチェックする
		//こちらはカメラロール等から写真を持ってくるところの処理
		if (buttonIndex >= 2) {
			return;
		}
		UIImagePickerControllerSourceType   sourceType = 0;
		switch (buttonIndex) {
			case 0: {
				sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				break;
			}
			case 1: {
				sourceType = UIImagePickerControllerSourceTypeCamera;
				break;
			}
		}
		
		if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {  
			return;
		}
		
		UIImagePickerController*    imagePicker;
		imagePicker = [[UIImagePickerController alloc] init];
		[imagePicker autorelease];
		imagePicker.sourceType = sourceType;
		imagePicker.allowsEditing = YES;
		imagePicker.delegate = self;
		
		[self presentModalViewController:imagePicker animated:YES];
		NSLog(@"actionsheet1");	
	}else if (actionSheet==actionsheet2) {
		//こっちはモノクロ・ネガ加工のアクションシートの処理
		// まずCGImageを取得する
		CGImageRef  cgImage;
		cgImage = shrinkedImage.CGImage;
		
		// 画像情報を取得する
		size_t                  width;
		size_t                  height;
		size_t                  bitsPerComponent;
		size_t                  bitsPerPixel;
		size_t                  bytesPerRow;
		CGColorSpaceRef         colorSpace;
		CGBitmapInfo            bitmapInfo;
		bool                    shouldInterpolate;
		CGColorRenderingIntent  intent;
		width = CGImageGetWidth(cgImage);
		height = CGImageGetHeight(cgImage);
		bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
		bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
		bytesPerRow = CGImageGetBytesPerRow(cgImage);
		colorSpace = CGImageGetColorSpace(cgImage);
		bitmapInfo = CGImageGetBitmapInfo(cgImage);
		shouldInterpolate = CGImageGetShouldInterpolate(cgImage);
		intent = CGImageGetRenderingIntent(cgImage);
		
		// データプロバイダを取得する
		CGDataProviderRef   dataProvider;
		dataProvider = CGImageGetDataProvider(cgImage);
		
		// ビットマップデータを取得する
		CFDataRef   data;
		UInt8*      buffer;
		data = CGDataProviderCopyData(dataProvider);
		buffer = (UInt8*)CFDataGetBytePtr(data);
		
		// ボタンインデックスをチェックする
		if (buttonIndex >= 2) {
			return;
		}
		switch (buttonIndex) {
			case 0: {
				// ビットマップに効果を与える
				NSUInteger  i, j;
				for (j = 0; j < height; j++) {
					for (i = 0; i < width; i++) {
						// ピクセルのポインタを取得する
						UInt8*  tmp;
						tmp = buffer + j * bytesPerRow + i * 4;
						
						// RGBの値を取得する
						UInt8   r, g, b;
						
						r = *(tmp + 3);
						g = *(tmp + 2);
						b = *(tmp + 1);			
						// 輝度値を計算する
						UInt8   y;
						y = (77 * r + 28 * g + 151 * b) / 256;//( r +  g + b) / 3;//
						// ↑白黒加工はRGBの平均値
						*(tmp + 1) = y;
						*(tmp + 2) = y;
						*(tmp + 3) = y;
					}
				}
								
				break;
				
				NSLog(@"monocrome");
			}
			case 1: {
				// ビットマップに効果を与える
				NSUInteger  i, j;
				for (j = 0; j < height; j++) {
					for (i = 0; i < width; i++) {
						// ピクセルのポインタを取得する
						UInt8*  tmp;
						tmp = buffer + j * bytesPerRow + i * 4;
						
						// RGBの値を取得する
						UInt8   r, g, b;
						r = *(tmp + 3) ;//= 255-r;//r
						g = *(tmp + 2) ;//= 255-g;//g
						b = *(tmp + 1) ;//= 255-b;
						//↑ネガはRGBの反転
						*(tmp + 3) = 255-r;//r 
						*(tmp + 2) = 255-g;//g
						*(tmp + 1) = 255-b;//b
						 
					}
				}
				NSLog(@"nega");
				break;
				
			}				
		}
		
		// 効果を与えたデータを作成する
		CFDataRef   effectedData;
		effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
		
		// 効果を与えたデータプロバイダを作成する
		CGDataProviderRef   effectedDataProvider;
		effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
		
		// 画像を作成する
		
		CGImageRef  effectedCgImage;
		UIImage*    effectedImage;
		effectedCgImage= CGImageCreate(
									   width, height, 
									   bitsPerComponent, bitsPerPixel, bytesPerRow, 
									   colorSpace, bitmapInfo, effectedDataProvider, 
									   NULL, shouldInterpolate, intent);
		effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
		[effectedImage autorelease];
		//imageA=imageBとすると左辺が元ネタになる。
		shrinkedImage=effectedImage;
		// 画像を表示する
		imageView.image = effectedImage;
		 
		 
	}
}

- (void)imagePickerController:(UIImagePickerController*)picker 
        didFinishPickingImage:(UIImage*)image 
				  editingInfo:(NSDictionary*)editingInfo
{

    // イメージピッカーを隠す
    [self dismissModalViewControllerAnimated:YES];
	shrinkedImage =[editingInfo objectForKey:UIImagePickerControllerOriginalImage];
	// 画像を表示する
    imageView.image = shrinkedImage;//image;
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    // イメージピッカーを隠す
    [self dismissModalViewControllerAnimated:YES];
	
	
}

/////////////////////////////////画像の保存///////////////////////////////////////////////////////////////////

-(IBAction)saveImage:(id)sender{

	saveAlert =	[[UIAlertView alloc] initWithTitle:@"確認" message:@"写真を保存するか？"
							  delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
	[saveAlert show];
	 
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
//peer:(NSString *)peerID
{
	//アクションシートと同様呼ばれるデリゲートメソッドが同じなので、呼び出されるアラートの種類によって処理を変える。
	if(alertView==saveAlert){
		//保存する時のアラート
		switch (buttonIndex) {
			case 0:
				
				break;
			case 1:
				UIImageWriteToSavedPhotosAlbum(shrinkedImage, self, @selector(localSavedImage:didFinishSavingWithError:contextInfo:), NULL);
				indicator.hidden=NO;
				[indicator startAnimating];
				label2.hidden=NO;
				label2.text=@"保存してるぞ";
				hozon.hidden=NO;
				break;
		}
	}else if (alertView==connectionAlert) {
		//接続時のアラート
		switch (buttonIndex){
			case 0:
				//disconnectボタンと同じ動き
				
				[mySession disconnectFromAllPeers];
				[mySession release];
				mySession = nil;
				mySession.available = NO;
				
				[connect setHidden:NO];
				[disconnect setHidden:YES];
				
				if(indicator.hidden==NO){
					[indicator stopAnimating];
				}else {
					
				}
				 
				
				label.text=@"上のボタンで接続するぞ";
				break;
			case 1:
				
				break;
		}
		
	}else if (alertView==sendAlert) {
		//写真送信時のアラート
		switch (buttonIndex) {
			case 0:
				
				break;
			case 1:
				//画像データは圧縮しないと容量が大きすぎて大抵送れない。１０分の１に圧縮して送っている。
				sendData = UIImageJPEGRepresentation( shrinkedImage,0.1 );	
				[self mySendDataToPeers];
				break;
			default:
				break;
		}
		
	}else {
		
	}

	
}

- (void)localSavedImage:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void *)contextInfo{
    if(!error){
		
		label2.text=@"保存かんりょう！";
		indicator.hidden=YES;
		[indicator stopAnimating];
		label2.hidden=YES;
		hozon.hidden=YES;
		
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"保存"
                                  message:@"写真の保存ができなかったぞ！"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK",nil];
		indicator.hidden=YES;
		[indicator stopAnimating];
		label2.hidden=YES;
		hozon.hidden=YES;
		
        [alertView show];
        [alertView release];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////

//**********************************************************************************//
//**********************************************************************************//

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[connect dealloc];
	[disconnect dealloc];
	[mySession dealloc];
    [sendData dealloc];
    [actionsheet1 dealloc];
	[actionsheet2 dealloc];
	[saveAlert dealloc];
	[connectionAlert dealloc];
	[sendAlert dealloc];
}

@end
