//+------------------------------------------------------------------+
//|                                                 ExtremeBreak.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\AbstractSignal.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ExtremeBreak : public AbstractSignal
  {
public:
                     ExtremeBreak(int period,ENUM_TIMEFRAMES timeframe,int shift=2,double minimumSpreadsTpSl=1,color indicatorColor=clrAquamarine);
   SignalResult     *Analyzer(string symbol,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ExtremeBreak::ExtremeBreak(int period,ENUM_TIMEFRAMES timeframe,int shift=2,double minimumSpreadsTpSl=1,color indicatorColor=clrAquamarine):AbstractSignal(period,timeframe,shift,indicatorColor,minimumSpreadsTpSl)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *ExtremeBreak::Analyzer(string symbol,int shift)
  {
   PriceRange pr=this.CalculateRangeByPriceLowHigh(symbol,shift);

   this.DrawIndicatorRectangle(symbol,shift,pr.high,pr.low);

   MqlTick tick;
   bool gotTick=SymbolInfoTick(symbol,tick);

   if(gotTick)
     {
      if(tick.bid<pr.low)
        {
         this.Signal.isSet=true;
         this.Signal.time=tick.time;
         this.Signal.symbol=symbol;
         this.Signal.orderType=OP_SELL;
         this.Signal.price=tick.bid;
         this.Signal.stopLoss=0;
         this.Signal.takeProfit=0;
        }
      else if(tick.ask>pr.high)
        {
         this.Signal.isSet=true;
         this.Signal.orderType=OP_BUY;
         this.Signal.price=tick.ask;
         this.Signal.symbol=symbol;
         this.Signal.time=tick.time;
         this.Signal.stopLoss=0;
         this.Signal.takeProfit=0;
        }
     }
   return this.Signal;
  }
//+------------------------------------------------------------------+
