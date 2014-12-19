//
//  ViewController.m
//  Sayu
//
//  Created by USER on 2014/02/09.
//  Copyright (c) 2014年 USER. All rights reserved.
//

#import "GameViewController.h"
#import "Drawline.h"

@interface GameViewController (){
    NSInteger cnt;  //矢印が出た総回数
    NSInteger tgcnt;//スワイプで弾いた矢印の番号
    NSInteger dismisscnt;//スワイプ後消えてないアイテムの番号
    NSInteger swipecnt;//過剰なスワイプにより落ちることを防止
    NSInteger framecnt;//矢印をプラスする判定に使うフレームカウント
    float speedlvl;
    float flpx;
    float flpy;
    NSInteger score;
    NSInteger scwidth;
    NSInteger scheight;
    NSInteger coolcnt;
    NSInteger goodcnt;
    NSInteger latecnt;
    
    NSMutableArray *yajiarr;// 配列 retsu iro houkou
    NSTimer *movetimer;
    //NSTimer *plustimer;
    Boolean IsGaming;
}

@end

@implementation GameViewController

//@synthesize score;
//@synthesize tgcnt;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selSwipeRightGesture:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selSwipeLeftGesture:)];// 左スワイプ
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer* swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selSwipeDownGesture:)];//下スワイプ
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGesture];
    
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rrr = sc.bounds;
    scwidth = rrr.size.width;
    scheight = rrr.size.height;
    
    cnt = 0;
    tgcnt = 0;
    dismisscnt = 0;
    swipecnt = 0;
    score = 0;
    speedlvl = 0;
    yajiarr = [NSMutableArray array];
    
    _ScoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, scheight-40, 130, 20)];
    _FlickLbl = [[UILabel alloc] initWithFrame:CGRectMake(scwidth/3*2+20, scheight-40, 130, 20)];
    _ScoreLbl.text = @"Score  0";
    _FlickLbl.text = @"Flick  0";
    [self.view addSubview:_ScoreLbl];
    [self.view addSubview:_FlickLbl];
    _spuplbl = [[UILabel alloc] initWithFrame:CGRectMake(scwidth/2-65,30,130,20)];
    _spuplbl.text = @"Speed Up!";
    _spuplbl.textAlignment = NSTextAlignmentCenter;
    //_spuplbl.backgroundColor = [UIColor blueColor];
    _flklbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,scwidth/3,20)];
    _flklbl.textAlignment = NSTextAlignmentCenter;
    
    [self Start];
}

- (void) viewDidAppear{
    NSLog(@"viewDidAppear");
}

- (void) viewWillAppear{
    NSLog(@"viewWillAppear");
}

