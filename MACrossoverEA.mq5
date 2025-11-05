//+------------------------------------------------------------------+
//|                                                MACrossoverEA.mq5 |
//|                          MetaTrader 5 Expert Advisor             |
//|           MA Crossover Strategy with Trailing Stop & Take Profit |
//+------------------------------------------------------------------+
#property copyright "MACrossoverEA"
#property version   "1.00"
#property description "4 MA Crossover EA: MA19, MA38, MA58, MA209 with trailing stop and take profit"

//--- Include necessary libraries
#include <Trade\Trade.mqh>

//--- Input Parameters
input group "=== Moving Average Parameters ==="
input int      MA19_Period = 19;             // MA Period 19
input int      MA38_Period = 38;             // MA Period 38
input int      MA58_Period = 58;             // MA Period 58
input int      MA209_Period = 209;           // MA Period 209
input ENUM_MA_METHOD MA_Method = MODE_SMA;   // MA Method (SMA, EMA, etc.)
input ENUM_APPLIED_PRICE MA_Price = PRICE_CLOSE; // MA Applied Price

input group "=== Risk Management ==="
input double   RiskPercent = 1.0;            // Risk Per Trade (% of balance)
input double   StopLossPips = 30.0;          // Stop Loss in Pips
input double   TakeProfitPips = 60.0;        // Take Profit in Pips
input double   MaxSpreadPips = 3.0;          // Maximum Spread (pips)

input group "=== Trailing Stop Settings ==="
input bool     UseTrailingStop = true;       // Enable Trailing Stop
input double   TrailingStopPips = 20.0;      // Trailing Stop Distance (pips)
input double   TrailingStepPips = 5.0;       // Trailing Stop Step (pips)

input group "=== Position Management ==="
input int      MagicNumber = 789012;         // Magic Number
input string   TradeComment = "MACrossEA";   // Trade Comment
input double   MaxLotSize = 10.0;            // Maximum Lot Size
input double   MinLotSize = 0.01;            // Minimum Lot Size
input int      MaxOpenPositions = 1;         // Maximum Open Positions

input group "=== Trading Hours ==="
input bool     UseTimeFilter = false;        // Use Time Filter
input int      StartHour = 0;                // Start Trading Hour
input int      EndHour = 23;                 // End Trading Hour

//--- Global Variables
CTrade trade;
int handleMA19;
int handleMA38;
int handleMA58;
int handleMA209;
double ma19[];
double ma38[];
double ma58[];
double ma209[];
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
   
   //--- Initialize indicators
   handleMA19 = iMA(_Symbol, PERIOD_CURRENT, MA19_Period, 0, MA_Method, MA_Price);
   handleMA38 = iMA(_Symbol, PERIOD_CURRENT, MA38_Period, 0, MA_Method, MA_Price);
   handleMA58 = iMA(_Symbol, PERIOD_CURRENT, MA58_Period, 0, MA_Method, MA_Price);
   handleMA209 = iMA(_Symbol, PERIOD_CURRENT, MA209_Period, 0, MA_Method, MA_Price);
   
   //--- Check if indicators are created successfully
   if(handleMA19 == INVALID_HANDLE || handleMA38 == INVALID_HANDLE || 
      handleMA58 == INVALID_HANDLE || handleMA209 == INVALID_HANDLE)
   {
      Print("Error creating MA indicators");
      return(INIT_FAILED);
   }
   
   //--- Set arrays as series
   ArraySetAsSeries(ma19, true);
   ArraySetAsSeries(ma38, true);
   ArraySetAsSeries(ma58, true);
   ArraySetAsSeries(ma209, true);
   
   Print("===========================================");
   Print("MACrossoverEA initialized successfully");
   Print("Recommended Timeframe: M1 (1 minute)");
   Print("BUY when MAs CROSS to: MA19 > MA38 > MA58 < MA209");
   Print("SELL when MAs CROSS to: MA58 > MA38 > MA19 > MA209");
   Print("Crossover detection: Only triggers on transition");
   Print("===========================================");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(handleMA19 != INVALID_HANDLE) IndicatorRelease(handleMA19);
   if(handleMA38 != INVALID_HANDLE) IndicatorRelease(handleMA38);
   if(handleMA58 != INVALID_HANDLE) IndicatorRelease(handleMA58);
   if(handleMA209 != INVALID_HANDLE) IndicatorRelease(handleMA209);
   
   Print("MACrossoverEA deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check if new bar formed
   datetime currentBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(currentBarTime == lastBarTime)
      return;
   lastBarTime = currentBarTime;
   
   //--- Check trading time
   if(UseTimeFilter && !IsWithinTradingHours())
      return;
   
   //--- Check spread
   if(!IsSpreadAcceptable())
      return;
   
   //--- Copy indicator data
   if(CopyBuffer(handleMA19, 0, 0, 3, ma19) < 3) return;
   if(CopyBuffer(handleMA38, 0, 0, 3, ma38) < 3) return;
   if(CopyBuffer(handleMA58, 0, 0, 3, ma58) < 3) return;
   if(CopyBuffer(handleMA209, 0, 0, 3, ma209) < 3) return;
   
   //--- Update trailing stops for open positions
   if(UseTrailingStop)
      UpdateTrailingStops();
   
   //--- Check if we can open new positions
   if(CountManagedPositions() >= MaxOpenPositions)
      return; // Maximum positions reached
   
   //--- Get trading signals
   int signal = GetTradingSignal();
   
   //--- Execute trades based on signals
   if(signal == 1)
   {
      Print("BUY Signal detected!");
      PrintMAValues();
      OpenBuyOrder();
   }
   else if(signal == -1)
   {
      Print("SELL Signal detected!");
      PrintMAValues();
      OpenSellOrder();
   }
}

