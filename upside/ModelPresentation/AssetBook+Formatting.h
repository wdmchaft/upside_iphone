//
//  AssetBook+Formatting.h
//  StockPlay
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AssetBook.h"

@class StockCache;

// Presentation aspect for overall assets.
@interface AssetBook (Formatting)

// Format the available cash.
-(NSString*)formattedCash;

// The color showing the available cash.
-(UIColor*)colorForCash;

// Format the stock worth.
-(NSString*)formattedStockWorthWithCache:(StockCache*)stockCache;

// Format the net worth.
-(NSString*)formattedNetWorthWithCache:(StockCache*)stockCache;

// Image depicting the change in networth from the baseline in a PortfolioStat.
-(UIImage*)imageForNetWorthChangeFrom:(PortfolioStat*)stat
                           stockCache:(StockCache*)stockCache;

@end
