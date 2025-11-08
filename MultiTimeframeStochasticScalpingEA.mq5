//+------------------------------------------------------------------+
//|                      MultiTimeframeStochasticScalpingEA.mq5     |
//|                                         MetaTrader 5 Expert Advisor |
//|          Multi-Timeframe Stochastic Scalping Strategy (M1/M5/M15) |
//+------------------------------------------------------------------+
#property copyright "MultiTimeframeStochasticScalpingEA"
#property version   "1.00"
#property description "Scalping EA using Stochastic across M1, M5, and M15 timeframes"

//--- Include necessary libraries
#include <Trade\Trade.mqh>

//--- Input Parameters
input group "=== Stochastic Parameters ==="
input int      Stoch_K_Period = 14;       // Stochastic %K Period
input int      Stoch_D_Period = 3;        // Stochastic %D Period
input int      Stoch_Slowing = 3;         // Stochastic Slowing

input group "=== Risk Management ==="
input double   RiskPercent = 1.0;         // Risk Per Trade (% of balance)
input double   StopLossPips = 30.0;       // Stop Loss in Pips
input double   TakeProfitPips = 50.0;     // Take Profit in Pips
input double   MaxSpreadPips = 3.0;       // Maximum Spread (pips)

input group "=== Position Management ==="
input int      MagicNumber = 987654;      // Magic Number
input string   TradeComment = "MTFStochScalp"; // Trade Comment
input double   MaxLotSize = 10.0;         // Maximum Lot Size
input double   MinLotSize = 0.01;         // Minimum Lot Size
input int      MaxPositions = 1;          // Maximum Open Positions

input group "=== Trading Hours ==="
input bool     UseTimeFilter = false;     // Use Time Filter
input int      StartHour = 8;             // Start Trading Hour
input int      EndHour = 20;              // End Trading Hour

//--- Global Variables
CTrade trade;

// Stochastic handles for each timeframe
int handleStoch_M1;
int handleStoch_M5;
int handleStoch_M15;

// Arrays for stochastic values
double stochMain_M1[];
double stochSignal_M1[];
double stochMain_M5[];
double stochSignal_M5[];
double stochMain_M15[];
double stochSignal_M15[];

