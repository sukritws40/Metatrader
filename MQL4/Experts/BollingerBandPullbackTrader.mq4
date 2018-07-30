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

#include <EA\BollingerBandPullbackTrader.mqh>

input string WatchedSymbols="USDJPYpro,GBPUSDpro,USDCADpro,USDCHFpro,USDSEKpro"; // Currency Basket, csv list or blank for current chart.
input ENUM_TIMEFRAMES BollingerBandPullbackTimeframe=PERIOD_D1;

input int BollingerBandPullbackBbPeriod=30; // Period for Bollinger Bands.
input bool BollingerBandPullbackFadeTouch=false; // Fade the BB touch?
input int BollingerBandPullbackTouchPeriod=30; // How many bars is a BB touch valid?
input double BollingerBandPullbackBbDeviation=2; // BB standard deviation(s).
input ENUM_APPLIED_PRICE BollingerBandPullbackBbAppliedPrice=PRICE_OPEN;
input int BollingerBandPullbackTouchShift=0;
input int BollingerBandPullbackBbShift=0;
input color BollingerBandPullbackBbIndicatorColor=clrMagenta;
input color BollingerBandPullbackTouchIndicatorColor=clrAqua;

input int BollingerBandPullbackMaPeriod=30;
input int BollingerBandPullbackMaShift=0;
input ENUM_MA_METHOD BollingerBandPullbackMaMethod=MODE_EMA;
input ENUM_APPLIED_PRICE BollingerBandPullbackMaAppliedPrice=PRICE_TYPICAL;
input color BollingerBandPullbackMaColor=clrHotPink;

input int BollingerBandPullbackAtrPeriod=30;
input double BollingerBandPullbackAtrMultiplier=4;
input color BollingerBandPullbackAtrColor=clrWheat;

input int BollingerBandPullbackShift=0;
input double BollingerBandPullbackMinimumTpSlDistance=5; // Tp/Sl minimum distance, in spreads.
input int BollingerBandPullbackParallelSignals=2; // Quantity of parallel signals to use.
input double Lots=0.01;
input double ProfitTarget=0; // Profit target in account currency
input double MaxLoss=0; // Maximum allowed loss in account currency
input int Slippage=10; // Allowed slippage
extern ENUM_DAY_OF_WEEK Start_Day=0;//Start Day
extern ENUM_DAY_OF_WEEK End_Day=6;//End Day
extern string   Start_Time="00:00";//Start Time
extern string   End_Time="24:00";//End Time
input bool ScheduleIsDaily=false;// Use start and stop times daily?
input bool TradeAtBarOpenOnly=false;// Trade only at opening of new bar?
input bool PinExits=true; // Disable signals from moving exits backward?
input bool SwitchDirectionBySignal=true; // Allow signal switching to close orders?

BollingerBandPullbackTrader *bollingerBandPullbackTrader;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   delete bollingerBandPullbackTrader;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   string symbols=WatchedSymbols;
   ENUM_TIMEFRAMES timeframe=BollingerBandPullbackTimeframe;
   if(IsTesting())
     {
      symbols=Symbol();
      timeframe=PERIOD_CURRENT;
     }
   bollingerBandPullbackTrader=new BollingerBandPullbackTrader(
                                                               symbols,

                                                               BollingerBandPullbackBbPeriod,
                                                               BollingerBandPullbackFadeTouch,
                                                               BollingerBandPullbackTouchPeriod,
                                                               BollingerBandPullbackBbDeviation,
                                                               BollingerBandPullbackBbAppliedPrice,
                                                               BollingerBandPullbackTouchShift,
                                                               BollingerBandPullbackBbShift,
                                                               BollingerBandPullbackBbIndicatorColor,
                                                               BollingerBandPullbackTouchIndicatorColor,

                                                               BollingerBandPullbackMaPeriod,
                                                               BollingerBandPullbackMaShift,
                                                               BollingerBandPullbackMaMethod,
                                                               BollingerBandPullbackMaAppliedPrice,
                                                               BollingerBandPullbackMaColor,
                                                               
                                                               BollingerBandPullbackAtrPeriod,
                                                               BollingerBandPullbackAtrMultiplier,
                                                               BollingerBandPullbackShift,
                                                               BollingerBandPullbackAtrColor,
                                                               
                                                               BollingerBandPullbackMinimumTpSlDistance,
                                                               timeframe,
                                                               BollingerBandPullbackParallelSignals,
                                                               Lots,ProfitTarget,MaxLoss,Slippage,
                                                               Start_Day,End_Day,Start_Time,End_Time,ScheduleIsDaily,
                                                               TradeAtBarOpenOnly,PinExits,SwitchDirectionBySignal);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   bollingerBandPullbackTrader.Execute();
  }
//+------------------------------------------------------------------+
