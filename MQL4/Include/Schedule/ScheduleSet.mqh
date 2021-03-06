//+------------------------------------------------------------------+
//|                                                  ScheduleSet.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property description "Scheduling helper."
#property strict

#include <Generic\LinkedList.mqh>
#include <Schedule\Schedule.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ScheduleSet : public CLinkedList<Schedule *>
  {
public:
   string            Name;
   bool              DeleteSchedulesOnClear;
   bool              IsActive(datetime when);
   void              Clear(bool deleteSchedules=true);
   void              AddWeek(string dailyStart,string dailyEnd,ENUM_DAY_OF_WEEK startDay=MONDAY,ENUM_DAY_OF_WEEK endDay=FRIDAY);
   string            ToString();
   void              ScheduleSet();
   void             ~ScheduleSet();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ScheduleSet::ScheduleSet():CLinkedList<Schedule *>()
  {
   this.DeleteSchedulesOnClear=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ScheduleSet::~ScheduleSet()
  {
   this.Clear(this.DeleteSchedulesOnClear);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string  ScheduleSet::ToString(void)
  {
   return this.Name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSet::Clear(bool deleteSchedules=true)
  {
   if(deleteSchedules && this.Count()>0)
     {
      CLinkedListNode<Schedule*>*node=this.First();

      delete node.Value();

      do
        {
         node=node.Next();
         delete node.Value();
        }
      while(this.Last()!=node);
     }

   CLinkedList<Schedule *>::Clear();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSet::AddWeek(string dailyStartTime,string dailyEndTime,ENUM_DAY_OF_WEEK startDay=MONDAY,ENUM_DAY_OF_WEEK endDay=FRIDAY)
  {
   CLinkedList<ENUM_DAY_OF_WEEK>*Days=new CLinkedList<ENUM_DAY_OF_WEEK>();

   ENUM_DAY_OF_WEEK d[7]={SUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY};
   int ct=7;
   int i=0;
   for(i=0;i<ct;i++)
     {
      Days.Add(d[i]);
     }

   CLinkedListNode<ENUM_DAY_OF_WEEK>*node=Days.Find(startDay);
   CLinkedListNode<ENUM_DAY_OF_WEEK>*dayEnd=Days.Find(endDay);
   
   ENUM_DAY_OF_WEEK day=node.Value();
   this.Add(new Schedule(day,dailyStartTime,day,dailyEndTime));
   while(node!=dayEnd)
     {
      node=node.Next();
      day=node.Value();
      this.Add(new Schedule(day,dailyStartTime,day,dailyEndTime));
     }
   delete Days;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ScheduleSet::IsActive(datetime when)
  {
   bool out=false;
   if(this.Count()>0)
     {
   CLinkedListNode<Schedule*>*node=this.First();
   Schedule *s=node.Value();
   out=s.IsActive(when);
   if(out) return out;

   while(this.Last()!=node)
     {
      node=node.Next();
      s=node.Value();
      out=s.IsActive(when);
      if(out) break;
     }
     }
   return out;
  }
//+------------------------------------------------------------------+
