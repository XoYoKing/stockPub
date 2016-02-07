//
//  MarketIndexDetailCell.m
//  stockFront
//
//  Created by wang jam on 2/7/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "MarketIndexDetailCell.h"
#import "macro.h"


@implementation MarketIndexDetailCell
{
    StockInfoModel* myModel;
    UILabel* stockNameLabel;
    UILabel* stockPriceLabel;
    UILabel* stockFluctuateLabel;
    UILabel* stockFluctuateValueLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        stockNameLabel = [[UILabel alloc] init];
        stockPriceLabel = [[UILabel alloc] init];
        stockFluctuateLabel = [[UILabel alloc] init];
        stockFluctuateValueLabel = [[UILabel alloc] init];
        
        
        [self addSubview:stockNameLabel];
        [self addSubview:stockPriceLabel];
        [self addSubview:stockFluctuateLabel];
        [self addSubview:stockFluctuateValueLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2*minSpace);
        make.top.mas_equalTo(self.mas_top).offset(2*minSpace);
        make.size.mas_equalTo(CGSizeMake(6*minSpace, 6*minSpace));
    }];
    faceImageView.layer.cornerRadius = faceImageView.frame.size.height/2;
    faceImageView.layer.masksToBounds = YES;
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(faceImageView.mas_right).offset(minSpace);
        make.top.mas_equalTo(faceImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(180, 3*minSpace));
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-minSpace);
        make.top.mas_equalTo(faceImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(9*minSpace, 3*minSpace));
    }];
    
    commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    commentLabel.numberOfLines = 0;
    
    CGSize size = [Tools getTextArrange:myCommentModel.comment_content maxRect:CGSizeMake(ScreenWidth - 16*minSpace, ScreenHeight) fontSize:minFont];
    
    
    commentLabel.frame = CGRectMake(faceImageView.frame.origin.x+faceImageView.frame.size.width+minSpace, userNameLabel.frame.origin.y+userNameLabel.frame.size.height+minSpace, size.width+minSpace, size.height);
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
    stockPriceLabel.font = [UIFont fontWithName:fontName size:middleFont];

    
    if(model.fluctuate<0){
        self.backgroundColor = mygreen;
    }else{
        self.backgroundColor = myred;
    }
    
    
    stockFluctuateLabel.text = [[NSString alloc] initWithFormat:@"%.2f", model.fluctuate];
    stockFluctuateLabel.textColor = [UIColor whiteColor];
    stockFluctuateLabel.font = [UIFont fontWithName:fontName size:minFont];
    
    stockFluctuateValueLabel.text = [[NSString alloc] initWithFormat:@"%.2f", model.fluctuate]
    
}

+ (CGFloat)cellHeight
{
    return 16*minSpace;
}

@end
