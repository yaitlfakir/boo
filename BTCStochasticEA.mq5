//+------------------------------------------------------------------+
//|                                             BTCStochasticEA.mq5 |
//|                                         MetaTrader 5 Expert Advisor |
//|            Automated Bitcoin Trading with Stochastic Oscillator (19,7,3) |
//+------------------------------------------------------------------+
#property copyright "BTCStochasticEA"
#property version   "1.00"
#property description "Automatic BTC trading: BUY when K crosses above D, SELL when K crosses below D"

//--- Include necessary libraries
#include <Trade\Trade.mqh>

//--- Input Parameters
input group "=== Stochastic Parameters ==="
input int      Stoch_K_Period = 19;        // Stochastic %K Period
input int      Stoch_D_Period = 7;         // Stochastic %D Period
input int      Stoch_Slowing = 3;          // Stochastic Slowing

input group "=== Risk Management ==="
input double   RiskPercent = 1.0;          // Risk Per Trade (% of balance)
input double   StopLossPips = 500.0;       // Base Stop Loss in Pips (for BTC)
input double   TakeProfitPips = 1000.0;    // Base Take Profit in Pips (for BTC)
input bool     UseDynamicSLTP = true;      // Use ATR-based dynamic SL/TP
input int      ATR_Period = 14;            // ATR Period for volatility
input double   ATR_Multiplier = 2.0;       // ATR Multiplier for dynamic SL/TP
input double   MaxSpreadPips = 50.0;       // Maximum Spread (pips)

input group "=== Trailing Stop Management ==="
input bool     UseTrailingStop = true;     // Use Trailing Stop
input double   TrailingStopPips = 300.0;   // Trailing Stop Distance (pips)
input double   TrailingStepPips = 100.0;   // Trailing Stop Step (pips)
input bool     UseBreakEven = true;        // Move SL to Break-Even
input double   BreakEvenPips = 200.0;      // Profit in pips to trigger Break-Even
input double   BreakEvenPlusPips = 10.0;   // Additional pips beyond entry for BE

input group "=== Trailing Profit Management ==="
input bool     UseTrailingProfit = true;   // Use Trailing Take Profit
input double   TrailingProfitPips = 400.0; // Trailing Profit Distance (pips)
input double   TrailingProfitStepPips = 150.0; // Trailing Profit Step (pips)

input group "=== Smart Risk Management ==="
input bool     UseDailyLossLimit = true;   // Enable Daily Loss Limit
input double   MaxDailyLossPercent = 5.0;  // Maximum Daily Loss (% of balance)
input bool     UseMaxDrawdown = true;      // Enable Maximum Drawdown Protection
input double   MaxDrawdownPercent = 15.0;  // Maximum Drawdown (% from peak balance)
input bool     UseConsecutiveLossLimit = true; // Limit Consecutive Losses
input int      MaxConsecutiveLosses = 3;   // Stop after X consecutive losses

input group "=== Position Management ==="
input int      MagicNumber = 191973;       // Magic Number (unique for this EA)
input string   TradeComment = "BTC-Stoch"; // Trade Comment
input double   MaxLotSize = 10.0;          // Maximum Lot Size
input double   MinLotSize = 0.01;          // Minimum Lot Size
input int      MaxOpenPositions = 1;       // Maximum Open Positions

input group "=== Trading Hours ==="
input bool     UseTimeFilter = false;      // Use Time Filter (24/7 by default)
input int      StartHour = 0;              // Start Trading Hour (0-23)
input int      EndHour = 23;               // End Trading Hour (0-23)

//--- Global Variables
CTrade trade;
int handleStochastic;
int handleATR;
double stochMain[];     // %K line
double stochSignal[];   // %D line
double atr[];
datetime lastBarTime = 0;
double pipValue = 0.0;  // Will be set in OnInit based on symbol digits

