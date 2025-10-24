//+------------------------------------------------------------------+
//|                                             BitcoinTradingEA.mq5 |
//|                                         MetaTrader 5 Expert Advisor |
//|                      Automated Bitcoin Trading with Advanced Risk Management |
//+------------------------------------------------------------------+
#property copyright "BitcoinTradingEA"
#property version   "1.00"
#property description "Automated Bitcoin trading EA optimized for cryptocurrency volatility"

//--- Include necessary libraries
#include <Trade\Trade.mqh>

//--- Input Parameters
input group "=== Trading Strategy ==="
input int      FastEMA_Period = 12;          // Fast EMA Period
input int      SlowEMA_Period = 26;          // Slow EMA Period
input int      SignalEMA_Period = 9;         // Signal EMA Period
input int      RSI_Period = 14;              // RSI Period
input double   RSI_Oversold = 35;            // RSI Oversold Level
input double   RSI_Overbought = 65;          // RSI Overbought Level
input int      ATR_Period = 14;              // ATR Period for volatility
input double   ATR_Multiplier = 2.0;         // ATR Multiplier for dynamic SL/TP

input group "=== Risk Management ==="
input double   RiskPercent = 1.0;            // Risk Per Trade (% of balance)
input double   StopLossPips = 500.0;         // Base Stop Loss in Pips (for BTC)
input double   TakeProfitPips = 1000.0;      // Base Take Profit in Pips (for BTC)
input bool     UseDynamicSLTP = true;        // Use ATR-based dynamic SL/TP
input double   MaxSpreadPips = 50.0;         // Maximum Spread (pips)
input bool     UseTrailingStop = true;       // Use Trailing Stop
input double   TrailingStopPips = 300.0;     // Trailing Stop Distance (pips)
input double   TrailingStepPips = 100.0;     // Trailing Stop Step (pips)

input group "=== Position Management ==="
input int      MagicNumber = 789456;         // Magic Number
input string   TradeComment = "BTC-EA";      // Trade Comment
input double   MaxLotSize = 10.0;            // Maximum Lot Size
input double   MinLotSize = 0.01;            // Minimum Lot Size
input int      MaxOpenPositions = 1;         // Maximum Open Positions

input group "=== Volatility Filter ==="
input bool     UseVolatilityFilter = true;   // Use Volatility Filter
input double   MinATR = 100.0;               // Minimum ATR (pips) to trade
input double   MaxATR = 2000.0;              // Maximum ATR (pips) to trade

input group "=== Trend Strength ==="
input bool     UseTrendFilter = true;        // Use Trend Strength Filter
input int      ADX_Period = 14;              // ADX Period
input double   MinADX = 20.0;                // Minimum ADX for trending market

input group "=== Trading Hours ==="
input bool     UseTimeFilter = false;        // Use Time Filter
input int      StartHour = 0;                // Start Trading Hour (0-23)
input int      EndHour = 23;                 // End Trading Hour (0-23)

//--- Global Variables
CTrade trade;
int handleFastEMA;
int handleSlowEMA;
int handleSignalEMA;
int handleRSI;
int handleATR;
int handleADX;
double fastEMA[];
double slowEMA[];
double signalEMA[];
double rsi[];
double atr[];
double adx[];
datetime lastBarTime = 0;
double pipValue = 0.0;  // Will be set in OnInit based on symbol digits

//+------------------------------------------------------------------+
//| Convert pips to points based on symbol digits                      |
//+------------------------------------------------------------------+
double PipsToPoints(double pips)
{
   return pips * pipValue;
}

