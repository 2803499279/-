//
//  YZNewCaseCell.m
//  JBHProject
//
//  Created by zyz on 2018/1/9.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import "YZNewCaseCell.h"

@implementation YZNewCaseCell

- (void)dealloc
{
    self.backView = nil;
    self.BID = nil;
    self.NameImg = nil;
    self.Name = nil;
    self.Nam = nil;
    self.PhoneImg = nil;
    self.Phone = nil;
    self.Phon = nil;
    self.CarImg = nil;
    self.Car = nil;
    self.Ca = nil;
    self.CarNumImg = nil;
    self.CarNum = nil;
    self.CarNu = nil;
    self.CompanyImg = nil;
    self.Company = nil;
    self.Compan = nil;
    self.AddressImg = nil;
    self.Address = nil;
    self.Addres = nil;
    self.RapView = nil;
    self.RapBut = nil;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.BID];
        [self.backView addSubview:self.NameImg];
        [self.backView addSubview:self.Name];
        [self.backView addSubview:self.Nam];
        [self.backView addSubview:self.PhoneImg];
        [self.backView addSubview:self.Phone];
        [self.backView addSubview:self.Phon];
        [self.backView addSubview:self.CarImg];
        [self.backView addSubview:self.Car];
        [self.backView addSubview:self.Ca];
        [self.backView addSubview:self.CarNumImg];
        [self.backView addSubview:self.CarNum];
        [self.backView addSubview:self.CarNu];
        [self.backView addSubview:self.CompanyImg];
        [self.backView addSubview:self.Company];
        [self.backView addSubview:self.Compan];
        [self.backView addSubview:self.AddressImg];
        [self.backView addSubview:self.Address];
        [self.backView addSubview:self.Addres];
        [self.backView addSubview:self.RapView];
        [self.backView addSubview:self.RapBut];
    }
    return self;
}


- (UIView *)backView {
    if (!_backView) {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(15*YZAdapter, 15*YZAdapter, 345*YZAdapter, 255*YZAdapter)];
        self.backView.backgroundColor = WhiteColor;
//        self.OnewView.alpha = 0.6;
        self.backView.layer.cornerRadius = 10.0*YZAdapter;
        self.backView.layer.masksToBounds = YES;
        
        self.backView.layer.borderWidth = 1;
        self.backView.layer.borderColor = [YZDivisionColor CGColor];
    }
    return _backView;
}

- (UILabel *)BID {
    if (!_BID) {
        
        self.BID = [[UILabel alloc] initWithFrame:CGRectMake(0*YZAdapter, 0*YZAdapter, 80*YZAdapter, 25*YZAdapter)];
        self.BID.text = @"车辆代堪";
        self.BID.backgroundColor = NewGreenButton_Color;
        self.BID.font = FONT(13);
        self.BID.textColor = WhiteColor;
        self.BID.textAlignment = NSTextAlignmentCenter;
        
        // 单独切一个角
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.BID.bounds byRoundingCorners:UIRectCornerBottomRight    cornerRadii:CGSizeMake(10*YZAdapter, 0)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.BID.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.BID.layer.mask = maskLayer;
        
    }
    return _BID;
}

- (UIImageView *)NameImg {
    if (!_NameImg) {
        
        self.NameImg = [[UIImageView alloc] initWithFrame:CGRectMake(8*YZAdapter, 40*YZAdapter, 13*YZAdapter, 13*YZAdapter)];
        self.NameImg.image = [UIImage imageNamed:@"details-user"];
        self.NameImg.userInteractionEnabled = YES;
    }
    return _NameImg;
}


- (UILabel *)Name {
    if (!_Name) {
        self.Name = [[UILabel alloc] initWithFrame:CGRectMake(30*YZAdapter, 40*YZAdapter, 55*YZAdapter, 14*YZAdapter)];
        self.Name.text = @"客户姓名";
        self.Name.font = FONT(13);
        self.Name.textColor = TimeMainFont_Color;
        self.Name.textAlignment = NSTextAlignmentLeft;
    }
    return _Name;
}

- (UILabel *)Nam {
    if (!_Nam) {
        self.Nam = [[UILabel alloc] initWithFrame:CGRectMake(96*YZAdapter, 40*YZAdapter, 45*YZAdapter, 14*YZAdapter)];
        self.Nam.text = @"李白凯";
        self.Nam.font = FONT(13);
        self.Nam.textColor = MainFont_Color;
        self.Nam.textAlignment = NSTextAlignmentLeft;
    }
    return _Nam;
}