// Smart Risk Management Variables
double dailyStartBalance = 0.0;
double peakBalance = 0.0;
datetime lastDayCheck = 0;
int consecutiveLosses = 0;
double lastClosedProfit = 0.0;
bool tradingHalted = false;

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
   //--- Set trade parameters
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(10);
   trade.SetTypeFilling(ORDER_FILLING_FOK);
   
   //--- Calculate pip value based on symbol digits
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   if(digits == 3 || digits == 5)
      pipValue = _Point * 10;  // 5-digit or 3-digit broker
   else
      pipValue = _Point;        // 4-digit or 2-digit broker
   
   Print("Symbol: ", _Symbol, ", Digits: ", digits, ", Pip value: ", pipValue);
   
   //--- Initialize indicators
   // Stochastic with %K=19, %D=7, Slowing=3
   handleStochastic = iStochastic(_Symbol, PERIOD_CURRENT, Stoch_K_Period, Stoch_D_Period, Stoch_Slowing, MODE_SMA, STO_LOWHIGH);
   
   // ATR for dynamic stops
   handleATR = iATR(_Symbol, PERIOD_CURRENT, ATR_Period);
   
   //--- Check if indicators are created successfully
   if(handleStochastic == INVALID_HANDLE || handleATR == INVALID_HANDLE)
   {
      Print("Error creating indicators");
      return(INIT_FAILED);
   }
   
   //--- Set arrays as series
   ArraySetAsSeries(stochMain, true);
   ArraySetAsSeries(stochSignal, true);
   ArraySetAsSeries(atr, true);
   
   //--- Initialize risk management variables
   dailyStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   peakBalance = dailyStartBalance;
   lastDayCheck = TimeCurrent();
   consecutiveLosses = 0;
   tradingHalted = false;
   
   Print("BTCStochasticEA initialized successfully");
   Print("Stochastic Parameters: K=", Stoch_K_Period, ", D=", Stoch_D_Period, ", Slowing=", Stoch_Slowing);
   Print("Strategy: BUY when K crosses above D, SELL when K crosses below D");
   Print("Risk per trade: ", RiskPercent, "%");
   Print("Smart Risk Management:");
   Print("  - Daily Loss Limit: ", UseDailyLossLimit ? "Enabled" : "Disabled", " (", MaxDailyLossPercent, "%)");
   Print("  - Max Drawdown: ", UseMaxDrawdown ? "Enabled" : "Disabled", " (", MaxDrawdownPercent, "%)");
   Print("  - Break-Even: ", UseBreakEven ? "Enabled" : "Disabled", " at ", BreakEvenPips, " pips");
   Print("  - Trailing Profit: ", UseTrailingProfit ? "Enabled" : "Disabled");
   Print("  - Consecutive Loss Limit: ", UseConsecutiveLossLimit ? "Enabled" : "Disabled", " (", MaxConsecutiveLosses, ")");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(handleStochastic != INVALID_HANDLE) IndicatorRelease(handleStochastic);
   if(handleATR != INVALID_HANDLE) IndicatorRelease(handleATR);
   
   Print("BTCStochasticEA deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check smart risk management first
   CheckSmartRiskManagement();
   
   //--- Manage open positions (trailing stop, trailing profit, break-even)
   ManagePositions();
   
   //--- Check if new bar formed
   datetime currentBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(currentBarTime == lastBarTime)
      return;
   lastBarTime = currentBarTime;
   
   //--- Check if trading is halted due to risk limits
   if(tradingHalted)
   {
      Print("Trading halted due to risk management limits");
      return;
   }
   
   //--- Check spread
   if(!IsSpreadAcceptable())
      return;
   
   //--- Check time filter
   if(!CheckTimeFilter())
      return;
   
   //--- Copy indicator data
   if(CopyBuffer(handleStochastic, 0, 0, 3, stochMain) < 3) return;       // Main line (K)
   if(CopyBuffer(handleStochastic, 1, 0, 3, stochSignal) < 3) return;     // Signal line (D)
   if(CopyBuffer(handleATR, 0, 0, 2, atr) < 2) return;
   
   //--- Check if we can open new positions
   if(CountOpenPositions() >= MaxOpenPositions)
      return;
   
   //--- Get trading signals
   CheckForBuySignal();
   CheckForSellSignal();
}

//+------------------------------------------------------------------+
//| Check for buy signal: K crosses above D                           |
//+------------------------------------------------------------------+
void CheckForBuySignal()
{
   //--- BUY when K crosses above D
   //    Previous bar: K <= D
   //    Current bar: K > D
   bool kCrossedAboveD = (stochMain[1] <= stochSignal[1]) && (stochMain[0] > stochSignal[0]);
   
   if(kCrossedAboveD)
   {
      Print("BUY SIGNAL DETECTED:");
      Print("  - Stochastic K (", stochMain[0], ") crossed above D (", stochSignal[0], ")");
      
      OpenBuyOrder();
   }
}

//+------------------------------------------------------------------+
//| Check for sell signal: K crosses below D                          |
//+------------------------------------------------------------------+
void CheckForSellSignal()
{
   //--- SELL when K crosses below D
   //    Previous bar: K >= D
   //    Current bar: K < D
   bool kCrossedBelowD = (stochMain[1] >= stochSignal[1]) && (stochMain[0] < stochSignal[0]);
   
   if(kCrossedBelowD)
   {
      Print("SELL SIGNAL DETECTED:");
      Print("  - Stochastic K (", stochMain[0], ") crossed below D (", stochSignal[0], ")");
      
      OpenSellOrder();
   }
}

