//
//  Game.m
//  StockPlay
//
//  Created by Victor Costan on 1/6/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "Game.h"

#import "AssetBook.h"
#import "AssetBook+RSS.h"
#import "AssetBook+StockCache.h"
#import "ControllerSupport.h"
#import "GameSyncController.h"
#import "NewsCenter.h"
#import "PendingOrdersSubmittingController.h"
#import "Portfolio.h"
#import "StockCache.h"
#import "TradeBook.h"

@implementation Game

#pragma mark Lifecycle

-(id)init {
	if ((self = [super init])) {
		assetBook = [[AssetBook alloc] init];
		tradeBook = [[TradeBook alloc] init];
    
		newsCenter = [[NewsCenter alloc] init];
		stockCache = [[StockCache alloc] init];
    
    ZNTargetActionPair* syncSite =
        [[ZNTargetActionPair alloc] initWithTarget:self
                                            action:@selector(newGameData)];
		syncController = [[GameSyncController alloc] initWithGame:self];
    syncController.syncSite = syncSite;
    orderSubmittingController = [[PendingOrdersSubmittingController alloc]
                                 initWithTradeBook:tradeBook];
    orderSubmittingController.syncSite = syncSite;
    [syncSite release];
    
    newDataSite = [[ZNTargetActionSet alloc] init];
	}
	return self;
}

-(void)dealloc {
  [orderSubmittingController stopSyncing];
  [orderSubmittingController release];
  [syncController stopSyncing];
  [syncController release];
	[newsCenter release];
	[stockCache release];
	[assetBook release];
	[tradeBook release];
	[super dealloc];
}

# pragma mark Setup

-(void)setup {
	[assetBook loadRssFeedsIntoCenter:newsCenter];
	
	[assetBook loadTickersIntoStockCache:stockCache];
	[stockCache startSyncing];
	[syncController startSyncing];
  [orderSubmittingController startSyncing];
}

#pragma mark Accessors

@synthesize assetBook, tradeBook, stockCache, newsCenter;
@synthesize orderSubmittingController;
@synthesize newDataSite;

#pragma mark New Game Data Site

-(void)newGameData {
  [newDataSite perform];
}

#pragma mark Singleton

static Game* sharedGame = nil;

+(Game*)sharedGame {
	@synchronized(self) {
		if (sharedGame == nil) {
			sharedGame = [[Game alloc] init];
			[sharedGame setup];
		}
	}
	return sharedGame;
}

@end