- (void) viewWillDisappear{
    NSLog(@"viewWillDisAppear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)Start{
    NSLog(@"Start");
    IsGaming = true;
    //while(1){
        
        movetimer =
        [NSTimer
         scheduledTimerWithTimeInterval:0.05f
         target:self
         selector:@selector(Moveyaji:)
         userInfo:nil
         repeats:YES
         ];

    
        //この二行はいきなり呼び出される
        //NSLog(@"EndGame");
        //[self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)selSwipeLeftGesture:(UISwipeGestureRecognizer *)sender {
    NSLog(@"Left Gesture");
    [self Swiped:(1)];
}
- (void)selSwipeRightGesture:(UISwipeGestureRecognizer *)sender {
    NSLog(@"Right Gesture");
    [self Swiped:(2)];
}
- (void)selSwipeDownGesture:(UISwipeGestureRecognizer *)sender {
    NSLog(@"Down Gesture");
    [self Swiped:(3)];
}






- (void)Moveyaji: (NSTimer *)timer{
    NSInteger i = tgcnt + 1;
    float xx, yy;
        for(;i<=cnt;i++){
            //NSLog(@"i:%d",i);
            UIImageView *iv = (UIImageView *)[self.view viewWithTag:i];
            xx = iv.frame.origin.x;
            yy = iv.frame.origin.y + 2 +speedlvl;
            //NSLog(@"x,y:%f,%f",xx,yy);
            if (yy>=scheight){
                //[iv removeFromSuperview];
                [self SwipeFailure];
                return;
            }else{
                //iv.transform = CGAffineTransformMakeTranslation(0, 50);
                iv.frame = CGRectMake(xx, yy, iv.frame.size.width, iv.frame.size.height);
            }
        }
    i = dismisscnt + 1;
        for(;i<=tgcnt;i++){
            UIImageView *iv = (UIImageView *)[self.view viewWithTag:i];
            xx = iv.frame.origin.x;
            yy = iv.frame.origin.y;
            NSArray *arr = [NSArray array];
            arr = [yajiarr objectAtIndex:(i-1)];
            NSLog(@"arr:%@",[arr description]);
            int rint =[arr[0] intValue];
            int iint =[arr[1] intValue];
            int hint =[arr[2] intValue];
            int ii = 0;
            if ( (iint == 1 && hint ==1) || (rint == 1 && iint == 0) ){//左
                xx = xx-20 - (speedlvl * 5);
                ii = -xx;
            }else if( (iint == 1 && hint ==0) || (rint == 3 && iint == 0) ){//右
                xx = xx+20 + (speedlvl * 5);
                ii = xx - scwidth;
            }else if(rint == 2 && iint == 0){//下
                yy = yy+20 + (speedlvl * 5);
                ii = yy - scheight;
            }
            if(ii>0){
                [self Dismissyaji];
            }else{
                iv.frame = CGRectMake(xx, yy, iv.frame.size.width, iv.frame.size.height);
            }
        }
    framecnt++;
    
    if (framecnt>=(40-speedlvl) || (cnt-tgcnt==0)){
        [self Plusyaji];
        framecnt = 0;
    }
    if (cnt%10 == 9){
        speedlvl = speedlvl+0.05;
        [self.view addSubview:_spuplbl];
    }
    
}


    
    
    
- (void)Plusyaji{
    NSLog(@"Plusyaji");
        cnt++;
    //矢印の種類分け　計12種類
    int rnd, retsu, iro, houkou;
    rnd = arc4random() % 12 + 1;
    retsu = (rnd-1)/4 + 1;
    if( (rnd-1) % 4 <= 1 ){
        iro = 1;
    }else{
        iro = 0;
    }
    houkou = rnd % 2;
    NSLog(@"rnd:%d,retsu:%d,iro:%d,houkou:%d",rnd,retsu,iro,houkou);
    
    
    [yajiarr addObject:@[[NSString stringWithFormat:@"%d",retsu],
                     [NSString stringWithFormat:@"%d",iro],
                     [NSString stringWithFormat:@"%d",houkou]]];
    
    
    
    UIImage *img;
    
    switch (iro){
        case 0:
            switch (houkou) {
                case 0:
                    img = [UIImage imageNamed:@"RightGreen.png"];
                    break;
                case 1:
                    img = [UIImage imageNamed:@"LeftGreen.png"];
                    break;
            }
            break;
        case 1:
            switch (houkou) {
                case 0:
                    img = [UIImage imageNamed:@"RightRed.png"];
                    break;
                case 1:
                    img = [UIImage imageNamed:@"LeftRed.png"];
                    break;
            }
            break;
    }
    UIImageView *imgview = [[UIImageView alloc] initWithImage:img];
    imgview.frame = CGRectMake( (scwidth/3 * retsu)-75 ,20, 50.0, 50.0);
    [imgview setTag:cnt];
    [self.view addSubview:imgview];
    [_spuplbl removeFromSuperview];
}


- (void)Dismissyaji{
        dismisscnt++;
    UIImageView *iv = (UIImageView *)[self.view viewWithTag:dismisscnt];
    [iv removeFromSuperview];
}


- (void)Swiped:(int)swipedirection{
    swipecnt++;
    if(swipecnt>cnt){
        swipecnt--;
        NSLog(@"exceesiveSwipe");
        return;
    }
    NSLog(@"swipedirection:%d",swipedirection);
    NSArray *arr = [NSArray array];
    arr = [yajiarr objectAtIndex:(tgcnt)];
    NSLog(@"arr:%@",[arr description]);
    int rint =[arr[0] intValue];
    int iint =[arr[1] intValue];
    int hint =[arr[2] intValue];
    
    switch (swipedirection) {//スワイプ失敗判定
        case 1://左スワイプ
            if ((iint == 1 && hint ==1) || (rint == 1 && iint == 0)){//成功　赤色左方向　または　左列緑色
                NSLog(@"SuccessLeft");
                //[self SwipeSuccess:(swipedirection)];
            }else{
                NSLog(@"FailedLeft");
                [self SwipeFailure];
                return;
            }
            
            break;
            
        case 2://右スワイプ
            if ((iint == 1 && hint ==0) || (rint == 3 && iint == 0)){//成功　赤色右方向　または　右列緑色
                NSLog(@"SuccessRight");
                //[self SwipeSuccess:(swipedirection)];
            }else{
                NSLog(@"FailedRight");
                [self SwipeFailure];
                return;
            }
            break;
            
        case 3://下スワイプ
            if (rint == 2 && iint == 0){//下スワイプ成功 中段緑
                NSLog(@"SuccessDown");
                //[self SwipeSuccess:(swipedirection)];
            }else{
                NSLog(@"FailedDown");
                [self SwipeFailure];
                return;
            }
            break;
    }
    tgcnt++;
    UIImageView *iv = (UIImageView *)[self.view viewWithTag:tgcnt];
    flpx = iv.frame.origin.x;
    flpy = iv.frame.origin.y;
    if (flpy < scheight/4){
        _flklbl.text = @"Cool!";
        score = score + 50;
        coolcnt++;
    }else if (flpy < scheight/2){
        _flklbl.text= @"Good!";
        score = score + 30;
        goodcnt++;
    }else{
        _flklbl.text = @"Late...";
        score = score + 10;
        latecnt++;
    }
    _ScoreLbl.text = [NSString stringWithFormat:@"Score  %d",score];
    _FlickLbl.text = [NSString stringWithFormat:@"Flick  %d",tgcnt];
    //_flklbl.frame = CGRectMake(flpx, flpy, scwidth/3, 20);
    _flklbl.center = CGPointMake(flpx+20, flpy);
     [self.view addSubview:_flklbl];
    

}



- (void) SwipeFailure{
    
    //落ちる原因のアラート

    for (UIView* subview in self.view.subviews) {
        //if(subview.tag != 1000000){
            [subview removeFromSuperview];
        //}
    }
    IsGaming = false;
    [self TimerStop];
    NSLog(@"GameEnd@SwipeFailure");
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.passarr addObject:@[
                                     [NSString stringWithFormat:@"%d",score],
                                     [NSString stringWithFormat:@"%d",tgcnt],
                                     [NSString stringWithFormat:@"%d",coolcnt],
                                     [NSString stringWithFormat:@"%d",goodcnt],
                                     [NSString stringWithFormat:@"%d",latecnt],
                                     ]];
    NSLog(@"passarr:%@", appDelegate.passarr);
    
    NSString *str =  [NSString stringWithFormat:@"フリック回数%d回",(tgcnt)];
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"終了！" message:str
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ResultViewController *resultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Result"];
    [self presentViewController:resultViewController animated:YES completion:^{NSLog(@"ModalToResult");}];
    
    //MyCustomSegue *segue = [[MyCustomSegue alloc] initWithIdentifier:@"" source:self destination:toViewController];
    //[self prepareForSegue:segue sender:sender];
    //[segue perform];
    
    //NSLog(@"BackedToGameView%d",cnt);
}



- (void)TimerStop{
    //タイマーが動いているときにタイマー停止
    if ( movetimer != nil ) {
        if ([movetimer isValid]) {
            NSLog(@"TimerStop");
            [movetimer invalidate];
        }
    }
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");

}




















@end
