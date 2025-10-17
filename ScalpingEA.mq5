//+------------------------------------------------------------------+
//|                                                   ScalpingEA.mq5 |
//|                                         MetaTrader 5 Expert Advisor |
//|                                    Automated Scalping with Risk Management |
//+------------------------------------------------------------------+
#property copyright "ScalpingEA"
#property version   "1.00"
#property description "Automated scalping EA with risk minimization"

//--- Include necessary libraries
#include <Trade\Trade.mqh>

//--- Input Parameters
input group "=== Trading Parameters ==="
input int      FastMA_Period = 5;           // Fast Moving Average Period
input int      SlowMA_Period = 20;          // Slow Moving Average Period
input int      RSI_Period = 14;             // RSI Period
input int      RSI_Oversold = 30;           // RSI Oversold Level
input int      RSI_Overbought = 70;         // RSI Overbought Level

input group "=== Risk Management ==="
input double   RiskPercent = 1.0;           // Risk Per Trade (% of balance)
input double   StopLossPips = 15.0;         // Stop Loss in Pips
input double   TakeProfitPips = 25.0;       // Take Profit in Pips
input double   MaxSpreadPips = 2.0;         // Maximum Spread (pips)
input bool     UseTrailingStop = true;      // Use Trailing Stop
input double   TrailingStopPips = 10.0;     // Trailing Stop Distance (pips)
input double   TrailingStepPips = 5.0;      // Trailing Stop Step (pips)

input group "=== Position Management ==="
input int      MagicNumber = 123456;        // Magic Number
input string   TradeComment = "ScalpEA";    // Trade Comment
input double   MaxLotSize = 10.0;           // Maximum Lot Size
input double   MinLotSize = 0.01;           // Minimum Lot Size

input group "=== Trading Hours ==="
input bool     UseTimeFilter = true;        // Use Time Filter
input int      StartHour = 8;               // Start Trading Hour
input int      EndHour = 20;                // End Trading Hour

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
   //--- Set trade parameters
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(10);
   trade.SetTypeFilling(ORDER_FILLING_FOK);
   
   //--- Initialize indicators
   handleFastMA = iMA(_Symbol, PERIOD_CURRENT, FastMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleSlowMA = iMA(_Symbol, PERIOD_CURRENT, SlowMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleRSI = iRSI(_Symbol, PERIOD_CURRENT, RSI_Period, PRICE_CLOSE);
   
   //--- Check if indicators are created successfully
   if(handleFastMA == INVALID_HANDLE || handleSlowMA == INVALID_HANDLE || handleRSI == INVALID_HANDLE)
   {
      Print("Error creating indicators");
      return(INIT_FAILED);
   }
   
   //--- Set array as series
   ArraySetAsSeries(fastMA, true);
   ArraySetAsSeries(slowMA, true);
   ArraySetAsSeries(rsi, true);
   
   Print("ScalpingEA initialized successfully");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(handleFastMA != INVALID_HANDLE) IndicatorRelease(handleFastMA);
   if(handleSlowMA != INVALID_HANDLE) IndicatorRelease(handleSlowMA);
   if(handleRSI != INVALID_HANDLE) IndicatorRelease(handleRSI);
   
   Print("ScalpingEA deinitialized");
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
   if(CopyBuffer(handleFastMA, 0, 0, 3, fastMA) < 3) return;
   if(CopyBuffer(handleSlowMA, 0, 0, 3, slowMA) < 3) return;
   if(CopyBuffer(handleRSI, 0, 0, 3, rsi) < 3) return;
   
   //--- Update trailing stops for open positions
   if(UseTrailingStop)
      UpdateTrailingStops();
   
   //--- Check if we can open new positions
   if(PositionsTotal() > 0)
      return; // Only one position at a time for risk management
   
   //--- Get trading signals
   int signal = GetTradingSignal();
   
   //--- Execute trades based on signals
   if(signal == 1)
      OpenBuyOrder();
   else if(signal == -1)
      OpenSellOrder();
}

//+------------------------------------------------------------------+
//| Get trading signal                                               |
//+------------------------------------------------------------------+
int GetTradingSignal()
{
   //--- Buy signal: Fast MA crosses above Slow MA and RSI is oversold
   if(fastMA[1] > slowMA[1] && fastMA[2] <= slowMA[2] && rsi[1] < RSI_Oversold + 10)
      return 1;
   
   //--- Sell signal: Fast MA crosses below Slow MA and RSI is overbought
   if(fastMA[1] < slowMA[1] && fastMA[2] >= slowMA[2] && rsi[1] > RSI_Overbought - 10)
      return -1;
   
   return 0;
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
      Print("Buy order opened successfully. Lot: ", lotSize, " SL: ", sl, " TP: ", tp);
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
      Print("Sell order opened successfully. Lot: ", lotSize, " SL: ", sl, " TP: ", tp);
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
         
         if(newSL > currentSL + trailingStep && newSL > positionOpenPrice)
         {
            trade.PositionModify(ticket, NormalizeDouble(newSL, digits), PositionGetDouble(POSITION_TP));
            Print("Trailing stop updated for Buy position. New SL: ", newSL);
         }
      }
      else if(positionType == POSITION_TYPE_SELL)
      {
         double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         double newSL = ask + trailingStop;
         
         if((currentSL == 0 || newSL < currentSL - trailingStep) && newSL < positionOpenPrice)
         {
            trade.PositionModify(ticket, NormalizeDouble(newSL, digits), PositionGetDouble(POSITION_TP));
            Print("Trailing stop updated for Sell position. New SL: ", newSL);
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
