//+------------------------------------------------------------------+
//|                                           StochasticSellEA.mq5 |
//|                                         MetaTrader 5 Expert Advisor |
//|                    Automated Sell Trading with Stochastic Crossover |
//+------------------------------------------------------------------+
#property copyright "StochasticSellEA"
#property version   "1.00"
#property description "Opens sell positions on Stochastic crossover with MA confirmation"

//--- Include necessary libraries
#include <Trade\Trade.mqh>

//--- Input Parameters
input group "=== Stochastic Parameters ==="
input int      Stoch_K_Period = 14;       // Stochastic %K Period
input int      Stoch_D_Period = 19;       // Stochastic %D Period
input int      Stoch_Slowing = 9;         // Stochastic Slowing
input double   Stoch_Level = 60.0;        // Stochastic Crossover Level

input group "=== Moving Average Parameters ==="
input int      MA_Fast_Period = 19;       // Fast MA Period
input int      MA_Slow_Period = 33;       // Slow MA Period
input int      MA_Shift = -9;             // MA Shift

input group "=== Risk Management ==="
input double   RiskPercent = 1.0;         // Risk Per Trade (% of balance)
input double   StopLossPips = 50.0;       // Stop Loss in Pips
input double   TakeProfitPips = 100.0;    // Take Profit in Pips
input double   MaxSpreadPips = 3.0;       // Maximum Spread (pips)

input group "=== Position Management ==="
input int      MagicNumber = 789456;      // Magic Number
input string   TradeComment = "StochSell"; // Trade Comment
input double   MaxLotSize = 10.0;         // Maximum Lot Size
input double   MinLotSize = 0.01;         // Minimum Lot Size
input int      MaxPositions = 1;          // Maximum Open Positions

//--- Global Variables
CTrade trade;
int handleStochastic;
int handleMAFast;
int handleMASlow;
double stochMain[];
double stochSignal[];
double maFast[];
double maSlow[];
datetime lastBarTime = 0;
bool previousMainAboveSignal = false;

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
   // Stochastic with %K=14, %D=19, Slowing=9
   handleStochastic = iStochastic(_Symbol, PERIOD_CURRENT, Stoch_K_Period, Stoch_D_Period, Stoch_Slowing, MODE_SMA, STO_LOWHIGH);
   
   // Moving Averages with shift -9
   handleMAFast = iMA(_Symbol, PERIOD_CURRENT, MA_Fast_Period, MA_Shift, MODE_SMA, PRICE_CLOSE);
   handleMASlow = iMA(_Symbol, PERIOD_CURRENT, MA_Slow_Period, MA_Shift, MODE_SMA, PRICE_CLOSE);
   
   //--- Check if indicators are created successfully
   if(handleStochastic == INVALID_HANDLE || handleMAFast == INVALID_HANDLE || handleMASlow == INVALID_HANDLE)
   {
      Print("Error creating indicators");
      return(INIT_FAILED);
   }
   
   //--- Set arrays as series
   ArraySetAsSeries(stochMain, true);
   ArraySetAsSeries(stochSignal, true);
   ArraySetAsSeries(maFast, true);
   ArraySetAsSeries(maSlow, true);
   
   Print("StochasticSellEA initialized successfully");
   Print("Stochastic Parameters: %K=", Stoch_K_Period, " %D=", Stoch_D_Period, " Slowing=", Stoch_Slowing);
   Print("MA Parameters: Fast MA=", MA_Fast_Period, " Slow MA=", MA_Slow_Period, " Shift=", MA_Shift);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(handleStochastic != INVALID_HANDLE) IndicatorRelease(handleStochastic);
   if(handleMAFast != INVALID_HANDLE) IndicatorRelease(handleMAFast);
   if(handleMASlow != INVALID_HANDLE) IndicatorRelease(handleMASlow);
   
   Print("StochasticSellEA deinitialized");
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
   
   //--- Check spread
   if(!IsSpreadAcceptable())
      return;
   
   //--- Copy indicator data
   if(CopyBuffer(handleStochastic, 0, 0, 3, stochMain) < 3) return;       // Main line (K)
   if(CopyBuffer(handleStochastic, 1, 0, 3, stochSignal) < 3) return;     // Signal line (D)
   if(CopyBuffer(handleMAFast, 0, 0, 2, maFast) < 2) return;
   if(CopyBuffer(handleMASlow, 0, 0, 2, maSlow) < 2) return;
   
   //--- Check if we can open new positions
   if(CountOpenPositions() >= MaxPositions)
      return;
   
   //--- Get trading signal
   bool sellSignal = CheckSellSignal();
   
   //--- Execute trade based on signal
   if(sellSignal)
      OpenSellOrder();
}

//+------------------------------------------------------------------+
//| Check for sell signal                                            |
//+------------------------------------------------------------------+
bool CheckSellSignal()
{
   //--- Condition 1: Stochastic crossover above 60 level
   //    Check if stochastic crossed over level 60 (was below, now above or at 60)
   bool stochCrossedOver60 = (stochMain[1] < Stoch_Level || stochMain[2] < Stoch_Level) && stochMain[0] >= Stoch_Level;
   
   //--- Condition 2: Main line crosses below Signal line
   //    Previous bar: Main > Signal
   //    Current bar: Main < Signal
   bool currentMainBelowSignal = stochMain[0] < stochSignal[0];
   bool previousMainAboveSignalLocal = stochMain[1] > stochSignal[1];
   bool mainCrossedBelowSignal = previousMainAboveSignalLocal && currentMainBelowSignal;
   
   //--- Condition 3: MA(33) with shift -9 < MA(19) with shift -9
   bool maCondition = maSlow[0] < maFast[0];
   
   //--- All conditions must be true for sell signal
   if(stochCrossedOver60 && mainCrossedBelowSignal && maCondition)
   {
      Print("SELL SIGNAL DETECTED:");
      Print("  - Stochastic crossed over ", Stoch_Level, " level");
      Print("  - Stochastic Main crossed below Signal (Main: ", stochMain[0], " Signal: ", stochSignal[0], ")");
      Print("  - MA(", MA_Slow_Period, ") = ", maSlow[0], " < MA(", MA_Fast_Period, ") = ", maFast[0]);
      return true;
   }
   
   return false;
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
      Print("Sell order opened successfully.");
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
   
   if(orderType == ORDER_TYPE_SELL)
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
   
   if(orderType == ORDER_TYPE_SELL)
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
