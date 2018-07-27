//+------------------------------------------------------------------+
//|                                                 ExtremeBreak.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <ChartObjects\ChartObjectsShapes.mqh>
#include <Common\Comparators.mqh>
#include <Signals\AbstractSignal.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ExtremeBreak : public AbstractSignal
  {
private:
   Comparators       _compare;
   int               _period;
   double            _low;
   double            _high;
   color             _breakoutColor;
   CChartObjectRectangle _s;
public:
   void              DrawIndicator(string symbol,int shift);
                     ExtremeBreak(int period,ENUM_TIMEFRAMES timeframe,int shift=2,color breakoutColor=clrAquamarine);
   bool              Validate(ValidationResult *v);
   SignalResult     *Analyze(string symbol,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ExtremeBreak::ExtremeBreak(int period,ENUM_TIMEFRAMES timeframe,int shift=2,color breakoutColor=clrAquamarine)
  {
   this._period=period;
   this.Timeframe(timeframe);
   this.Shift(shift);
   this._breakoutColor=breakoutColor;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ExtremeBreak::Validate(ValidationResult *v)
  {
   v.Result=true;

   if(!this._compare.IsNotBelow(this._period,1))
     {
      v.Result=false;
      v.AddMessage("Period must be 1 or greater.");
     }

   if(!this._compare.IsNotBelow(this.Shift(),0))
     {
      v.Result=false;
      v.AddMessage("Shift must be 0 or greater.");
     }

   return v.Result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ExtremeBreak::DrawIndicator(string symbol,int shift)
  {
   if(!this.DoesChartHaveEnoughBars(symbol,(shift+this._period)))
     {
      return;
     }

   long chartId=MarketWatch::GetChartId(symbol,this.Timeframe());
   if(_s.Attach(chartId,this.ID(),0,2))
     {
      _s.SetPoint(0,Time[shift+this._period],this._high);
      _s.SetPoint(1,Time[shift],this._low);
     }
   else
     {
      _s.Create(chartId,this.ID(),0,Time[shift+this._period],this._high,Time[shift],this._low);
      _s.Color(this._breakoutColor);
      _s.Background(false);
     }

   ChartRedraw(chartId);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *ExtremeBreak::Analyze(string symbol,int shift)
  {
   this.Signal.Reset();

   if(!this.DoesHistoryGoBackFarEnough(symbol,(shift+this._period)))
     {
      return this.Signal;
     }

   this._low  = iLow(symbol, this.Timeframe(), iLowest(symbol,this.Timeframe(),MODE_LOW,this._period,shift));
   this._high = iHigh(symbol, this.Timeframe(), iHighest(symbol,this.Timeframe(),MODE_HIGH,this._period,shift));

   this.DrawIndicator(symbol,shift);

   MqlTick tick;
   bool gotTick=SymbolInfoTick(symbol,tick);

   if(gotTick)
     {
      if(tick.bid<this._low)
        {
         this.Signal.isSet=true;
         this.Signal.time=tick.time;
         this.Signal.symbol=symbol;
         this.Signal.orderType=OP_SELL;
         this.Signal.price=tick.bid;
         this.Signal.stopLoss=0;
         this.Signal.takeProfit=0;
        }
      else if(tick.ask>this._high)
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
