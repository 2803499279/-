//
//  JHCustomPickView.m
//  DataPickViewDemo
//
//  Created by 李俊恒 on 2017/4/26.
//  Copyright © 2017年 聚保汇. All rights reserved.
//

#import "JHCustomPickView.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface JHCustomPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView * myHourPickView;
    UIPickerView * myMinutePickView;
    
    NSMutableArray *hourDataList;
    NSMutableArray *minuteList;
    
}
@property(nonatomic,strong)UISegmentedControl * segmentControll;
@property(nonatomic,strong)UIButton * sureButton;
@property(nonatomic,copy)NSString * statrTime;
@property(nonatomic,copy)NSString * endTime;
@property(nonatomic,strong)NSString * houre;
@property(nonatomic,strong)NSString * mintue;
@property(nonatomic,strong)UIButton * backGroundBtn;
@property(nonatomic,strong)UIView * backGroundView;

@end

@implementation JHCustomPickView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _backGroundBtn = [[UIButton alloc]initWithFrame:frame];
        _backGroundView = [[UIView alloc]init];
        _segmentControll = [[UISegmentedControl alloc]initWithItems:@[@"开始时间",@"结束时间"]];
        _sureButton = [[UIButton alloc]init];
        myHourPickView = [[UIPickerView alloc]init];
        
        [self addSubview:_backGroundBtn];
        [_backGroundView addSubview:_segmentControll];
        [_backGroundView addSubview:myHourPickView];
        [_backGroundView addSubview:_sureButton];


        [self addSubview:_backGroundView];
        
        [self initDataSources];
        
        [self setUI];

    }
        return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_backGroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.height.mas_equalTo(Screen_H-64);
        make.width.mas_equalTo(Screen_W);
    }];
    [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*Size_ratio);
        make.top.equalTo(self).offset(Screen_H*0.5+60*Size_ratio-70);
        make.height.mas_equalTo(300*Size_ratio);
        make.width.mas_equalTo(Screen_W - 20*Size_ratio);
    }];
   
    [_segmentControll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(100*Size_ratio);
        make.top.equalTo(_backGroundView).offset(15*Size_ratio);
        make.width.mas_equalTo(Screen_W*0.5);
        make.height.mas_equalTo(30*Size_ratio);
    }];
    [myHourPickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(10*Size_ratio);
        make.top.equalTo(_backGroundView).offset(60*Size_ratio);
        make.height.mas_equalTo(200*Size_ratio);
        make.width.mas_equalTo(Screen_W - 40*Size_ratio);
    }];
    _sureButton.frame = CGRectMake(0,260*Size_ratio,Screen_W-20*Size_ratio, 50*Size_ratio);

}
- (void)initDataSources
{
    _timeArray = [NSMutableArray array];
    hourDataList = [NSMutableArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",
                                                    @"06",@"07",@"08",@"09",@"10",@"11",
                                                    @"12",@"13",@"14",@"15",@"16",@"17",
                                                    @"18",@"19",@"20",@"21",@"22",@"23",@"24",nil];
    
    NSArray * minuArray = [NSArray arrayWithObjects:@"00",@"05",@"10",@"15",@"20",@"25"
                                                    ,@"30",@"35",@"40",@"45",@"50"
                                                    ,@"55", nil];
    minuteList = [NSMutableArray arrayWithArray:minuArray];

}
- (void)setUI{
    // 1
    _backGroundBtn.backgroundColor = [UIColor blackColor];
    _backGroundBtn.alpha = 0.5;
    [_backGroundBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    // 2
    _backGroundView.backgroundColor = [UIColor whiteColor];
    _backGroundView.layer.cornerRadius = 10*Size_ratio;
    //2.1
    self.segmentControll.selectedSegmentIndex = 0;
    self.segmentControll.tintColor = [UIColor jhBaseOrangeColor];
    [self.segmentControll addTarget:self
                             action:@selector(myAction:)
                   forControlEvents:UIControlEventValueChanged];
    // 2.2
    myHourPickView.delegate = self;
    myHourPickView.dataSource = self;
    //在当前选择上显示一个透明窗口
    myHourPickView.showsSelectionIndicator = NO;
    //初始化，自动转一圈，避免第一次是数组第一个值造成留白
    [myHourPickView selectRow:12 inComponent:0 animated:YES];
    [myHourPickView selectRow:5 inComponent:1 animated:YES];
    self.houre = hourDataList[12];
    self.mintue = minuteList[5];
    // 2.3
    [_sureButton setTitle:@"确定" forState:0];
    [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.backgroundColor = [UIColor jhBaseOrangeColor];
    _sureButton.layer.cornerRadius = 10*Size_ratio;
    [self layoutIfNeeded];
}
#pragma mark ---------------- Action
- (void)myAction:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            DLog(@"开始时间");
            [myHourPickView reloadAllComponents];


            if (_timeArray.count != 0) {
            if (_timeArray[0]!=nil) {
                [_timeArray removeObjectAtIndex:0];
            }
            }
            break;
        case 1:
            DLog(@"结束时间");
            [myHourPickView reloadAllComponents];

            if (_timeArray.count != 0) {
                if (_timeArray[1]!=nil) {
                    [_timeArray removeObjectAtIndex:1];
                }
            }
            break;
        default:
            break;
    }
}
- (void)backBtnClick:(UIButton *)sender
{
    [self removeFromSuperview];
}
- (void)sureButtonClick:(UIButton *)sender
{
    if (!self.segmentControll.selectedSegmentIndex) {
        // 开始时间

            self.statrTime = [NSString stringWithFormat:@"%@:%@",self.houre,self.mintue];
        DLog(@"开始时间%@",self.statrTime);
    }else
    {
        self.endTime = [NSString stringWithFormat:@"%@:%@",self.houre,self.mintue];
        DLog(@"结束时间%@",self.endTime);
    }
   
    if (self.timeInfo) {
        
        if ([self.statrTime isEqualToString:self.endTime]) {
            [self waringViewWith:@"开始结束时间不可以相同"];
        }
        else {
        // 调用block传入参数
        if(self.statrTime.length != 0&&self.endTime.length != 0){
        [self.timeArray addObject:self.statrTime];
        [self.timeArray addObject:self.endTime];
            
        self.timeInfo(self.timeArray);
        }
    }
    }
}
- (void)waringViewWith:(NSString *)title{
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:title preferredStyle:UIAlertControllerStyleAlert];