- (UIImageView *)PhoneImg {
    if (!_PhoneImg) {
        
        self.PhoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(158*YZAdapter, 40*YZAdapter, 8*YZAdapter, 13*YZAdapter)];
        self.PhoneImg.image = [UIImage imageNamed:@"details-phone"];
        self.PhoneImg.userInteractionEnabled = YES;
    }
    return _PhoneImg;
}


- (UILabel *)Phone {
    if (!_Phone) {
        self.Phone = [[UILabel alloc] initWithFrame:CGRectMake(177*YZAdapter, 40*YZAdapter, 55*YZAdapter, 14*YZAdapter)];
        self.Phone.text = @"客户电话";
        self.Phone.font = FONT(13);
        self.Phone.textColor = TimeMainFont_Color;
        self.Phone.textAlignment = NSTextAlignmentLeft;
    }
    return _Phone;
}

- (UILabel *)Phon {
    if (!_Phon) {
        self.Phon = [[UILabel alloc] initWithFrame:CGRectMake(245*YZAdapter, 40*YZAdapter, 90*YZAdapter, 14*YZAdapter)];
        self.Phon.text = @"13783508350";
        self.Phon.font = FONT(13);
        self.Phon.textColor = MainFont_Color;
        self.Phon.textAlignment = NSTextAlignmentLeft;
    }
    return _Phon;
}

- (UIImageView *)CarImg {
    if (!_CarImg) {
        
        self.CarImg = [[UIImageView alloc] initWithFrame:CGRectMake(8*YZAdapter, 69*YZAdapter, 10*YZAdapter, 13*YZAdapter)];
        self.CarImg.image = [UIImage imageNamed:@"YZAddress"];
        self.CarImg.userInteractionEnabled = YES;
    }
    return _CarImg;
}


- (UILabel *)Car {
    if (!_Car) {
        self.Car = [[UILabel alloc] initWithFrame:CGRectMake(30*YZAdapter, 69*YZAdapter, 55*YZAdapter, 14*YZAdapter)];
        self.Car.text = @"勘察距离";
        self.Car.font = FONT(13);
        self.Car.textColor = TimeMainFont_Color;
        self.Car.textAlignment = NSTextAlignmentLeft;
    }
    return _Car;
}

- (UILabel *)Ca {
    if (!_Ca) {
        self.Ca = [[UILabel alloc] initWithFrame:CGRectMake(96*YZAdapter, 69*YZAdapter, 45*YZAdapter, 14*YZAdapter)];
        self.Ca.text = @"1.5km";
        self.Ca.font = FONT(13);
        self.Ca.textColor = MainFont_Color;
        self.Ca.textAlignment = NSTextAlignmentLeft;
    }
    return _Ca;
}


- (UIImageView *)CarNumImg {
    if (!_CarNumImg) {
        
        self.CarNumImg = [[UIImageView alloc] initWithFrame:CGRectMake(154.5*YZAdapter, 70*YZAdapter, 14*YZAdapter, 12*YZAdapter)];
        self.CarNumImg.image = [UIImage imageNamed:@"details-reward"];
        self.CarNumImg.userInteractionEnabled = YES;
    }
    return _CarNumImg;
}


- (UILabel *)CarNum {
    if (!_CarNum) {
        self.CarNum = [[UILabel alloc] initWithFrame:CGRectMake(177*YZAdapter, 69*YZAdapter, 55*YZAdapter, 14*YZAdapter)];
        self.CarNum.text = @"勘察金额";
        self.CarNum.font = FONT(13);
        self.CarNum.textColor = TimeMainFont_Color;
        self.CarNum.textAlignment = NSTextAlignmentLeft;
    }
    return _CarNum;
}

- (UILabel *)CarNu {
    if (!_CarNu) {
        self.CarNu = [[UILabel alloc] initWithFrame:CGRectMake(245*YZAdapter, 69*YZAdapter, 90*YZAdapter, 14*YZAdapter)];
        self.CarNu.text = @"80元";
        self.CarNu.font = FONT(13);
        self.CarNu.textColor = MainFont_Color;
        self.CarNu.textAlignment = NSTextAlignmentLeft;
    }
    return _CarNu;
}


