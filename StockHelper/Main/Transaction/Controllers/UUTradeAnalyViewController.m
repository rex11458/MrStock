//
//  UUTradeAnalyViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTradeAnalyViewController.h"
#import "UUPersonalHomeViewController.h"
#import "UULabelView.h"
#import "UUTradeAnalyView.h"
#import "UUTrandeAnalyStockHold.h"
#import "UUTrandeAnalyHistory.h"
#import "UUTransactionAssetModel.h"
@interface UUTradeAnalyViewController ()<UUPersonalHomeSectionViewDelegate>
{
    UUTradeAnalyView *_analyView;
    UUPersonalHomeSectionView *_sectionView;
    UUTradeAnalyHeaderView *_headerView;
    
    NSArray *_delegateArray;
    NSArray *_dataSourceArray;
}
@end

@implementation UUTradeAnalyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"交易分析";
    [self configSubViews];
}


- (void)configSubViews
{
    UUTrandeAnalyStockHoldDataSource *holdDataSource = [[UUTrandeAnalyStockHoldDataSource alloc] initWithUserId:self.userId];
    UUTrandeAnalyHistoryDataSource *historyDataSource = [[UUTrandeAnalyHistoryDataSource alloc] initWithUserId:self.userId];
    _dataSourceArray = @[holdDataSource,historyDataSource];
    
    UUTrandeAnalyStockHold *hold = [[UUTrandeAnalyStockHold alloc] init];;
    UUTrandeAnalyHistory *history = [[UUTrandeAnalyHistory alloc] init];
    _delegateArray = @[hold,history];
    
    _analyView = [[UUTradeAnalyView alloc] initWithFrame:self.view.bounds];
    _analyView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _analyView.delegate = _delegateArray[0];
    _analyView.dataSource = _dataSourceArray[0];
    _headerView = [self headerView];
    _headerView.assetModel = self.assetModel;
    _analyView.tableView.tableHeaderView = _headerView;
    _headerView.chatView.profitArray = self.profitArray;
      [self.view addSubview:_analyView];
    [_analyView reload];
    
    _sectionView = [self sectionView];
    
    //当前持仓
    [self sectionView:_sectionView didSelectedIndex:0];
}


- (UUTradeAnalyHeaderView *)headerView
{
    UUTradeAnalyHeaderView *headerView = [[UUTradeAnalyHeaderView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, UUTradeAnalyHeaderViewHeight)];
    _sectionView = [self sectionView];
    CGRect frame = _sectionView.frame;
    frame.origin.y = UUTradeAnalyHeaderViewHeight;
    _sectionView.frame = frame;
    frame = headerView.frame;
    frame.size.height += CGRectGetHeight(_sectionView.frame);
    headerView.frame = frame;
    [headerView addSubview:_sectionView];
    
    return headerView;
}

- (UUPersonalHomeSectionView *)sectionView
{
    UUPersonalHomeSectionView *sectionView = [[UUPersonalHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, 30.0f)];
    sectionView.delegate = self;
    sectionView.titles = @[@"当前持仓",@"历史交易"];
    return sectionView;
}

#pragma mark - UUPersonalHomeSectionViewDelegate
- (void)sectionView:(UUPersonalHomeSectionView *)sectionView didSelectedIndex:(NSInteger)index
{
    _analyView.delegate = _delegateArray[index];
    _analyView.dataSource = _dataSourceArray[index];
    [_analyView reload];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation UUTradeAnalyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = k_BG_COLOR;
        [self configSubViews];
    }
    return self;
}

/*
 *日收益   月收益  总收益
 *胜率 波动率 股票市值
 *平均持仓 仓位 月均交易次数
 
 */

