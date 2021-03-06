//+------------------------------------------------------------------+
//|                                                PuppySettings.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

sinput string PuppySettings1; // ####
sinput string PuppySettings2; // #### Signal Settings
sinput string PuppySettings3; // ####

input int LcfpPeriod=30; // Period for calculating exits.
input double LcfpMinimumTpSlDistance=5; // Tp/Sl minimum distance, in spreads.
input bool LcfpInvertedSignal=false; // Invert Signal?
input double LcfpSkew=0.0; // Skew sl/tp spread

#include <EA\PortfolioManagerBasedBot\BasicSettings.mqh>