//+------------------------------------------------------------------+
//| Open Buy Order                                                    |
//+------------------------------------------------------------------+
void OpenBuyOrder()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double sl, tp;
   CalculateSLTP(true, ask, sl, tp);
   
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
//| Open Sell Order                                                   |
//+------------------------------------------------------------------+
void OpenSellOrder()
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl, tp;
   CalculateSLTP(false, bid, sl, tp);
   
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
      
      Print("Dynamic SL/TP: ATR=", PointsToPips(currentATR), " pips, SL Distance=", PointsToPips(slDistance), " pips");
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
double CalculateLotSize(double stopLoss, double entryPrice)
{
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = accountBalance * (RiskPercent / 100.0);
   
   double slDistance = MathAbs(entryPrice - stopLoss);
   
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
//| Count open positions for this EA                                  |
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
//| Check if spread is acceptable                                     |
//+------------------------------------------------------------------+
bool IsSpreadAcceptable()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double spread = ask - bid;
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
//| Manage open positions (break-even, trailing stop, trailing profit) |
//+------------------------------------------------------------------+
void ManagePositions()
{
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
         
         double profitPips = 0.0;
         bool needsModify = false;
         double newSL = currentSL;
         double newTP = currentTP;
         
         // Calculate current profit in pips
         if(positionType == POSITION_TYPE_BUY)
            profitPips = PointsToPips(currentPrice - positionOpenPrice);
         else
            profitPips = PointsToPips(positionOpenPrice - currentPrice);
         
         //--- 1. Break-Even Management
         if(UseBreakEven && profitPips >= BreakEvenPips)
         {
            double breakEvenPrice = 0.0;
            if(positionType == POSITION_TYPE_BUY)
            {
               breakEvenPrice = positionOpenPrice + PipsToPoints(BreakEvenPlusPips);
               if(currentSL < breakEvenPrice)
               {
                  newSL = NormalizeDouble(breakEvenPrice, _Digits);
                  needsModify = true;
                  Print("Break-Even triggered for position #", ticket, " at ", profitPips, " pips profit");
               }
            }
            else // SELL
            {
               breakEvenPrice = positionOpenPrice - PipsToPoints(BreakEvenPlusPips);
               if(currentSL > breakEvenPrice || currentSL == 0)
               {
                  newSL = NormalizeDouble(breakEvenPrice, _Digits);
                  needsModify = true;
                  Print("Break-Even triggered for position #", ticket, " at ", profitPips, " pips profit");
               }
            }
         }
         
         //--- 2. Trailing Stop Management
         if(UseTrailingStop && profitPips > 0)
         {
            double trailDistance = PipsToPoints(TrailingStopPips);
            double trailStep = PipsToPoints(TrailingStepPips);
            
            if(positionType == POSITION_TYPE_BUY)
            {
               double trailingSL = currentPrice - trailDistance;
               
               if(currentPrice > positionOpenPrice + trailDistance)
               {
                  if(trailingSL > currentSL + trailStep || currentSL == 0)
                  {
                     newSL = NormalizeDouble(trailingSL, _Digits);
                     needsModify = true;
                  }
               }
            }
            else // SELL
            {
               double trailingSL = currentPrice + trailDistance;
               
               if(currentPrice < positionOpenPrice - trailDistance)
               {
                  if(trailingSL < currentSL - trailStep || currentSL == 0)
                  {
                     newSL = NormalizeDouble(trailingSL, _Digits);
                     needsModify = true;
                  }
               }
            }
         }
         
         //--- 3. Trailing Profit Management
         if(UseTrailingProfit && currentTP != 0 && profitPips > 0)
         {
            double trailProfitDistance = PipsToPoints(TrailingProfitPips);
            double trailProfitStep = PipsToPoints(TrailingProfitStepPips);
            
            if(positionType == POSITION_TYPE_BUY)
            {
               double trailingTP = currentPrice + trailProfitDistance;
               double tpDiff = currentTP - currentPrice;
               
               // Move TP closer if price is approaching it
               if(tpDiff < trailProfitDistance + trailProfitStep)
               {
                  if(trailingTP < currentTP - trailProfitStep)
                  {
                     newTP = NormalizeDouble(trailingTP, _Digits);
                     needsModify = true;
                  }
               }
            }
            else // SELL
            {
               double trailingTP = currentPrice - trailProfitDistance;
               double tpDiff = currentPrice - currentTP;
               
               // Move TP closer if price is approaching it
               if(tpDiff < trailProfitDistance + trailProfitStep)
               {
                  if(trailingTP > currentTP + trailProfitStep)
                  {
                     newTP = NormalizeDouble(trailingTP, _Digits);
                     needsModify = true;
                  }
               }
            }
         }
         
         //--- Apply modifications if needed
         if(needsModify)
         {
            if(trade.PositionModify(ticket, newSL, newTP))
            {
               Print("Position #", ticket, " modified - SL: ", newSL, " TP: ", newTP, " (Profit: ", profitPips, " pips)");
            }
            else
            {
               Print("Failed to modify position #", ticket, " Error: ", GetLastError());
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Check Smart Risk Management                                       |
//+------------------------------------------------------------------+
void CheckSmartRiskManagement()
{
   double currentBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   
   //--- Check if new day - reset daily tracking
   MqlDateTime dt;
   datetime currentTime = TimeCurrent();
   if(!TimeToStruct(currentTime, dt)) return;
   
   MqlDateTime lastDt;
   if(!TimeToStruct(lastDayCheck, lastDt)) return;
   
   if(dt.day != lastDt.day || dt.mon != lastDt.mon || dt.year != lastDt.year)
   {
      dailyStartBalance = currentBalance;
      lastDayCheck = currentTime;
      tradingHalted = false; // Reset halt at start of new day
      Print("New trading day started. Daily start balance: ", dailyStartBalance);
   }
   
   //--- Update peak balance
   if(currentBalance > peakBalance)
      peakBalance = currentBalance;
   
   //--- Check Daily Loss Limit
   if(UseDailyLossLimit)
   {
      double dailyLoss = dailyStartBalance - currentBalance;
      double dailyLossPercent = (dailyLoss / dailyStartBalance) * 100.0;
      
      if(dailyLossPercent >= MaxDailyLossPercent)
      {
         if(!tradingHalted)
         {
            Print("DAILY LOSS LIMIT REACHED! Loss: ", dailyLossPercent, "% - Trading halted until next day");
            tradingHalted = true;
            CloseAllPositions("Daily loss limit reached");
         }
         return;
      }
   }
   
   //--- Check Maximum Drawdown
   if(UseMaxDrawdown)
   {
      double drawdown = peakBalance - currentEquity;
      double drawdownPercent = (drawdown / peakBalance) * 100.0;
      
      if(drawdownPercent >= MaxDrawdownPercent)
      {
         if(!tradingHalted)
         {
            Print("MAXIMUM DRAWDOWN REACHED! Drawdown: ", drawdownPercent, "% - Trading halted");
            tradingHalted = true;
            CloseAllPositions("Maximum drawdown reached");
         }
         return;
      }
   }
   
   //--- Check for closed positions and update consecutive losses
   if(UseConsecutiveLossLimit)
   {
      CheckConsecutiveLosses();
   }
}

//+------------------------------------------------------------------+
//| Check Consecutive Losses                                          |
//+------------------------------------------------------------------+
void CheckConsecutiveLosses()
{
   // Check history for recently closed positions
   HistorySelect(0, TimeCurrent());
   int totalDeals = HistoryDealsTotal();
   
   if(totalDeals == 0) return;
   
   // Get the most recent deal
   ulong lastDealTicket = HistoryDealGetTicket(totalDeals - 1);
   if(lastDealTicket == 0) return;
   
   // Check if it's our position
   if(HistoryDealGetInteger(lastDealTicket, DEAL_MAGIC) != MagicNumber) return;
   if(HistoryDealGetString(lastDealTicket, DEAL_SYMBOL) != _Symbol) return;
   
   // Check if it's an exit deal
   ENUM_DEAL_ENTRY dealEntry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(lastDealTicket, DEAL_ENTRY);
   if(dealEntry != DEAL_ENTRY_OUT) return;
   
   double dealProfit = HistoryDealGetDouble(lastDealTicket, DEAL_PROFIT);
   
   // Only process if this is a new closed deal
   if(dealProfit == lastClosedProfit) return;
   lastClosedProfit = dealProfit;
   
   // Update consecutive loss counter
   if(dealProfit < 0)
   {
      consecutiveLosses++;
      Print("Consecutive losses: ", consecutiveLosses);
      
      if(consecutiveLosses >= MaxConsecutiveLosses)
      {
         Print("CONSECUTIVE LOSS LIMIT REACHED! (", consecutiveLosses, " losses) - Trading halted");
         tradingHalted = true;
         CloseAllPositions("Consecutive loss limit reached");
      }
   }
   else if(dealProfit > 0)
   {
      // Reset counter on winning trade
      if(consecutiveLosses > 0)
      {
         Print("Winning trade! Consecutive loss counter reset from ", consecutiveLosses, " to 0");
      }
      consecutiveLosses = 0;
   }
}

//+------------------------------------------------------------------+
//| Close All Positions                                               |
//+------------------------------------------------------------------+
void CloseAllPositions(string reason)
{
   Print("Closing all positions: ", reason);
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && 
            PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            ulong ticket = PositionGetInteger(POSITION_TICKET);
            trade.PositionClose(ticket);
         }
      }
   }
}
//+------------------------------------------------------------------+