//+------------------------------------------------------------------+
//| Get trading signal based on MA crossover                        |
//+------------------------------------------------------------------+
int GetTradingSignal()
{
   // Ensure we have enough data for crossover detection (need indices 1 and 2)
   if(ArraySize(ma19) < 3 || ArraySize(ma38) < 3 || 
      ArraySize(ma58) < 3 || ArraySize(ma209) < 3)
   {
      return 0; // Not enough data for crossover detection
   }
   
   // Use current bar (index 1) to avoid repainting
   double ma19_val = ma19[1];
   double ma38_val = ma38[1];
   double ma58_val = ma58[1];
   double ma209_val = ma209[1];
   
   // Previous bar values (index 2) to detect crossover
   double ma19_prev = ma19[2];
   double ma38_prev = ma38[2];
   double ma58_prev = ma58[2];
   double ma209_prev = ma209[2];
   
   // BUY Signal: MA19 > MA38 > MA58 AND MA58 < MA209
   // Only trigger if this arrangement was NOT present in previous bar (crossover)
   bool buyConditionCurrent = (ma19_val > ma38_val && ma38_val > ma58_val && ma58_val < ma209_val);
   bool buyConditionPrevious = (ma19_prev > ma38_prev && ma38_prev > ma58_prev && ma58_prev < ma209_prev);
   
   if(buyConditionCurrent && !buyConditionPrevious)
   {
      return 1; // BUY - MAs just crossed into desired arrangement
   }
   
   // SELL Signal: MA58 > MA38 > MA19 > MA209
   // Only trigger if this arrangement was NOT present in previous bar (crossover)
   bool sellConditionCurrent = (ma58_val > ma38_val && ma38_val > ma19_val && ma19_val > ma209_val);
   bool sellConditionPrevious = (ma58_prev > ma38_prev && ma38_prev > ma19_prev && ma19_prev > ma209_prev);
   
   if(sellConditionCurrent && !sellConditionPrevious)
   {
      return -1; // SELL - MAs just crossed into desired arrangement
   }
   
   return 0; // No signal
}

//+------------------------------------------------------------------+
//| Count managed positions                                          |
//+------------------------------------------------------------------+
int CountManagedPositions()
{
   int count = 0;
   int total = PositionsTotal();
   
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      
      string psym = PositionGetString(POSITION_SYMBOL);
      long magic = PositionGetInteger(POSITION_MAGIC);
      
      if(psym != _Symbol) continue;
      if(magic != MagicNumber) continue;
      
      count++;
   }
   
   return count;
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
      Print("✓ Buy order opened successfully");
      Print("  Lot: ", lotSize, " | Entry: ", ask, " | SL: ", sl, " | TP: ", tp);
   }
   else
   {
      Print("✗ Error opening buy order: ", GetLastError());
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
      Print("✓ Sell order opened successfully");
      Print("  Lot: ", lotSize, " | Entry: ", bid, " | SL: ", sl, " | TP: ", tp);
   }
   else
   {
      Print("✗ Error opening sell order: ", GetLastError());
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
//| Update Trailing Stops                                           |
//+------------------------------------------------------------------+
void UpdateTrailingStops()
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double trailingStop = TrailingStopPips * 10 * point;
   double trailingStep = TrailingStepPips * 10 * point;
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      
      double positionOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double currentSL = PositionGetDouble(POSITION_SL);
      long positionType = PositionGetInteger(POSITION_TYPE);
      
      if(positionType == POSITION_TYPE_BUY)
      {
         double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double newSL = bid - trailingStop;
         
         // Only move SL if it's better and passes the step requirement
         if(newSL > currentSL + trailingStep && newSL > positionOpenPrice)
         {
            trade.PositionModify(ticket, NormalizeDouble(newSL, digits), PositionGetDouble(POSITION_TP));
            Print("Trailing stop updated for BUY position #", ticket, ": New SL = ", newSL);
         }
      }
      else if(positionType == POSITION_TYPE_SELL)
      {
         double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         double newSL = ask + trailingStop;
         
         // Only move SL if it's better and passes the step requirement
         if((currentSL == 0 || newSL < currentSL - trailingStep) && newSL < positionOpenPrice)
         {
            trade.PositionModify(ticket, NormalizeDouble(newSL, digits), PositionGetDouble(POSITION_TP));
            Print("Trailing stop updated for SELL position #", ticket, ": New SL = ", newSL);
         }
      }
   }
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
      // Only print occasionally to avoid log spam
      static datetime lastSpreadWarning = 0;
      if(TimeCurrent() - lastSpreadWarning > 300) // Every 5 minutes
      {
         Print("Spread too high: ", spreadPips, " pips (max: ", MaxSpreadPips, ")");
         lastSpreadWarning = TimeCurrent();
      }
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
//| Print current MA values for debugging                           |
//+------------------------------------------------------------------+
void PrintMAValues()
{
   Print("MA Values: MA19=", ma19[1], " | MA38=", ma38[1], 
         " | MA58=", ma58[1], " | MA209=", ma209[1]);
}
//+------------------------------------------------------------------+