// 添加按钮
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
   
}]];
[self.controller presentViewController:alert animated:YES completion:nil];
}
#pragma mark ----------------- UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return hourDataList.count;
    }else if (component == 1){
        return minuteList.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSString * str = [hourDataList objectAtIndex:([hourDataList count])];
        return str;
    }else if (component == 1){
        NSString * str = [minuteList objectAtIndex:([minuteList count])];
        return str;
    }
    return nil;
}

//选中picker cell,save ArrayIndex
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component == 0)
    {
        
        [pickerView selectRow:row inComponent:component animated:false];
        self.houre = hourDataList[row];
        DLog(@"%@",hourDataList[row]);
        
    }
    if(component == 1)
    {
        [pickerView selectRow:row inComponent:component animated:false];
        DLog(@"%@",minuteList[row]);
        self.mintue = minuteList[row];
    }
    
    if (self.houre != nil && self.mintue!=nil && self.segmentControll.selectedSegmentIndex == 0) {
        self.statrTime = [NSString stringWithFormat:@"%@:%@",self.houre,self.mintue];

    }
    if (self.houre != nil && self.mintue!=nil&& self.segmentControll.selectedSegmentIndex == 1) {
        self.endTime = [NSString stringWithFormat:@"%@:%@",self.houre,self.mintue];
    }
    
}

//替换text居中
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (component == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
        label.backgroundColor = [UIColor whiteColor];
        NSString * str = [hourDataList objectAtIndex:(row%[hourDataList count])];
        label.text = [NSString stringWithFormat:@"%@时",str];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }else if (component == 1){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
        label.backgroundColor = [UIColor whiteColor];
        NSString * str = [minuteList objectAtIndex:(row%[minuteList count])];
        label.text = [NSString stringWithFormat:@"%@分",str];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    
    return nil;
}



@end
