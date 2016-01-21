//
//  StockActionTableViewCell.m
//  stockFront
//
//  Created by wang jam on 1/21/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockActionTableViewCell.h"
#import "StockInfoModel.h"
#import "macro.h"
#import <Masonry.h>
#import "AppDelegate.h"
#import "LocDatabase.h"


@implementation StockActionTableViewCell
{
    UILabel* stockCodelabel;
    UILabel* stockNameLabel;
    UILabel* priceLabel;
    UILabel* lookLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        priceLabel = [[UILabel alloc] init];
        stockCodelabel = [[UILabel alloc] init];
        stockNameLabel = [[UILabel alloc] init];
        lookLabel = [[UILabel alloc] init];
        [self addSubview:priceLabel];
        [self addSubview:stockCodelabel];
        [self addSubview:stockNameLabel];
        [self addSubview:lookLabel];

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)cellHeight
{
    return 8*minSpace;
}

- (void)configureCell:(StockInfoModel*)stockInfo
{
    stockNameLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
    stockNameLabel.text = stockInfo.stock_name;
    priceLabel.font = [UIFont fontWithName:fontName size:middleFont];
    
    if (stockInfo.fluctuate>0) {
        priceLabel.textColor = myred;
        priceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf(+%.2lf%%)", stockInfo.price, stockInfo.fluctuate];
    }
    
    if(stockInfo.fluctuate<0){
        priceLabel.textColor = mygreen;
        priceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf(%.2lf%%)", stockInfo.price, stockInfo.fluctuate];
    }
    
    if(stockInfo.fluctuate == 0){
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf(%.2lf%%)", stockInfo.price, stockInfo.fluctuate];
    }
    
    CGSize labelSize = [Tools getTextArrange:priceLabel.text maxRect:CGSizeMake(ScreenWidth, 8*minSpace) fontSize:middleFont];
    
    priceLabel.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    
    stockCodelabel.font = [UIFont fontWithName:fontName size:minFont];
    stockCodelabel.text = stockInfo.stock_code;
    stockCodelabel.textColor = [UIColor grayColor];
    
    
    LocDatabase* locDatabase = [AppDelegate getLocDatabase];
    
    if([locDatabase isLookStock:stockInfo]){
        lookLabel.text = @"看多";
        lookLabel.textColor = myred;
    }else{
        lookLabel.text = @"";
    }
    
    lookLabel.font = stockCodelabel.font;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [stockNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2*minSpace);
        make.top.mas_equalTo(self.mas_top).offset(minSpace);
        make.size.mas_equalTo(CGSizeMake(10*minSpace, 4*minSpace));
    }];
    
    [stockCodelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stockNameLabel.mas_left);
        make.top.mas_equalTo(stockNameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(8*minSpace, 2*minSpace));
    }];
    
    [lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stockCodelabel.mas_right).offset(minSpace);
        make.top.mas_equalTo(stockCodelabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(4*minSpace, 2*minSpace));
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-minSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

@end