- (UIImageView *)CompanyImg {
    if (!_CompanyImg) {
        
        self.CompanyImg = [[UIImageView alloc] initWithFrame:CGRectMake(9*YZAdapter, 97*YZAdapter, 10*YZAdapter, 13*YZAdapter)];
        self.CompanyImg.image = [UIImage imageNamed:@"details-content"];
        self.CompanyImg.userInteractionEnabled = YES;
    }
    return _CompanyImg;
}


- (UILabel *)Company {
    if (!_Company) {
        self.Company = [[UILabel alloc] initWithFrame:CGRectMake(30*YZAdapter, 97*YZAdapter, 55*YZAdapter, 14*YZAdapter)];
        self.Company.text = @"保险公司";
        self.Company.font = FONT(13);
        self.Company.textColor = TimeMainFont_Color;
        self.Company.textAlignment = NSTextAlignmentLeft;
    }
    return _Company;
}

- (UILabel *)Compan {
    if (!_Compan) {
        self.Compan = [[UILabel alloc] initWithFrame:CGRectMake(96*YZAdapter, 97*YZAdapter, 240*YZAdapter, 14*YZAdapter)];
        self.Compan.text = @"中国太平洋保险(集团有限公司)";
        self.Compan.font = FONT(13);
        self.Compan.textColor = MainFont_Color;
        self.Compan.textAlignment = NSTextAlignmentLeft;
    }
    return _Compan;
}


- (UIImageView *)AddressImg {
    if (!_AddressImg) {
        
        self.AddressImg = [[UIImageView alloc] initWithFrame:CGRectMake(8*YZAdapter, 125*YZAdapter, 10*YZAdapter, 13*YZAdapter)];
        self.AddressImg.image = [UIImage imageNamed:@"details-place"];
        self.AddressImg.userInteractionEnabled = YES;
    }
    return _AddressImg;
}


- (UILabel *)Address {
    if (!_Address) {
        self.Address = [[UILabel alloc] initWithFrame:CGRectMake(30*YZAdapter, 125*YZAdapter, 55*YZAdapter, 14*YZAdapter)];
        self.Address.text = @"事故地点";
        self.Address.font = FONT(13);
        self.Address.textColor = TimeMainFont_Color;
        self.Address.textAlignment = NSTextAlignmentLeft;
    }
    return _Address;
}

- (MyLabel *)Addres {
    if (!_Addres) {
        self.Addres = [[MyLabel alloc] initWithFrame:CGRectMake(96*YZAdapter, 125*YZAdapter, 240*YZAdapter, 32*YZAdapter)];
        self.Addres.text = @"金水区沙口路农业路金水区沙口路农业路金水区沙口路农业路金水区沙口路农业路";
        self.Addres.font = FONT(13);
        self.Addres.textAlignment = NSTextAlignmentLeft;
        self.Addres.textColor = MainFont_Color;
        self.Addres.numberOfLines = 0;
        self.Addres.lineBreakMode = NSLineBreakByCharWrapping;
        [self.Addres setVerticalAlignment:VerticalAlignmentTop];
        
        
    }
    return _Addres;
}


- (UIView *)RapView {
    if (!_RapView) {
        self.RapView = [[UIView alloc] initWithFrame:CGRectMake(345*YZAdapter/2-36*YZAdapter, 170*YZAdapter, 72*YZAdapter, 72*YZAdapter)];
        self.RapView.backgroundColor = WhiteColor;
        //        self.OnewView.alpha = 0.6;
        self.RapView.layer.cornerRadius = 36.0*YZAdapter;
        self.RapView.layer.masksToBounds = YES;
        
        self.RapView.layer.borderWidth = 1;
        self.RapView.layer.borderColor = [YZEssentialColor CGColor];
    }
    return _RapView;
}


- (UIButton *)RapBut {
    if (!_RapBut) {
        self.RapBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.RapBut.frame = CGRectMake(345*YZAdapter/2-34*YZAdapter, 172*YZAdapter, 68*YZAdapter, 68*YZAdapter);
        self.RapBut.backgroundColor = YZEssentialColor;
        self.RapBut.layer.cornerRadius = 34.0*YZAdapter;
        self.RapBut.layer.masksToBounds = YES;
        [self.RapBut  setExclusiveTouch :YES];
        [self.RapBut setTitle:@"抢单" forState:UIControlStateNormal];
        [self.RapBut setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.RapBut setBackgroundColor:YZEssentialColor];
        self.RapBut.titleLabel.font = FONT(20);
        
    }
    return _RapBut;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