datetime lastBarTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Set trade parameters
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(10);
   trade.SetTypeFilling(ORDER_FILLING_FOK);
   
   //--- Initialize stochastic indicators for each timeframe
   handleStoch_M1 = iStochastic(_Symbol, PERIOD_M1, Stoch_K_Period, Stoch_D_Period, Stoch_Slowing, MODE_SMA, STO_LOWHIGH);
   handleStoch_M5 = iStochastic(_Symbol, PERIOD_M5, Stoch_K_Period, Stoch_D_Period, Stoch_Slowing, MODE_SMA, STO_LOWHIGH);
   handleStoch_M15 = iStochastic(_Symbol, PERIOD_M15, Stoch_K_Period, Stoch_D_Period, Stoch_Slowing, MODE_SMA, STO_LOWHIGH);
   
   //--- Check if indicators are created successfully
   if(handleStoch_M1 == INVALID_HANDLE || handleStoch_M5 == INVALID_HANDLE || handleStoch_M15 == INVALID_HANDLE)
   {
      Print("Error creating stochastic indicators");
      return(INIT_FAILED);
   }
   
   //--- Set arrays as series
   ArraySetAsSeries(stochMain_M1, true);
   ArraySetAsSeries(stochSignal_M1, true);
   ArraySetAsSeries(stochMain_M5, true);
   ArraySetAsSeries(stochSignal_M5, true);
   ArraySetAsSeries(stochMain_M15, true);
   ArraySetAsSeries(stochSignal_M15, true);
   
   Print("MultiTimeframeStochasticScalpingEA initialized successfully");
   Print("Stochastic Parameters: %K=", Stoch_K_Period, " %D=", Stoch_D_Period, " Slowing=", Stoch_Slowing);
   Print("Timeframes: M1, M5, M15");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(handleStoch_M1 != INVALID_HANDLE) IndicatorRelease(handleStoch_M1);
   if(handleStoch_M5 != INVALID_HANDLE) IndicatorRelease(handleStoch_M5);
   if(handleStoch_M15 != INVALID_HANDLE) IndicatorRelease(handleStoch_M15);
   
   Print("MultiTimeframeStochasticScalpingEA deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check if new bar formed on M1
   datetime currentBarTime = iTime(_Symbol, PERIOD_M1, 0);
   if(currentBarTime == lastBarTime)
      return;
   lastBarTime = currentBarTime;
   
   //--- Check trading time
   if(UseTimeFilter && !IsWithinTradingHours())
      return;
   
   //--- Check spread
   if(!IsSpreadAcceptable())
      return;
   
   //--- Copy stochastic data for M1 (need 4 candles: 0=current, 1=last, 2,3=previous two)
   if(CopyBuffer(handleStoch_M1, 0, 0, 4, stochMain_M1) < 4) return;      // Main line (K)
   if(CopyBuffer(handleStoch_M1, 1, 0, 4, stochSignal_M1) < 4) return;    // Signal line (D)
   
   //--- Copy stochastic data for M5 (need 2 candles: 0=current, 1=previous)
   if(CopyBuffer(handleStoch_M5, 0, 0, 2, stochMain_M5) < 2) return;      // Main line (K)
   if(CopyBuffer(handleStoch_M5, 1, 0, 2, stochSignal_M5) < 2) return;    // Signal line (D)
   
   //--- Copy stochastic data for M15 (need 2 candles: 0=current, 1=previous)
   if(CopyBuffer(handleStoch_M15, 0, 0, 2, stochMain_M15) < 2) return;    // Main line (K)
   if(CopyBuffer(handleStoch_M15, 1, 0, 2, stochSignal_M15) < 2) return;  // Signal line (D)
   
   //--- Check if we can open new positions
   if(CountOpenPositions() >= MaxPositions)
      return;
   
   //--- Check for trading signals
   bool sellSignal = CheckSellSignal();
   bool buySignal = CheckBuySignal();
   
   //--- Execute trade based on signal
   if(sellSignal)
      OpenSellOrder();
   else if(buySignal)
      OpenBuyOrder();
}

