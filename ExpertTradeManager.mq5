//+------------------------------------------------------------------+
//|                                          ExpertTradeManager.mq5 |
//|                    Expert Advisor with Trade & Profit Management |
//|           Automatically moves SL to break-even and trails profit |
//+------------------------------------------------------------------+
#property copyright "ExpertTradeManager"
#property version   "1.00"
#property description "Manages trades with automatic break-even and trailing stop"
#property strict

#include <Trade/Trade.mqh>

//--- Input Parameters
input group "=== Trading Strategy ==="
input int      FastMA_Period = 12;          // Fast Moving Average Period
input int      SlowMA_Period = 26;          // Slow Moving Average Period
input int      RSI_Period = 14;             // RSI Period
input int      RSI_Oversold = 30;           // RSI Oversold Level
input int      RSI_Overbought = 70;         // RSI Overbought Level

input group "=== Risk Management ==="
input double   RiskPercent = 1.0;           // Risk Per Trade (% of balance)
input double   DefaultLotSize = 0.1;        // Default Lot Size (if risk calc fails)
input int      StopLossPips = 30;           // Initial Stop Loss (pips)
input int      TakeProfitPips = 60;         // Initial Take Profit (pips)
input int      MaxOpenPositions = 3;        // Maximum Open Positions
input double   MaxSpreadPips = 3.0;         // Maximum Spread (pips)

input group "=== Break-Even Settings ==="
input bool     UseBreakEven = true;         // Enable Break-Even Feature
input int      BreakEvenPips = 15;          // Profit to trigger break-even (pips)
input int      BreakEvenOffset = 2;         // Lock-in profit at break-even (pips)

input group "=== Trailing Stop Settings ==="
input bool     UseTrailingStop = true;      // Enable Trailing Stop
input int      TrailingStartPips = 20;      // Start trailing after profit (pips)
input int      TrailingStopPips = 10;       // Trailing distance (pips)
input int      TrailingStep = 5;            // Minimum step to move SL (pips)

input group "=== Trading Hours ==="
input bool     UseTimeFilter = true;        // Use Time Filter
input int      StartHour = 8;               // Start Trading Hour (server time)
input int      EndHour = 20;                // End Trading Hour (server time)

input group "=== Misc Settings ==="
input int      MagicNumber = 777777;        // Magic Number
input string   TradeComment = "ExpertTM";   // Trade Comment
input bool     ShowLogs = true;             // Show detailed logs

//--- Global Variables
CTrade trade;
int handleFastMA;
int handleSlowMA;
int handleRSI;

double fastMA[];
double slowMA[];
double rsi[];

