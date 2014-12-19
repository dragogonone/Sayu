//
//  ResultViewController.m
//  Sayu
//
//  Created by USER on 2014/02/15.
//  Copyright (c) 2014年 USER. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController (){
    NSInteger scwidth;
    NSInteger scheight;
    NSInteger LabelNo;//動かすラベル
    NSInteger score;
    NSInteger tgcnt;
    NSInteger coolcnt;
    NSInteger goodcnt;
    NSInteger latecnt;
    NSInteger rank;
    
    Boolean IsHighScoreGet;
}

@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"ResultviewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rrr = sc.bounds;
    scwidth = rrr.size.width;
    scheight = rrr.size.height;
    LabelNo = 2;//Resultを移動させていた時のなごりで初期値が２
    IsHighScoreGet = NO;
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"passarr:%@", appDelegate.passarr);
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    arr = [appDelegate.passarr lastObject];
    [appDelegate.passarr removeLastObject];
    score =[arr[0] intValue];
    tgcnt =[arr[1] intValue];
    coolcnt = [arr[2] intValue];
    goodcnt = [arr[3] intValue];
    latecnt = [arr[4] intValue];
    
    
    [self HighScoreProcess];

    [self initLabel];

    [self ScoreDraw];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Backbtn:(id)sender {

    NSLog(@"dismissResult");
 [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)HighScoreProcess{
    //ハイスコア処理
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    //    [ud removeObjectForKey:@"KEY_HighScore"];
    NSArray* arr = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    NSLog(@"arr:%@",[arr description]);
    [defaults setObject:arr forKey:@"KEY_HighScore"];  // デフォルト設定（初回のみ）
    [defaults setObject:@"0" forKey:@"KEY_TotalFlick"];
    [ud registerDefaults:defaults];
    
    //NSMutableArray *mArr =[NSMutableArray array];
    NSArray *higharr = [ud arrayForKey:@"KEY_HighScore"];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:higharr];
    //higharr = arr;
    NSLog(@"higharr:%@",[higharr description]);
    NSLog(@"mArr:%@",[mArr description]);
    int i;
    for (i=9;i>=0;i--){
        int sint = [mArr[i] intValue];
        if(score>sint){
            IsHighScoreGet = YES;
            rank = i;//一位は0
        }
    }
    
    NSLog(@"rank:%d",rank);
    
    NSLog(@"higharr:%@",[higharr description]);
    
    if (IsHighScoreGet){
        NSLog(@"HighScoreGet");
        //int karirank = 9 - rank;
//        while(karirank>=0){
//            int x = [mArr[karirank-1] intValue];
//            mArr[karirank] = [NSString stringWithFormat:@"%d",x];
//            karirank--;
//        }
        for (i = 9; i > rank; i--) {
            int x = [mArr[i-1] intValue];
            NSLog(@"i:%d,x:%d",i,x);
            mArr[i] = [NSString stringWithFormat:@"%d",x];
        }
        NSLog(@"loopnuke");
        mArr[rank] = [NSString stringWithFormat:@"%d",score];
       // [mArr removeObjectAtIndex:10];
    }
    
    higharr = mArr;
    NSLog(@"mArr:%@",[mArr description]);
    NSLog(@"higharr:%@",[higharr description]);
    NSInteger tflick = [ud integerForKey:@"KEY_TotalFlick"];//合計フリック回数
    tflick = tflick + tgcnt;
    [ud setObject:higharr forKey:@"KEY_HighScore"];
    [ud setInteger:tflick forKey:@"KEY_TotalFlick"];
    [ud synchronize]; //保存を実行
}



- (void)initLabel{
    rank++;
    NSLog(@"initLabel");
    _ResultLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _ScoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, scheight, 300, 20)];
    _FlickLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, scheight, 300, 20)];
    _CoolLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, scheight, 300, 20)];
    _GoodLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, scheight, 300, 20)];
    _LateLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, scheight, 300, 20)];
    if(IsHighScoreGet) {
        _ResultLbl.text = [NSString stringWithFormat:@"HighScore!  No.%d",rank];
    }else{
        _ResultLbl.text = @"Result";
    }
    _ScoreLbl.text = [NSString stringWithFormat:@"Score  %d",score];
    _FlickLbl.text = [NSString stringWithFormat:@"Flick  %d",tgcnt];
    _CoolLbl.text = [NSString stringWithFormat:@"Cool ×%d = %d",coolcnt,coolcnt*50];
    _GoodLbl.text = [NSString stringWithFormat:@"Good ×%d = %d",goodcnt,goodcnt*30];
    _LateLbl.text = [NSString stringWithFormat:@"Late ×%d = %d",latecnt,latecnt*10];
    _ResultLbl.center = CGPointMake(scwidth/2, 50);
    _ResultLbl.font =[UIFont systemFontOfSize:20];
    _ResultLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_ResultLbl];
    [self.view addSubview:_ScoreLbl];
    [self.view addSubview:_FlickLbl];
    [self.view addSubview:_CoolLbl];
    [self.view addSubview:_GoodLbl];
    [self.view addSubview:_LateLbl];
    
    _Backbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _Backbtn.frame = CGRectMake(scwidth/2-25, scheight-70, 50, 30);
    [_Backbtn setTitle:@"Back" forState:UIControlStateNormal];
    [_Backbtn addTarget:self
                 action:@selector(BackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_Backbtn];
}


- (void)ScoreDraw{
    NSLog(@"ScoreDraw");
    
    {NSTimer *timer;
    timer = [NSTimer
             scheduledTimerWithTimeInterval:0.01
             target:self
             selector:@selector(moveLabel:)
             userInfo:nil
             repeats:YES];
    
    }
    NSLog(@"FlickDraw");
}


- (void)moveLabel:(NSTimer *)timer {
    
    UILabel *label;
    float posYhosei;

    switch (LabelNo) {
        case 1://Result
            label = _ResultLbl;
            posYhosei = 50;
            break;
        case 2://Flick
            label = _FlickLbl;
            posYhosei = 110;
            break;
        case 3://Score
            label = _ScoreLbl;
            posYhosei = 160;
            break;
        case 4://Cool
            label = _CoolLbl;
            posYhosei = 210;
            break;
        case 5://Good
            label = _GoodLbl;
            posYhosei = 230;
            break;
        case 6://Late
            label = _LateLbl;
            posYhosei = 250;
            break;
        default:
            posYhosei= 0;
            break;
    }
    float posX = label.center.x;
    float posY = label.center.y;
    //ラベルを移動させる
    posY -= 10;
    //端までアニメーションしたか判定
    //if ([self isLimitLabelX:posX]) posX = 0;
    //if ([self isLimitLabelY:posY]) posY = 0;
    //座標反映
    label.center = CGPointMake(posX, posY);
    
    if (posY < posYhosei){
        LabelNo++;
    }
    if(LabelNo >= 7){
        [timer invalidate];
    }

}

-(void)BackBtn:(UIButton*)button{
     [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}














@end
