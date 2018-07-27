//+------------------------------------------------------------------+
//|                                                 SignalResult.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property description "Signal Analysis Result."
#property strict
#include <Generic\HashMap.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SignalResult
  {
public:
   bool              isSet;
   datetime          time;
   string            symbol;
   ENUM_ORDER_TYPE   orderType;
   double            price;
   double            takeProfit;
   double            stopLoss;
   CHashMap<string,string>data;
   void              SignalResult();
   void              Reset();
   bool              IsValid();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SignalResult::SignalResult()
  {
   this.Reset();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SignalResult::Reset()
  {
   this.isSet=false;
   this.time=NULL;
   this.symbol=NULL;
   this.orderType=NULL;
   this.price=0;
   this.takeProfit=0;
   this.stopLoss=0;
   this.data.Clear();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SignalResult::IsValid()
  {
   if(
      (!this.isSet)
      || (this.price<=0)
      || (this.takeProfit<0)
      || (this.stopLoss<0)
      )
     {
      return false;
     }
   if(
      (this.orderType!=OP_BUY)
      && (this.orderType != OP_BUYSTOP)
      && (this.orderType != OP_BUYLIMIT)
      && (this.orderType != OP_SELL)
      && (this.orderType != OP_SELLSTOP)
      && (this.orderType != OP_SELLLIMIT)
      )
     {
      return false;
     }

   double point=MarketInfo(this.symbol,MODE_POINT);

   if(point<=0)
     {
      return false;
     }

   double minimumTpPoints=MarketInfo(this.symbol,MODE_STOPLEVEL);
   if(minimumTpPoints<0)
     {
      return false;
     }
     
   double minimumSlPoints=minimumTpPoints+MarketInfo(this.symbol,MODE_SPREAD);
   if(minimumSlPoints<0 || minimumSlPoints<=minimumTpPoints)
     {
      return false;
     }

   if(this.takeProfit>0)
     {
      if(MathAbs(this.price-this.takeProfit)/point<minimumTpPoints)
        {
         return false;
        }
     }

   if(this.stopLoss>0)
     {
      if(MathAbs(this.price-this.stopLoss)/point<minimumSlPoints)
        {
         return false;
        }
     }

   return true;
  }
//+------------------------------------------------------------------+