- (void)configSubViews
{
    
    _labelViewArray = [NSMutableArray array];
    
    NSArray *contents = @[@"日收益率",@"月收益率",@"总收益率",@"胜率",@"最大回撤率",@"股票市值",@"平均持股(天)",@"月均交易次数",@"仓位"];
    
    CGFloat labelWidth = PHONE_WIDTH / 3.0f;
    CGFloat labelHeight = 60.0f;
    for (NSInteger i = 0 ; i < contents.count; i++) {
        CGRect frame = CGRectMake(i%3 * labelWidth, i / 3 *labelHeight, labelWidth, labelHeight);
        UULabelView *label = [[UULabelView alloc] initWithFrame:frame];
        label.underAttributes = @{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR};
        label.upperAttributes =  @{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
        label.underText = contents[i];
        label.upperText = @"--";
        label.backgroundColor = [UIColor whiteColor];
        label.layer.borderWidth = 0.25f;
        label.layer.borderColor = k_LINE_COLOR.CGColor;
        [self addSubview:label];
        [_labelViewArray addObject:label];
    }
    
    //初次交易 最近交易
    UILabel *startTradeLabel = [UIKitHelper labelWithFrame:CGRectMake(0,180.0f,PHONE_WIDTH * 0.5, 30.0f) Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    _startTradeLabel = startTradeLabel;
//    startTradeLabel.text = @"初次交易 2015-05-20";
    startTradeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:startTradeLabel];
    UILabel *lastesTradeLabel = [UIKitHelper labelWithFrame:CGRectMake(PHONE_WIDTH * 0.5,180.0f,PHONE_WIDTH * 0.5, 30.0f) Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    _lastesTradeLabel = lastesTradeLabel;
    lastesTradeLabel.textAlignment = NSTextAlignmentCenter;
//    lastesTradeLabel.text = @"最近交易 2015-05-20";
    [self addSubview:lastesTradeLabel];
    //图表
    _chatView = [[UUVirtualTransactionChatView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN,UUTradeAnalyHeaderViewHeight - k_BOTTOM_MARGIN - UUVirtualTransactionChatViewHeight, PHONE_WIDTH - 2 * k_LEFT_MARGIN, UUVirtualTransactionChatViewHeight)];
    [self addSubview:_chatView];
}

- (void)setAssetModel:(UUTransactionAssetModel *)assetModel
{
    if (assetModel == nil || assetModel == _assetModel) {
        return;
    }
    _assetModel = assetModel;
    [self fillData];
}

- (void)fillData
{
    /*
     winrate	Double	胜率
     weekProfit	Double	周收益率
     monthProfit	Double	月收益率
     beforeProfit	Double	上期收益率
     weekRank	Long	周排名
     monthRank	Long	月排名
     retracement	Double	最大回撤率
     avgTrade	Long	月均交易次数
     avgPosition	Long	平均持仓天数
     position	Double	仓位
     firstTradeDate	String	初次交易日期
     lastTradeDate	String	最近交易日期
     */
    
    //日收益
    NSString *dailyProft = [NSString stringWithFormat:@"%.2f%%",_assetModel.dayProfitRate];
    
    //月收益率
    NSString *monthProfit = [NSString stringWithFormat:@"%.2f%%",_assetModel.monthProfit*100];
    //总收益率
    NSString *totalProfit = [NSString stringWithFormat:@"%.2f%%",_assetModel.profitRate*100];
    //胜率
    NSString *winRate = [NSString stringWithFormat:@"%.2f%%",_assetModel.winrate*100];
    //最大回撤率
    NSString *retracement = [NSString stringWithFormat:@"%.2f%%",_assetModel.retracement*100];
    //股票市值
    NSString *marketValue = [NSString stringWithFormat:@"%.2f",_assetModel.marketValue];
    //平均持仓天数
    NSString *avgPosition =  [NSString stringWithFormat:@"%.0f",_assetModel.avgPosition];
    //月均交易次数
    NSString *avgTrade = [NSString stringWithFormat:@"%.0f",_assetModel.avgTrade];
    //仓位
    NSString *position = [NSString stringWithFormat:@"%.2f%%",_assetModel.position*100];
    
    NSArray *dataArray = @[dailyProft,monthProfit,totalProfit,winRate,retracement,marketValue,avgPosition,avgTrade,position];
    
    [_labelViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UULabelView *label = (UULabelView *)obj;
        NSString *dataString = dataArray[idx];
        UIColor *color = k_EQUAL_COLOR;
        if (idx < 3) {
            if ([dataString doubleValue] > 0) {
                
                color = k_UPPER_COLOR;
                dataString = [@"+" stringByAppendingString:dataString];
                
            }else if ([dataString doubleValue] < 0){
                color = k_UNDER_COLOR;
            }
            
            label.upperAttributes =  @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSForegroundColorAttributeName:color};
        }
        label.upperText = dataString;
    }];
 
    _startTradeLabel.text = [NSString stringWithFormat:@"初次交易  %@",_assetModel.firstTradeDate];
    _lastesTradeLabel.text = [NSString stringWithFormat:@"最后交易  %@",_assetModel.lastTradeDate];
}


@end
