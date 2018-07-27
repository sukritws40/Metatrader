//+------------------------------------------------------------------+
//|                                                MovingAverage.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <ChartObjects\ChartObjectsLines.mqh>
#include <ChartObjects\ChartObjectsShapes.mqh>
#include <Common\Comparators.mqh>
#include <Signals\AbstractSignal.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MovingAverage : public AbstractSignal
  {
private:
   Comparators       _compare;
   int               _maPeriod;
   double            _movingAverage;
   double            _movingAveragePrevious;
   ENUM_MA_METHOD    _maMethod;
   ENUM_APPLIED_PRICE _maAppliedPrice;
   int               _maShift;
   color             _maColor;
   CChartObjectTrend _maIndicator;
public:
   void              DrawIndicator(string symbol,int shift);
                     MovingAverage(int maPeriod,ENUM_TIMEFRAMES timeframe,ENUM_MA_METHOD maMethod,ENUM_APPLIED_PRICE maAppliedPrice,int maShift,int shift=0,color maColor=clrHotPink);
   bool              Validate(ValidationResult *v);
   SignalResult     *Analyze(string symbol,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MovingAverage::MovingAverage(int maPeriod,ENUM_TIMEFRAMES timeframe,ENUM_MA_METHOD maMethod,ENUM_APPLIED_PRICE maAppliedPrice,int maShift,int shift=0,color maColor=clrHotPink)
  {
   this._maPeriod=maPeriod;
   this.Timeframe(timeframe);
   this._maMethod=maMethod;
   this._maAppliedPrice=maAppliedPrice;
   this._maShift=maShift;
   this._maColor=maColor;
   this.Shift(shift);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MovingAverage::Validate(ValidationResult *v)
  {
   v.Result=true;

   if(!this._compare.IsNotBelow(this._maPeriod,1))
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
void MovingAverage::DrawIndicator(string symbol,int shift)
  {
   if(!this.DoesChartHaveEnoughBars(symbol,(shift+this._maPeriod*2)))
     {
      return;
     }

   long chartId=MarketWatch::GetChartId(symbol,this.Timeframe());
   if(this._maIndicator.Attach(chartId,this.ID(),0,2))
     {
      this._maIndicator.SetPoint(0,Time[shift+this._maPeriod],this._movingAveragePrevious);
      this._maIndicator.SetPoint(1,Time[shift],this._movingAverage);
     }
   else
     {
      this._maIndicator.Create(chartId,this.ID(),0,Time[shift+this._maPeriod],this._movingAveragePrevious,Time[shift],this._movingAverage);
      this._maIndicator.Color(this._maColor);
      this._maIndicator.Background(false);
     }

   ChartRedraw(chartId);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *MovingAverage::Analyze(string symbol,int shift)
  {
   this.Signal.Reset();

   if(!this.DoesHistoryGoBackFarEnough(symbol,(shift+this._maPeriod*2)))
     {
      return this.Signal;
     }

   this._movingAverage=iMA(symbol,this.Timeframe(),this._maPeriod,this._maShift,this._maMethod,this._maAppliedPrice,shift);
   this._movingAveragePrevious=iMA(symbol,this.Timeframe(),this._maPeriod,this._maShift,this._maMethod,this._maAppliedPrice,this._maPeriod+shift);

   this.DrawIndicator(symbol,shift);

   MqlTick tick;
   bool gotTick=SymbolInfoTick(symbol,tick);

   if(gotTick)
     {
      if(this._movingAverage<this._movingAveragePrevious)
        {
         this.Signal.isSet=true;
         this.Signal.time=tick.time;
         this.Signal.symbol=symbol;
         this.Signal.orderType=OP_SELL;
         this.Signal.price=tick.bid;
         this.Signal.stopLoss=0;
         this.Signal.takeProfit=0;
        }
      if(this._movingAverage>this._movingAveragePrevious)
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