datetime lastBarTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(10);
   
   //--- Initialize indicators
   handleFastMA = iMA(_Symbol, PERIOD_CURRENT, FastMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleSlowMA = iMA(_Symbol, PERIOD_CURRENT, SlowMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleRSI = iRSI(_Symbol, PERIOD_CURRENT, RSI_Period, PRICE_CLOSE);
   
   if(handleFastMA == INVALID_HANDLE || handleSlowMA == INVALID_HANDLE || handleRSI == INVALID_HANDLE)
   {
      Print("ERROR: Failed to create indicators");
      return(INIT_FAILED);
   }
   
   //--- Set arrays as series
   ArraySetAsSeries(fastMA, true);
   ArraySetAsSeries(slowMA, true);
   ArraySetAsSeries(rsi, true);
   
   Print("=== ExpertTradeManager Initialized ===");
   Print("Break-Even: ", UseBreakEven ? "Enabled" : "Disabled", 
         " (Trigger: ", BreakEvenPips, " pips, Offset: ", BreakEvenOffset, " pips)");
   Print("Trailing Stop: ", UseTrailingStop ? "Enabled" : "Disabled",
         " (Start: ", TrailingStartPips, " pips, Distance: ", TrailingStopPips, " pips)");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicators
   if(handleFastMA != INVALID_HANDLE) IndicatorRelease(handleFastMA);
   if(handleSlowMA != INVALID_HANDLE) IndicatorRelease(handleSlowMA);
   if(handleRSI != INVALID_HANDLE) IndicatorRelease(handleRSI);
   
   Print("=== ExpertTradeManager Deinitialized ===");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check for new bar
   datetime currentBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   bool isNewBar = (currentBarTime != lastBarTime);
   
   if(isNewBar)
   {
      lastBarTime = currentBarTime;
      
      //--- Check for new trade opportunities
      if(CanOpenNewPosition())
      {
         CheckForTradeSignals();
      }
   }
   
   //--- Manage existing positions (every tick)
   ManageOpenPositions();
}

//+------------------------------------------------------------------+
//| Check if can open new position                                   |
//+------------------------------------------------------------------+
bool CanOpenNewPosition()
{
   //--- Check max positions
   if(CountMyPositions() >= MaxOpenPositions)
      return false;
   
   //--- Check spread
   if(!IsSpreadAcceptable())
      return false;
   
   //--- Check trading hours
   if(UseTimeFilter && !IsWithinTradingHours())
      return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| Count positions opened by this EA                                |
//+------------------------------------------------------------------+
int CountMyPositions()
{
   int count = 0;
   int total = PositionsTotal();
   
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
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
//| Check if spread is acceptable                                    |
//+------------------------------------------------------------------+
bool IsSpreadAcceptable()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   if(point == 0) return false;
   
   double spreadPips = (ask - bid) / (10 * point);
   
   if(spreadPips > MaxSpreadPips)
   {
      if(ShowLogs)
         Print("Spread too high: ", DoubleToString(spreadPips, 1), " pips (max: ", MaxSpreadPips, " pips)");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check if within trading hours                                    |
//+------------------------------------------------------------------+
bool IsWithinTradingHours()
{
   MqlDateTime timeStruct;
   TimeToStruct(TimeCurrent(), timeStruct);
   
   return (timeStruct.hour >= StartHour && timeStruct.hour < EndHour);
}

//+------------------------------------------------------------------+
//| Check for trade signals                                          |
//+------------------------------------------------------------------+
void CheckForTradeSignals()
{
   //--- Copy indicator data
   if(CopyBuffer(handleFastMA, 0, 0, 3, fastMA) < 3) return;
   if(CopyBuffer(handleSlowMA, 0, 0, 3, slowMA) < 3) return;
   if(CopyBuffer(handleRSI, 0, 0, 3, rsi) < 3) return;
   
   //--- BUY Signal: Fast MA crosses above Slow MA + RSI not overbought
   if(fastMA[1] > slowMA[1] && fastMA[2] <= slowMA[2])
   {
      if(rsi[1] < RSI_Overbought)
      {
         if(ShowLogs)
            Print("BUY SIGNAL: FastMA crossed above SlowMA, RSI=", DoubleToString(rsi[1], 1));
         
         OpenBuyPosition();
      }
   }
   
   //--- SELL Signal: Fast MA crosses below Slow MA + RSI not oversold
   if(fastMA[1] < slowMA[1] && fastMA[2] >= slowMA[2])
   {
      if(rsi[1] > RSI_Oversold)
      {
         if(ShowLogs)
            Print("SELL SIGNAL: FastMA crossed below SlowMA, RSI=", DoubleToString(rsi[1], 1));
         
         OpenSellPosition();
      }
   }
}

//+------------------------------------------------------------------+
//| Open Buy Position                                                |
//+------------------------------------------------------------------+
void OpenBuyPosition()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   
   if(point == 0) return;
   
   //--- Calculate SL and TP
   double sl = NormalizeDouble(ask - StopLossPips * 10 * point, digits);
   double tp = NormalizeDouble(ask + TakeProfitPips * 10 * point, digits);
   
   //--- Calculate lot size
   double lotSize = CalculateLotSize(StopLossPips * 10 * point);
   
   //--- Open position
   if(trade.Buy(lotSize, _Symbol, ask, sl, tp, TradeComment))
   {
      ulong ticket = trade.ResultOrder();
      if(ShowLogs)
         Print("BUY position opened #", ticket, " | Lot: ", lotSize, " | Price: ", ask, 
               " | SL: ", sl, " | TP: ", tp);
   }
   else
   {
      Print("ERROR: Failed to open BUY position - ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Open Sell Position                                               |
//+------------------------------------------------------------------+
void OpenSellPosition()
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   
   if(point == 0) return;
   
   //--- Calculate SL and TP
   double sl = NormalizeDouble(bid + StopLossPips * 10 * point, digits);
   double tp = NormalizeDouble(bid - TakeProfitPips * 10 * point, digits);
   
   //--- Calculate lot size
   double lotSize = CalculateLotSize(StopLossPips * 10 * point);
   
   //--- Open position
   if(trade.Sell(lotSize, _Symbol, bid, sl, tp, TradeComment))
   {
      ulong ticket = trade.ResultOrder();
      if(ShowLogs)
         Print("SELL position opened #", ticket, " | Lot: ", lotSize, " | Price: ", bid,
               " | SL: ", sl, " | TP: ", tp);
   }
   else
   {
      Print("ERROR: Failed to open SELL position - ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Calculate lot size based on risk                                |
//+------------------------------------------------------------------+
double CalculateLotSize(double stopLossDistance)
{
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = accountBalance * RiskPercent / 100.0;
   
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   if(stopLossDistance == 0 || tickValue == 0 || tickSize == 0 || point == 0)
      return DefaultLotSize;
   
   double stopLossPoints = stopLossDistance / point;
   double denominator = stopLossPoints * tickValue / tickSize;
   
   if(denominator == 0)
      return DefaultLotSize;
   
   double lotSize = riskAmount / denominator;
   
   //--- Normalize lot size
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(lotStep > 0)
      lotSize = MathFloor(lotSize / lotStep) * lotStep;
   
   //--- Apply limits
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   
   if(lotSize < minLot) lotSize = minLot;
   if(lotSize > maxLot) lotSize = maxLot;
   
   return NormalizeDouble(lotSize, 2);
}

//+------------------------------------------------------------------+
//| Manage open positions                                            |
//+------------------------------------------------------------------+
void ManageOpenPositions()
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   
   if(point == 0) return;
   
   int total = PositionsTotal();
   
   for(int i = 0; i < total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      
      //--- Check if position belongs to this EA
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      
      //--- Get position data
      ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double currentSL = PositionGetDouble(POSITION_SL);
      double currentTP = PositionGetDouble(POSITION_TP);
      
      double currentPrice;
      if(posType == POSITION_TYPE_BUY)
         currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      else
         currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      
      //--- Calculate profit in pips
      double profitPips;
      if(posType == POSITION_TYPE_BUY)
         profitPips = (currentPrice - openPrice) / (10 * point);
      else
         profitPips = (openPrice - currentPrice) / (10 * point);
      
      double newSL = currentSL;
      bool needModify = false;
      
      //--- Break-Even Logic
      if(UseBreakEven && profitPips >= BreakEvenPips)
      {
         double breakEvenPrice;
         
         if(posType == POSITION_TYPE_BUY)
         {
            breakEvenPrice = NormalizeDouble(openPrice + BreakEvenOffset * 10 * point, digits);
            
            //--- Only move SL up, never down
            if(currentSL < breakEvenPrice)
            {
               newSL = breakEvenPrice;
               needModify = true;
               
               if(ShowLogs)
                  Print("BREAK-EVEN triggered for #", ticket, " | Profit: ", 
                        DoubleToString(profitPips, 1), " pips | Moving SL to: ", newSL);
            }
         }
         else // SELL
         {
            breakEvenPrice = NormalizeDouble(openPrice - BreakEvenOffset * 10 * point, digits);
            
            //--- Only move SL down, never up
            if(currentSL > breakEvenPrice || currentSL == 0)
            {
               newSL = breakEvenPrice;
               needModify = true;
               
               if(ShowLogs)
                  Print("BREAK-EVEN triggered for #", ticket, " | Profit: ",
                        DoubleToString(profitPips, 1), " pips | Moving SL to: ", newSL);
            }
         }
      }
      
      //--- Trailing Stop Logic
      if(UseTrailingStop && profitPips >= TrailingStartPips)
      {
         double trailingPrice;
         
         if(posType == POSITION_TYPE_BUY)
         {
            trailingPrice = NormalizeDouble(currentPrice - TrailingStopPips * 10 * point, digits);
            
            //--- Check if we should move SL (must be better than current)
            if(currentSL == 0 || trailingPrice > currentSL)
            {
               //--- Check step requirement
               if(currentSL == 0 || (trailingPrice - currentSL) >= TrailingStep * 10 * point)
               {
                  newSL = trailingPrice;
                  needModify = true;
                  
                  if(ShowLogs)
                     Print("TRAILING STOP for #", ticket, " | Profit: ",
                           DoubleToString(profitPips, 1), " pips | Moving SL from ", 
                           currentSL, " to ", newSL);
               }
            }
         }
         else // SELL
         {
            trailingPrice = NormalizeDouble(currentPrice + TrailingStopPips * 10 * point, digits);
            
            //--- Check if we should move SL (must be better than current)
            if(currentSL == 0 || trailingPrice < currentSL)
            {
               //--- Check step requirement
               if(currentSL == 0 || (currentSL - trailingPrice) >= TrailingStep * 10 * point)
               {
                  newSL = trailingPrice;
                  needModify = true;
                  
                  if(ShowLogs)
                     Print("TRAILING STOP for #", ticket, " | Profit: ",
                           DoubleToString(profitPips, 1), " pips | Moving SL from ",
                           currentSL, " to ", newSL);
               }
            }
         }
      }
      
      //--- Modify position if needed
      if(needModify)
      {
         //--- Validate SL is within broker limits
         int stopLevel = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
         double minDistance = stopLevel * point;
         
         if(posType == POSITION_TYPE_BUY)
         {
            if(currentPrice - newSL < minDistance)
            {
               newSL = NormalizeDouble(currentPrice - minDistance, digits);
               if(ShowLogs)
                  Print("Adjusted SL to meet broker stop level: ", newSL);
            }
         }
         else
         {
            if(newSL - currentPrice < minDistance)
            {
               newSL = NormalizeDouble(currentPrice + minDistance, digits);
               if(ShowLogs)
                  Print("Adjusted SL to meet broker stop level: ", newSL);
            }
         }
         
         //--- Execute modification
         if(trade.PositionModify(ticket, newSL, currentTP))
         {
            if(ShowLogs)
               Print("Position #", ticket, " modified successfully | New SL: ", newSL);
         }
         else
         {
            Print("ERROR: Failed to modify position #", ticket, " - ", GetLastError());
         }
      }
   }
}
//+------------------------------------------------------------------+
