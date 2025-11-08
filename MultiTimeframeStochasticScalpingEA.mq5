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

input group "=== Stochastic Filters ==="
input double   BuyStochLevel = 40.0;      // Buy only when Stochastic < this level
input double   SellStochLevel = 60.0;     // Sell only when Stochastic > this level

input group "=== Trailing Stop Settings ==="
input bool     UseTrailingStop = true;    // Enable Trailing Stop
input double   TrailingStopPips = 20.0;   // Trailing Stop Distance (pips)
input double   TrailingStepPips = 5.0;    // Trailing Step (pips)

input group "=== Trailing Profit Settings ==="
input bool     UseTrailingProfit = true;  // Enable Trailing Take Profit
input double   TrailingProfitPips = 30.0; // Trailing Profit Distance (pips)
input double   TrailingProfitStep = 5.0;  // Trailing Profit Step (pips)

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
   
   //--- Copy stochastic data for M1 (need 5 candles: 1=last completed, 2=before last, 3,4=previous two completed)
   if(CopyBuffer(handleStoch_M1, 0, 0, 5, stochMain_M1) < 5) return;      // Main line (K)
   if(CopyBuffer(handleStoch_M1, 1, 0, 5, stochSignal_M1) < 5) return;    // Signal line (D)
   
   //--- Copy stochastic data for M5 (need 3 candles: 1=last completed, 2=before last)
   if(CopyBuffer(handleStoch_M5, 0, 0, 3, stochMain_M5) < 3) return;      // Main line (K)
   if(CopyBuffer(handleStoch_M5, 1, 0, 3, stochSignal_M5) < 3) return;    // Signal line (D)
   
   //--- Copy stochastic data for M15 (need 2 candles: 1=last completed)
   if(CopyBuffer(handleStoch_M15, 0, 0, 3, stochMain_M15) < 2) return;    // Main line (K)
   if(CopyBuffer(handleStoch_M15, 1, 0, 3, stochSignal_M15) < 2) return;  // Signal line (D)
   
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
   
   //--- Manage existing positions (trailing stop and trailing profit)
   ManageOpenPositions();
}

