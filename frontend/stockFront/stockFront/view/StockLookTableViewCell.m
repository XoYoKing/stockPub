//
//  StockLookTableViewCell.m
//  stockFront
//
//  Created by wang jam on 1/23/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockLookTableViewCell.h"
#import "macro.h"
#import <Masonry.h>

@implementation StockLookTableViewCell
{
    UILabel* stockCodelabel;
    UILabel* stockNameLabel;
    UILabel* curPriceLabel;
    UILabel* primePriceLabel;
    UILabel* yieldLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        stockCodelabel = [[UILabel alloc] init];
        stockNameLabel = [[UILabel alloc] init];
        curPriceLabel = [[UILabel alloc] init];
        primePriceLabel = [[UILabel alloc] init];
        yieldLabel = [[UILabel alloc] init];
        
        [self addSubview:stockCodelabel];
        [self addSubview:stockNameLabel];
        [self addSubview:curPriceLabel];
        [self addSubview:primePriceLabel];
        [self addSubview:yieldLabel];
        
        
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [stockNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2*minSpace);
        make.top.mas_equalTo(self.mas_top).offset(minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, 4*minSpace));
    }];
    
    [stockCodelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2*minSpace);
        make.top.mas_equalTo(stockNameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, 2*minSpace));
    }];
    
    [curPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stockNameLabel.mas_right);
        make.top.mas_equalTo(self.mas_top).offset(minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, 4*minSpace));
    }];
    
    [primePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stockNameLabel.mas_right);
        make.top.mas_equalTo(curPriceLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, 2*minSpace));
    }];
    
    
    [yieldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-minSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, 8*minSpace));
    }];
    
//    [lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(stockCodelabel.mas_right).offset(minSpace);
//        make.top.mas_equalTo(stockCodelabel.mas_top);
//        make.size.mas_equalTo(CGSizeMake(4*minSpace, 2*minSpace));
//    }];
//    
//    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.mas_right).offset(-minSpace);
//        make.centerY.mas_equalTo(self.mas_centerY);
//    }];
}



- (void)configureCell:(StockLookInfoModel*)stockLookInfoModel
{
    stockNameLabel.text = stockLookInfoModel.stock_name;
    stockNameLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
    //stockNameLabel.textAlignment = NSTextAlignmentCenter;
    
    stockCodelabel.text = stockLookInfoModel.stock_code;
    stockCodelabel.font = [UIFont fontWithName:fontName size:minFont];
    stockCodelabel.textColor = [UIColor grayColor];
    //stockCodelabel.textAlignment = NSTextAlignmentCenter;
    
    curPriceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf", stockLookInfoModel.look_cur_price];
    curPriceLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
    
    primePriceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf", stockLookInfoModel.look_stock_price];
    primePriceLabel.font = [UIFont fontWithName:fontName size:minFont];
    primePriceLabel.textColor = [UIColor grayColor];
    
    yieldLabel.font = [UIFont fontWithName:fontName size:middleFont];
    
    if (stockLookInfoModel.stock_yield>0) {
        yieldLabel.textColor = myred;
        yieldLabel.text = [[NSString alloc] initWithFormat:@"+%.2lf%%", stockLookInfoModel.stock_yield];
    }
    
    if(stockLookInfoModel.stock_yield<0){
        yieldLabel.textColor = mygreen;
        yieldLabel.text = [[NSString alloc] initWithFormat:@"%.2lf%%", stockLookInfoModel.stock_yield];
    }
    
    if(stockLookInfoModel.stock_yield == 0){
        yieldLabel.textColor = [UIColor blackColor];
        yieldLabel.text = [[NSString alloc] initWithFormat:@"%.2lf%%", stockLookInfoModel.stock_yield];
    }
}

+ (CGFloat)cellHeight
{
    return 8*minSpace;
}

@end
