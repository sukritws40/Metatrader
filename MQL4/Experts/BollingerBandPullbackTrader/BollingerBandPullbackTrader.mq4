//+------------------------------------------------------------------+
//|                                  BollingerBandPullbackTrader.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property description "Criteria:"
#property description "1. Price touches bollinger band."
#property description "2. Price pulls back to the moving average."
#property description "3. Enter order anticipating price to move toward touched bollinger band."
#property description "4. Stopout level is to be controlled by Atr defined range around current price."
#property strict

#include <EA\BollingerBandPullbackTrader\BollingerBandPullbackTrader.mqh>
#include <EA\BollingerBandPullbackTrader\BollingerBandPullbackTraderSettings.mqh>
#include <EA\BollingerBandPullbackTrader\BollingerBandPullbackTraderConfig.mqh>

BollingerBandPullbackTrader *bot;
#include <EA\PortfolioManagerBasedBot\BasicEATemplate.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   BollingerBandPullbackTraderConfig config;

   GetBasicConfigs(config);

   config.bollingerBandPullbackTimeframe=PortfolioTimeframe;
   config.bollingerBandPullbackMinimumTpSlDistance=BollingerBandPullbackMinimumTpSlDistance;
   config.parallelSignals=BollingerBandPullbackParallelSignals;
   
   config.bollingerBandPullbackBbPeriod=BollingerBandPullbackBbPeriod;
   config.bollingerBandPullbackBbDeviation=BollingerBandPullbackBbDeviation;
   config.bollingerBandPullbackBbAppliedPrice=BollingerBandPullbackBbAppliedPrice;
   config.bollingerBandPullbackBbShift=BollingerBandPullbackBbShift;
   config.bollingerBandPullbackBbIndicatorColor=BollingerBandPullbackBbIndicatorColor;
   
   config.bollingerBandPullbackFadeTouch=BollingerBandPullbackFadeTouch;
   config.bollingerBandPullbackTouchPeriod=BollingerBandPullbackTouchPeriod;
   config.bollingerBandPullbackTouchShift=BollingerBandPullbackTouchShift;
   config.bollingerBandPullbackTouchIndicatorColor=BollingerBandPullbackTouchIndicatorColor;
   
   config.bollingerBandPullbackMaPeriod=BollingerBandPullbackMaPeriod;
   config.bollingerBandPullbackMaShift=BollingerBandPullbackMaShift;
   config.bollingerBandPullbackMaMethod=BollingerBandPullbackMaMethod;
   config.bollingerBandPullbackMaAppliedPrice=BollingerBandPullbackMaAppliedPrice;
   config.bollingerBandPullbackMaColor=BollingerBandPullbackMaColor;
   
   config.bollingerBandPullbackAtrPeriod=BollingerBandPullbackAtrPeriod;
   config.atrSkew=AtrSkew;
   config.bollingerBandPullbackAtrMultiplier=BollingerBandPullbackAtrMultiplier;
   config.bollingerBandPullbackShift=BollingerBandPullbackShift;
   config.bollingerBandPullbackAtrColor=BollingerBandPullbackAtrColor;

   bot=new BollingerBandPullbackTrader(config);

  }
//+------------------------------------------------------------------+
