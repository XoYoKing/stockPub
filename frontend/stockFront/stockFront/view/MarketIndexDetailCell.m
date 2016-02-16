//
//  MarketIndexDetailCell.m
//  stockFront
//
//  Created by wang jam on 2/7/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "MarketIndexDetailCell.h"
#import "macro.h"
#import <Masonry.h>
#import "Tools.h"

@implementation MarketIndexDetailCell
{
    StockInfoModel* myModel;
    UILabel* stockNameLabel;
    UILabel* stockPriceLabel;
    UILabel* stockFluctuateLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        stockNameLabel = [[UILabel alloc] init];
        stockPriceLabel = [[UILabel alloc] init];
        stockFluctuateLabel = [[UILabel alloc] init];
        
        
        [self addSubview:stockNameLabel];
        [self addSubview:stockPriceLabel];
        [self addSubview:stockFluctuateLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    [stockNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2*minSpace);
        make.top.mas_equalTo(self.mas_top).offset(4*minSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 4*minSpace, 3*minSpace));
    }];
    
    stockNameLabel.textAlignment = NSTextAlignmentLeft;
    
    CGSize size = [Tools getTextArrange:[[NSString alloc] initWithFormat:@"%.2f", myModel.price]  maxRect:CGSizeMake(ScreenWidth - 4*minSpace, ScreenHeight) fontSize:bigbigFont];
    
    [stockPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2*minSpace);
        make.top.mas_equalTo(stockNameLabel.mas_bottom).offset(2*minSpace);
        make.size.mas_equalTo(CGSizeMake(size.width+3*minSpace, size.height));
    }];
    
    stockPriceLabel.textAlignment = NSTextAlignmentLeft;
    
    size = [Tools getTextArrange:[[NSString alloc] initWithFormat:@"%.2f%%, %.2f", myModel.fluctuate, myModel.fluctuate_value]  maxRect:CGSizeMake(ScreenWidth - 16*minSpace, ScreenHeight) fontSize:minMiddleFont];

    
    [stockFluctuateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stockPriceLabel.mas_left);
        make.top.mas_equalTo(stockPriceLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(size.width+2*minSpace, size.height));
    }];
    
    stockFluctuateLabel.textAlignment = NSTextAlignmentLeft;
    
//    [stockFluctuateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(stockFluctuateLabel.mas_right);
//        make.bottom.mas_equalTo(stockPriceLabel.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(10*minSpace, 3*minSpace));
//    }];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureCell:(StockInfoModel*)model
{
    myModel = model;
    stockNameLabel.text = [[NSString alloc] initWithFormat:@"%@(%@)", model.stock_name, model.stock_code];
    stockNameLabel.textColor = [UIColor whiteColor];
    stockNameLabel.font = [UIFont fontWithName:fontName size:middleFont];
    
    stockPriceLabel.text = [[NSString alloc] initWithFormat:@"%.2f", model.price];
    stockPriceLabel.textColor = [UIColor whiteColor];
    stockPriceLabel.font = [UIFont fontWithName:fontName size:bigbigFont];

    
    if(model.fluctuate<0){
        self.backgroundColor = mygreen;
    }else if(model.fluctuate > 0){
        self.backgroundColor = myred;
    }else{
        self.backgroundColor = [UIColor grayColor];
    }
    
    
    stockFluctuateLabel.text = [[NSString alloc] initWithFormat:@"%.2f%%, %.2f", model.fluctuate, model.fluctuate_value];
    stockFluctuateLabel.textColor = [UIColor whiteColor];
    stockFluctuateLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
    
//    stockFluctuateValueLabel.text = [[NSString alloc] initWithFormat:@"%.2f", model.fluctuate_value];
//    stockFluctuateValueLabel.textColor = [UIColor whiteColor];
//    stockFluctuateValueLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
}

+ (CGFloat)cellHeight
{
    return 22*minSpace;
}

@end