//+------------------------------------------------------------------+
//| Convert points to pips based on symbol digits                      |
//+------------------------------------------------------------------+
double PointsToPips(double points)
{
   if(pipValue == 0.0) return 0.0;
   return points / pipValue;
}

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Set magic number
   trade.SetExpertMagicNumber(MagicNumber);
   
   //--- Calculate pip value based on symbol digits
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   if(digits == 3 || digits == 5)
      pipValue = _Point * 10;  // 5-digit or 3-digit broker
   else
      pipValue = _Point;        // 4-digit or 2-digit broker
   
   Print("Symbol digits: ", digits, ", Pip value: ", pipValue);
   
   //--- Initialize indicators
   handleFastEMA = iMA(_Symbol, PERIOD_CURRENT, FastEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleSlowEMA = iMA(_Symbol, PERIOD_CURRENT, SlowEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleSignalEMA = iMA(_Symbol, PERIOD_CURRENT, SignalEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleRSI = iRSI(_Symbol, PERIOD_CURRENT, RSI_Period, PRICE_CLOSE);
   handleATR = iATR(_Symbol, PERIOD_CURRENT, ATR_Period);
   handleADX = iADX(_Symbol, PERIOD_CURRENT, ADX_Period);
   
   //--- Check if indicators are valid
   if(handleFastEMA == INVALID_HANDLE || handleSlowEMA == INVALID_HANDLE || 
      handleSignalEMA == INVALID_HANDLE || handleRSI == INVALID_HANDLE || 
      handleATR == INVALID_HANDLE || handleADX == INVALID_HANDLE)
   {
      Print("Error initializing indicators");
      return(INIT_FAILED);
   }
   
   //--- Set array as series
   ArraySetAsSeries(fastEMA, true);
   ArraySetAsSeries(slowEMA, true);
   ArraySetAsSeries(signalEMA, true);
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(atr, true);
   ArraySetAsSeries(adx, true);
   
   Print("BitcoinTradingEA initialized successfully for ", _Symbol);
   Print("Strategy: EMA Crossover + RSI + Volatility Filter");
   Print("Risk per trade: ", RiskPercent, "%");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(handleFastEMA != INVALID_HANDLE) IndicatorRelease(handleFastEMA);
   if(handleSlowEMA != INVALID_HANDLE) IndicatorRelease(handleSlowEMA);
   if(handleSignalEMA != INVALID_HANDLE) IndicatorRelease(handleSignalEMA);
   if(handleRSI != INVALID_HANDLE) IndicatorRelease(handleRSI);
   if(handleATR != INVALID_HANDLE) IndicatorRelease(handleATR);
   if(handleADX != INVALID_HANDLE) IndicatorRelease(handleADX);
   
   Print("BitcoinTradingEA deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check if new bar
   datetime currentBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(currentBarTime == lastBarTime) return;
   lastBarTime = currentBarTime;
   
   //--- Copy indicator data
   if(CopyBuffer(handleFastEMA, 0, 0, 3, fastEMA) <= 0) return;
   if(CopyBuffer(handleSlowEMA, 0, 0, 3, slowEMA) <= 0) return;
   if(CopyBuffer(handleSignalEMA, 0, 0, 3, signalEMA) <= 0) return;
   if(CopyBuffer(handleRSI, 0, 0, 2, rsi) <= 0) return;
   if(CopyBuffer(handleATR, 0, 0, 2, atr) <= 0) return;
   if(CopyBuffer(handleADX, 0, 0, 2, adx) <= 0) return;
   
   //--- Check filters
   if(!CheckSpreadFilter()) return;
   if(!CheckTimeFilter()) return;
   if(!CheckVolatilityFilter()) return;
   if(!CheckTrendFilter()) return;
   
   //--- Check if we can open new positions
   if(CountOpenPositions() >= MaxOpenPositions) return;
   
   //--- Check for trading signals
   CheckForBuySignal();
   CheckForSellSignal();
   
   //--- Manage open positions
   ManagePositions();
}

//+------------------------------------------------------------------+
//| Check spread filter                                                |
//+------------------------------------------------------------------+
bool CheckSpreadFilter()
{
   double spread = (SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID));
   double spreadPips = PointsToPips(spread);
   
   if(spreadPips > MaxSpreadPips)
   {
      return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| Check time filter                                                  |
//+------------------------------------------------------------------+
bool CheckTimeFilter()
{
   if(!UseTimeFilter) return true;
   
   MqlDateTime dt;
   if(!TimeCurrent(dt))
   {
      Print("Error getting current time: ", GetLastError());
      return false;
   }
   
   if(StartHour <= EndHour)
   {
      if(dt.hour >= StartHour && dt.hour < EndHour)
         return true;
   }
   else // Overnight trading
   {
      if(dt.hour >= StartHour || dt.hour < EndHour)
         return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Check volatility filter                                            |
//+------------------------------------------------------------------+
bool CheckVolatilityFilter()
{
   if(!UseVolatilityFilter) return true;
   
   double currentATR = atr[0];
   double atrPips = PointsToPips(currentATR);
   
   if(atrPips < MinATR || atrPips > MaxATR)
   {
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check trend filter                                                 |
//+------------------------------------------------------------------+
bool CheckTrendFilter()
{
   if(!UseTrendFilter) return true;
   
   double currentADX = adx[0];
   
   if(currentADX < MinADX)
   {
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Count open positions                                               |
//+------------------------------------------------------------------+
int CountOpenPositions()
{
   int count = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && 
            PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            count++;
         }
      }
   }
   return count;
}

//+------------------------------------------------------------------+
//| Check for buy signal                                               |
//+------------------------------------------------------------------+
void CheckForBuySignal()
{
   //--- EMA Crossover: Fast crosses above Slow
   bool emaCrossover = (fastEMA[0] > slowEMA[0]) && (fastEMA[1] <= slowEMA[1]);
   
   //--- Fast EMA above Signal EMA (momentum confirmation)
   bool momentumConfirm = fastEMA[0] > signalEMA[0];
   
   //--- RSI oversold or rising
   bool rsiCondition = rsi[0] < RSI_Overbought;
   
   //--- All conditions met
   if(emaCrossover && momentumConfirm && rsiCondition)
   {
      double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double sl, tp;
      CalculateSLTP(true, price, sl, tp);
      
      double lotSize = CalculateLotSize(sl);
      
      if(trade.Buy(lotSize, _Symbol, price, sl, tp, TradeComment))
      {
         Print("BUY order opened at ", price, " | SL: ", sl, " | TP: ", tp, " | Lot: ", lotSize);
      }
      else
      {
         Print("Error opening BUY order: ", GetLastError());
      }
   }
}

//+------------------------------------------------------------------+
//| Check for sell signal                                              |
//+------------------------------------------------------------------+
void CheckForSellSignal()
{
   //--- EMA Crossover: Fast crosses below Slow
   bool emaCrossover = (fastEMA[0] < slowEMA[0]) && (fastEMA[1] >= slowEMA[1]);
   
   //--- Fast EMA below Signal EMA (momentum confirmation)
   bool momentumConfirm = fastEMA[0] < signalEMA[0];
   
   //--- RSI overbought or falling
   bool rsiCondition = rsi[0] > RSI_Oversold;
   
   //--- All conditions met
   if(emaCrossover && momentumConfirm && rsiCondition)
   {
      double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double sl, tp;
      CalculateSLTP(false, price, sl, tp);
      
      double lotSize = CalculateLotSize(sl);
      
      if(trade.Sell(lotSize, _Symbol, price, sl, tp, TradeComment))
      {
         Print("SELL order opened at ", price, " | SL: ", sl, " | TP: ", tp, " | Lot: ", lotSize);
      }
      else
      {
         Print("Error opening SELL order: ", GetLastError());
      }
   }
}

//+------------------------------------------------------------------+
//| Calculate Stop Loss and Take Profit                                |
//+------------------------------------------------------------------+
void CalculateSLTP(bool isBuy, double price, double &sl, double &tp)
{
   double slDistance, tpDistance;
   
   if(UseDynamicSLTP)
   {
      //--- Use ATR-based dynamic SL/TP
      double currentATR = atr[0];
      slDistance = currentATR * ATR_Multiplier;
      tpDistance = currentATR * ATR_Multiplier * 2.0;
   }
   else
   {
      //--- Use fixed pip-based SL/TP
      slDistance = PipsToPoints(StopLossPips);
      tpDistance = PipsToPoints(TakeProfitPips);
   }
   
   //--- Calculate SL and TP levels
   if(isBuy)
   {
      sl = price - slDistance;
      tp = price + tpDistance;
   }
   else
   {
      sl = price + slDistance;
      tp = price - tpDistance;
   }
   
   //--- Normalize prices
   sl = NormalizeDouble(sl, _Digits);
   tp = NormalizeDouble(tp, _Digits);
}

//+------------------------------------------------------------------+
//| Calculate lot size based on risk                                   |
//+------------------------------------------------------------------+
double CalculateLotSize(double stopLoss)
{
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = accountBalance * (RiskPercent / 100.0);
   
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double slDistance = MathAbs(price - stopLoss);
   
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   if(tickSize == 0 || slDistance == 0)
   {
      Print("Invalid tick size or SL distance");
      return MinLotSize;
   }
   
   double lotSize = riskAmount / (slDistance / tickSize * tickValue);
   
   //--- Normalize lot size
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   lotSize = MathFloor(lotSize / lotStep) * lotStep;
   
   //--- Apply min/max limits
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   
   if(lotSize < minLot) lotSize = minLot;
   if(lotSize > maxLot) lotSize = maxLot;
   if(lotSize < MinLotSize) lotSize = MinLotSize;
   if(lotSize > MaxLotSize) lotSize = MaxLotSize;
   
   return NormalizeDouble(lotSize, 2);
}

//+------------------------------------------------------------------+
//| Manage open positions                                              |
//+------------------------------------------------------------------+
void ManagePositions()
{
   if(!UseTrailingStop) return;
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) != _Symbol || 
            PositionGetInteger(POSITION_MAGIC) != MagicNumber)
            continue;
         
         ulong ticket = PositionGetInteger(POSITION_TICKET);
         double positionOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentSL = PositionGetDouble(POSITION_SL);
         double currentTP = PositionGetDouble(POSITION_TP);
         long positionType = PositionGetInteger(POSITION_TYPE);
         
         double currentPrice = (positionType == POSITION_TYPE_BUY) ? 
                               SymbolInfoDouble(_Symbol, SYMBOL_BID) : 
                               SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         
         double trailDistance = PipsToPoints(TrailingStopPips);
         double trailStep = PipsToPoints(TrailingStepPips);
         
         if(positionType == POSITION_TYPE_BUY)
         {
            double newSL = currentPrice - trailDistance;
            
            if(currentPrice > positionOpenPrice + trailDistance)
            {
               if(newSL > currentSL + trailStep || currentSL == 0)
               {
                  newSL = NormalizeDouble(newSL, _Digits);
                  if(trade.PositionModify(ticket, newSL, currentTP))
                  {
                     Print("Trailing stop updated for BUY position #", ticket, " New SL: ", newSL);
                  }
               }
            }
         }
         else if(positionType == POSITION_TYPE_SELL)
         {
            double newSL = currentPrice + trailDistance;
            
            if(currentPrice < positionOpenPrice - trailDistance)
            {
               if(newSL < currentSL - trailStep || currentSL == 0)
               {
                  newSL = NormalizeDouble(newSL, _Digits);
                  if(trade.PositionModify(ticket, newSL, currentTP))
                  {
                     Print("Trailing stop updated for SELL position #", ticket, " New SL: ", newSL);
                  }
               }
            }
         }
      }
   }
}
//+------------------------------------------------------------------+
