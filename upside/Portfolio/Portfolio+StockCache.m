//
//  Portfolio+StockCache.m
//  upside
//
//  Created by Victor Costan on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Portfolio+StockCache.h"

#import "Position.h"
#import "StockCache.h"

@implementation Portfolio (StockCache)

- (void) loadTickersIntoStockCache: (StockCache*)stockCache {
  BOOL needsSync = NO;
	for (Position* position in positions) {
		if(![stockCache stockForTicker:[position ticker]])
      needsSync = YES;
	}
  if (needsSync)
    [stockCache syncOnce];
}

@end