//+------------------------------------------------------------------+
//| Manage Open Positions - Trailing Stop and Trailing Profit       |
//+------------------------------------------------------------------+
void ManageOpenPositions()
{
   if(!UseTrailingStop && !UseTrailingProfit)
      return;  // Nothing to do if both features are disabled
   
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      
      double positionOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double currentSL = PositionGetDouble(POSITION_SL);
      double currentTP = PositionGetDouble(POSITION_TP);
      long positionType = PositionGetInteger(POSITION_TYPE);
      
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      
      double newSL = currentSL;
      double newTP = currentTP;
      bool modifyNeeded = false;
      
      if(positionType == POSITION_TYPE_BUY)
      {
         //--- Trailing Stop for BUY
         if(UseTrailingStop && bid > positionOpenPrice)
         {
            double trailStopPrice = bid - TrailingStopPips * 10 * point;
            
            // Only move SL if new SL is higher than current and price moved enough
            if(currentSL == 0 || (trailStopPrice > currentSL && (trailStopPrice - currentSL) >= TrailingStepPips * 10 * point))
            {
               newSL = NormalizeDouble(trailStopPrice, digits);
               modifyNeeded = true;
            }
         }
         
         //--- Trailing Profit for BUY
         if(UseTrailingProfit && bid > positionOpenPrice)
         {
            double trailProfitPrice = bid + TrailingProfitPips * 10 * point;
            
            // Move TP closer to price as it moves up, or set it if not set
            if(currentTP == 0 || (trailProfitPrice > currentTP && (trailProfitPrice - currentTP) >= TrailingProfitStep * 10 * point))
            {
               newTP = NormalizeDouble(trailProfitPrice, digits);
               modifyNeeded = true;
            }
         }
      }
      else if(positionType == POSITION_TYPE_SELL)
      {
         //--- Trailing Stop for SELL
         if(UseTrailingStop && ask < positionOpenPrice)
         {
            double trailStopPrice = ask + TrailingStopPips * 10 * point;
            
            // Only move SL if new SL is lower than current and price moved enough
            if(currentSL == 0 || (trailStopPrice < currentSL && (currentSL - trailStopPrice) >= TrailingStepPips * 10 * point))
            {
               newSL = NormalizeDouble(trailStopPrice, digits);
               modifyNeeded = true;
            }
         }
         
         //--- Trailing Profit for SELL
         if(UseTrailingProfit && ask < positionOpenPrice)
         {
            double trailProfitPrice = ask - TrailingProfitPips * 10 * point;
            
            // Move TP closer to price as it moves down, or set it if not set
            if(currentTP == 0 || (trailProfitPrice < currentTP && (currentTP - trailProfitPrice) >= TrailingProfitStep * 10 * point))
            {
               newTP = NormalizeDouble(trailProfitPrice, digits);
               modifyNeeded = true;
            }
         }
      }
      
      //--- Modify position if needed
      if(modifyNeeded && (newSL != currentSL || newTP != currentTP))
      {
         if(trade.PositionModify(ticket, newSL, newTP))
         {
            Print("Position #", ticket, " modified successfully.");
            Print("  New Stop Loss: ", newSL);
            Print("  New Take Profit: ", newTP);
         }
         else
         {
            Print("Error modifying position #", ticket, ": ", GetLastError());
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Check for SELL signal                                            |
//+------------------------------------------------------------------+
bool CheckSellSignal()
{
   //--- M1 Conditions (using completed candles only):
   //    1. Last completed candle (1): K < D
   //    2. Before last candle (2): K < D
   //    3. 2 candles before (3, 4): D < K (previous opposite momentum)
   bool m1_last = stochMain_M1[1] < stochSignal_M1[1];
   bool m1_before_last = stochMain_M1[2] < stochSignal_M1[2];
   bool m1_before3 = stochSignal_M1[3] < stochMain_M1[3];
   bool m1_before4 = stochSignal_M1[4] < stochMain_M1[4];
   
   bool m1_condition = m1_last && m1_before_last && m1_before3 && m1_before4;
   
   //--- M5 Conditions (using completed candles only):
   //    1. Last completed candle (1): K < D
   //    2. Before last candle (2): K < D
   bool m5_last = stochMain_M5[1] < stochSignal_M5[1];
   bool m5_before_last = stochMain_M5[2] < stochSignal_M5[2];
   
   bool m5_condition = m5_last && m5_before_last;
   
   //--- M15 Conditions (using completed candles only):
   //    1. Last completed candle (1): K < D
   bool m15_last = stochMain_M15[1] < stochSignal_M15[1];
   
   bool m15_condition = m15_last;
   
   //--- Check stochastic level: must be > 60 for sell signal (using last completed candle)
   bool stoch_level_ok = stochMain_M1[1] > SellStochLevel;
   
   //--- All conditions must be true for sell signal
   if(m1_condition && m5_condition && m15_condition && stoch_level_ok)
   {
      Print("===== SELL SIGNAL DETECTED =====");
      Print("Stochastic Level Check: K=", stochMain_M1[1], " > ", SellStochLevel, " (", stoch_level_ok, ")");
      Print("M1: Last[1] K=", stochMain_M1[1], " D=", stochSignal_M1[1], " (K<D: ", m1_last, ")");
      Print("M1: Before[2] K=", stochMain_M1[2], " D=", stochSignal_M1[2], " (K<D: ", m1_before_last, ")");
      Print("M1: Before[3] K=", stochMain_M1[3], " D=", stochSignal_M1[3], " (D<K: ", m1_before3, ")");
      Print("M1: Before[4] K=", stochMain_M1[4], " D=", stochSignal_M1[4], " (D<K: ", m1_before4, ")");
      Print("M5: Last[1] K=", stochMain_M5[1], " D=", stochSignal_M5[1], " (K<D: ", m5_last, ")");
      Print("M5: Before[2] K=", stochMain_M5[2], " D=", stochSignal_M5[2], " (K<D: ", m5_before_last, ")");
      Print("M15: Last[1] K=", stochMain_M15[1], " D=", stochSignal_M15[1], " (K<D: ", m15_last, ")");
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Check for BUY signal (opposite of SELL)                         |
//+------------------------------------------------------------------+
bool CheckBuySignal()
{
   //--- M1 Conditions (using completed candles only):
   //    1. Last completed candle (1): K > D
   //    2. Before last candle (2): K > D
   //    3. 2 candles before (3, 4): D > K (previous opposite momentum)
   bool m1_last = stochMain_M1[1] > stochSignal_M1[1];
   bool m1_before_last = stochMain_M1[2] > stochSignal_M1[2];
   bool m1_before3 = stochSignal_M1[3] > stochMain_M1[3];
   bool m1_before4 = stochSignal_M1[4] > stochMain_M1[4];
   
   bool m1_condition = m1_last && m1_before_last && m1_before3 && m1_before4;
   
   //--- M5 Conditions (using completed candles only):
   //    1. Last completed candle (1): K > D
   //    2. Before last candle (2): K > D
   bool m5_last = stochMain_M5[1] > stochSignal_M5[1];
   bool m5_before_last = stochMain_M5[2] > stochSignal_M5[2];
   
   bool m5_condition = m5_last && m5_before_last;
   
   //--- M15 Conditions (using completed candles only):
   //    1. Last completed candle (1): K > D
   bool m15_last = stochMain_M15[1] > stochSignal_M15[1];
   
   bool m15_condition = m15_last;
   
   //--- Check stochastic level: must be < 40 for buy signal (using last completed candle)
   bool stoch_level_ok = stochMain_M1[1] < BuyStochLevel;
   
   //--- All conditions must be true for buy signal
   if(m1_condition && m5_condition && m15_condition && stoch_level_ok)
   {
      Print("===== BUY SIGNAL DETECTED =====");
      Print("Stochastic Level Check: K=", stochMain_M1[1], " < ", BuyStochLevel, " (", stoch_level_ok, ")");
      Print("M1: Last[1] K=", stochMain_M1[1], " D=", stochSignal_M1[1], " (K>D: ", m1_last, ")");
      Print("M1: Before[2] K=", stochMain_M1[2], " D=", stochSignal_M1[2], " (K>D: ", m1_before_last, ")");
      Print("M1: Before[3] K=", stochMain_M1[3], " D=", stochSignal_M1[3], " (D>K: ", m1_before3, ")");
      Print("M1: Before[4] K=", stochMain_M1[4], " D=", stochSignal_M1[4], " (D>K: ", m1_before4, ")");
      Print("M5: Last[1] K=", stochMain_M5[1], " D=", stochSignal_M5[1], " (K>D: ", m5_last, ")");
      Print("M5: Before[2] K=", stochMain_M5[2], " D=", stochSignal_M5[2], " (K>D: ", m5_before_last, ")");
      Print("M15: Last[1] K=", stochMain_M15[1], " D=", stochSignal_M15[1], " (K>D: ", m15_last, ")");
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