//+------------------------------------------------------------------+
//| Check for SELL signal                                            |
//+------------------------------------------------------------------+
bool CheckSellSignal()
{
   //--- M1 Conditions:
   //    1. Current candle (0): K < D
   //    2. Last candle (1): K < D
   //    3. Last 2 candles before (2, 3): D < K
   bool m1_current = stochMain_M1[0] < stochSignal_M1[0];
   bool m1_last = stochMain_M1[1] < stochSignal_M1[1];
   bool m1_before2 = stochSignal_M1[2] < stochMain_M1[2];
   bool m1_before3 = stochSignal_M1[3] < stochMain_M1[3];
   
   bool m1_condition = m1_current && m1_last && m1_before2 && m1_before3;
   
   //--- M5 Conditions:
   //    1. Current candle (0): K < D
   //    2. Previous candle (1): K < D
   bool m5_current = stochMain_M5[0] < stochSignal_M5[0];
   bool m5_previous = stochMain_M5[1] < stochSignal_M5[1];
   
   bool m5_condition = m5_current && m5_previous;
   
   //--- M15 Conditions:
   //    1. Current candle (0): K < D
   //    2. Previous candle (1): K < D
   bool m15_current = stochMain_M15[0] < stochSignal_M15[0];
   bool m15_previous = stochMain_M15[1] < stochSignal_M15[1];
   
   bool m15_condition = m15_current && m15_previous;
   
   //--- All conditions must be true for sell signal
   if(m1_condition && m5_condition && m15_condition)
   {
      Print("===== SELL SIGNAL DETECTED =====");
      Print("M1: Current K=", stochMain_M1[0], " D=", stochSignal_M1[0], " (K<D: ", m1_current, ")");
      Print("M1: Last K=", stochMain_M1[1], " D=", stochSignal_M1[1], " (K<D: ", m1_last, ")");
      Print("M1: Before[2] K=", stochMain_M1[2], " D=", stochSignal_M1[2], " (D<K: ", m1_before2, ")");
      Print("M1: Before[3] K=", stochMain_M1[3], " D=", stochSignal_M1[3], " (D<K: ", m1_before3, ")");
      Print("M5: Current K=", stochMain_M5[0], " D=", stochSignal_M5[0], " (K<D: ", m5_current, ")");
      Print("M5: Previous K=", stochMain_M5[1], " D=", stochSignal_M5[1], " (K<D: ", m5_previous, ")");
      Print("M15: Current K=", stochMain_M15[0], " D=", stochSignal_M15[0], " (K<D: ", m15_current, ")");
      Print("M15: Previous K=", stochMain_M15[1], " D=", stochSignal_M15[1], " (K<D: ", m15_previous, ")");
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Check for BUY signal (opposite of SELL)                         |
//+------------------------------------------------------------------+
bool CheckBuySignal()
{
   //--- M1 Conditions:
   //    1. Current candle (0): K > D
   //    2. Last candle (1): K > D
   //    3. Last 2 candles before (2, 3): D > K
   bool m1_current = stochMain_M1[0] > stochSignal_M1[0];
   bool m1_last = stochMain_M1[1] > stochSignal_M1[1];
   bool m1_before2 = stochSignal_M1[2] > stochMain_M1[2];
   bool m1_before3 = stochSignal_M1[3] > stochMain_M1[3];
   
   bool m1_condition = m1_current && m1_last && m1_before2 && m1_before3;
   
   //--- M5 Conditions:
   //    1. Current candle (0): K > D
   //    2. Previous candle (1): K > D
   bool m5_current = stochMain_M5[0] > stochSignal_M5[0];
   bool m5_previous = stochMain_M5[1] > stochSignal_M5[1];
   
   bool m5_condition = m5_current && m5_previous;
   
   //--- M15 Conditions:
   //    1. Current candle (0): K > D
   //    2. Previous candle (1): K > D
   bool m15_current = stochMain_M15[0] > stochSignal_M15[0];
   bool m15_previous = stochMain_M15[1] > stochSignal_M15[1];
   
   bool m15_condition = m15_current && m15_previous;
   
   //--- All conditions must be true for buy signal
   if(m1_condition && m5_condition && m15_condition)
   {
      Print("===== BUY SIGNAL DETECTED =====");
      Print("M1: Current K=", stochMain_M1[0], " D=", stochSignal_M1[0], " (K>D: ", m1_current, ")");
      Print("M1: Last K=", stochMain_M1[1], " D=", stochSignal_M1[1], " (K>D: ", m1_last, ")");
      Print("M1: Before[2] K=", stochMain_M1[2], " D=", stochSignal_M1[2], " (D>K: ", m1_before2, ")");
      Print("M1: Before[3] K=", stochMain_M1[3], " D=", stochSignal_M1[3], " (D>K: ", m1_before3, ")");
      Print("M5: Current K=", stochMain_M5[0], " D=", stochSignal_M5[0], " (K>D: ", m5_current, ")");
      Print("M5: Previous K=", stochMain_M5[1], " D=", stochSignal_M5[1], " (K>D: ", m5_previous, ")");
      Print("M15: Current K=", stochMain_M15[0], " D=", stochSignal_M15[0], " (K>D: ", m15_current, ")");
      Print("M15: Previous K=", stochMain_M15[1], " D=", stochSignal_M15[1], " (K>D: ", m15_previous, ")");
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Open Buy Order                                                   |
//+------------------------------------------------------------------+
void OpenBuyOrder()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double sl = CalculateStopLoss(ORDER_TYPE_BUY, ask);
   double tp = CalculateTakeProfit(ORDER_TYPE_BUY, ask);
   double lotSize = CalculateLotSize(sl, ask);
   
   if(lotSize < MinLotSize || lotSize > MaxLotSize)
   {
      Print("Invalid lot size: ", lotSize);
      return;
   }
   
   if(trade.Buy(lotSize, _Symbol, ask, sl, tp, TradeComment))
   {
      Print("BUY order opened successfully.");
      Print("  Lot Size: ", lotSize);
      Print("  Entry Price: ", ask);
      Print("  Stop Loss: ", sl);
      Print("  Take Profit: ", tp);
   }
   else
   {
      Print("Error opening buy order: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Open Sell Order                                                  |
//+------------------------------------------------------------------+
void OpenSellOrder()
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl = CalculateStopLoss(ORDER_TYPE_SELL, bid);
   double tp = CalculateTakeProfit(ORDER_TYPE_SELL, bid);
   double lotSize = CalculateLotSize(sl, bid);
   
   if(lotSize < MinLotSize || lotSize > MaxLotSize)
   {
      Print("Invalid lot size: ", lotSize);
      return;
   }
   
   if(trade.Sell(lotSize, _Symbol, bid, sl, tp, TradeComment))
   {
      Print("SELL order opened successfully.");
      Print("  Lot Size: ", lotSize);
      Print("  Entry Price: ", bid);
      Print("  Stop Loss: ", sl);
      Print("  Take Profit: ", tp);
   }
   else
   {
      Print("Error opening sell order: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Calculate Stop Loss                                             |
//+------------------------------------------------------------------+
double CalculateStopLoss(ENUM_ORDER_TYPE orderType, double price)
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double sl = 0;
   
   if(orderType == ORDER_TYPE_BUY)
      sl = price - StopLossPips * 10 * point;
   else if(orderType == ORDER_TYPE_SELL)
      sl = price + StopLossPips * 10 * point;
   
   return NormalizeDouble(sl, digits);
}

//+------------------------------------------------------------------+
//| Calculate Take Profit                                           |
//+------------------------------------------------------------------+
double CalculateTakeProfit(ENUM_ORDER_TYPE orderType, double price)
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double tp = 0;
   
   if(orderType == ORDER_TYPE_BUY)
      tp = price + TakeProfitPips * 10 * point;
   else if(orderType == ORDER_TYPE_SELL)
      tp = price - TakeProfitPips * 10 * point;
   
   return NormalizeDouble(tp, digits);
}

//+------------------------------------------------------------------+
//| Calculate Lot Size based on risk                                |
//+------------------------------------------------------------------+
double CalculateLotSize(double stopLoss, double entryPrice)
{
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = accountBalance * RiskPercent / 100.0;
   
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   double stopLossPoints = MathAbs(entryPrice - stopLoss) / point;
   
   if(stopLossPoints == 0)
      return MinLotSize;
   
   double lotSize = riskAmount / (stopLossPoints * tickValue / tickSize);
   
   //--- Normalize lot size
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   lotSize = MathFloor(lotSize / lotStep) * lotStep;
   
   //--- Apply limits
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   
   if(lotSize < minLot) lotSize = minLot;
   if(lotSize > maxLot) lotSize = maxLot;
   if(lotSize > MaxLotSize) lotSize = MaxLotSize;
   if(lotSize < MinLotSize) lotSize = MinLotSize;
   
   return NormalizeDouble(lotSize, 2);
}

//+------------------------------------------------------------------+
//| Count open positions for this EA                                |
//+------------------------------------------------------------------+
int CountOpenPositions()
{
   int count = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      
      count++;
   }
   return count;
}

//+------------------------------------------------------------------+
//| Check if spread is acceptable                                   |
//+------------------------------------------------------------------+
bool IsSpreadAcceptable()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   double spreadPips = (ask - bid) / (10 * point);
   
   if(spreadPips > MaxSpreadPips)
   {
      Print("Spread too high: ", spreadPips, " pips");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check if within trading hours                                   |
//+------------------------------------------------------------------+
bool IsWithinTradingHours()
{
   MqlDateTime time;
   TimeToStruct(TimeCurrent(), time);
   
   if(time.hour >= StartHour && time.hour < EndHour)
      return true;
   
   return false;
}
//+------------------------------------------------------------------+
