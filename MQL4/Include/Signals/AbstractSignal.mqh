//+------------------------------------------------------------------+
//|                                               AbstractSignal.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <ChartObjects\ChartObjectsShapes.mqh>
#include <Common\ValidationResult.mqh>
#include <Signals\SignalResult.mqh>
#include <MarketWatch\MarketWatch.mqh>
#include <Generic\LinkedList.mqh>
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class AbstractSignal
  {
private:
   static int        idCount;
   string            id;
public:
   ENUM_TIMEFRAMES   Timeframe;
   int               Shift;
   SignalResult     *Signal;
   string            ID();
   void              AbstractSignal();
   void             ~AbstractSignal();
   virtual bool      Validate(ValidationResult *validationResult)=0;
   virtual bool      Validate();
   virtual SignalResult *Analyze(string symbol);
   virtual SignalResult *Analyze(string symbol,int shift)=0;
  };
static int AbstractSignal::idCount=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string AbstractSignal::ID()
  {
   return this.id;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AbstractSignal::AbstractSignal()
  {
   this.id=StringConcatenate("Signal",AbstractSignal::idCount);
   AbstractSignal::idCount+=1;
   this.Signal=new SignalResult();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AbstractSignal::~AbstractSignal()
  {
   delete this.Signal;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AbstractSignal::Validate()
  {
   ValidationResult *v=new ValidationResult();
   bool out=this.Validate(v);
   delete v;
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *AbstractSignal::Analyze(string symbol)
  {
   MarketWatch::LoadSymbolHistory(symbol,this.Timeframe,true);
   MarketWatch::OpenChartIfMissing(symbol,this.Timeframe);
   this.Analyze(symbol,this.Shift);
   return this.Signal;
  }
//+------------------------------------------------------------------+
