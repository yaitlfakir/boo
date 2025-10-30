//+------------------------------------------------------------------+
//|                                               TradingManager.mq5 |
//|                                   EA Trading Manager with Dashboard |
//|                 One-click trading controls with advanced features |
//+------------------------------------------------------------------+
#property copyright "TradingManager"
#property version   "1.00"
#property description "Complete trading dashboard with indicators, alerts, and one-click controls"
#property strict

#include <Trade/Trade.mqh>

//--- Input Parameters
input group "=== Dashboard Settings ==="
input int      DashboardX = 20;              // Dashboard X Position
input int      DashboardY = 50;              // Dashboard Y Position
input color    PanelColor = clrNavy;         // Panel Background Color
input color    TextColor = clrWhite;         // Text Color
input color    ButtonColor = clrDarkSlateGray; // Button Color

input group "=== Stochastic Alert Settings ==="
input int      Stoch_K_Period = 14;          // Stochastic %K Period
input int      Stoch_D_Period = 3;           // Stochastic %D Period
input int      Stoch_Slowing = 3;            // Stochastic Slowing
input double   Stoch_Overbought = 80.0;      // Overbought Level (Alert)
input double   Stoch_Oversold = 20.0;        // Oversold Level (Alert)
input bool     EnableStochAlerts = true;     // Enable Stochastic Alerts

input group "=== Indicator Settings ==="
input int      Fast_EMA_Period = 12;         // Fast EMA Period
input int      Slow_EMA_Period = 26;         // Slow EMA Period
input int      Signal_EMA_Period = 9;        // Signal EMA Period
input int      RSI_Period = 14;              // RSI Period
input int      ADX_Period = 14;              // ADX Period
input int      ATR_Period = 14;              // ATR Period

input group "=== Support/Resistance Settings ==="
input int      SR_Lookback = 100;            // Bars to check for S/R
input double   SR_Tolerance_Pips = 5.0;      // S/R tolerance in pips
input bool     ShowSRLevels = true;          // Show S/R on Chart

input group "=== Trading Settings ==="
input double   DefaultLotSize = 0.1;         // Default Lot Size
input int      MultiTradeCount = 3;          // Number of trades for "Open Multiple"
input double   StopLossPips = 30.0;          // Default Stop Loss (pips)
input double   TakeProfitPips = 60.0;        // Default Take Profit (pips)
input int      MagicNumber = 999888;         // Magic Number
input int      BreakEvenPips = 20;           // Break-Even Trigger (pips)

input group "=== Alert Settings ==="
input bool     EnableAudioAlerts = true;     // Audio Alerts
input bool     EnablePushAlerts = false;     // Push Notifications
input bool     EnableEmailAlerts = false;    // Email Alerts

//--- Global Variables
CTrade trade;
int handleStochastic;
int handleFastEMA;
int handleSlowEMA;
int handleSignalEMA;
int handleRSI;
int handleADX;
int handleATR;

double stochMain[], stochSignal[];
double fastEMA[], slowEMA[], signalEMA[];
double rsi[], adx[], atr[];

bool stochOverboughtAlerted = false;
bool stochOversoldAlerted = false;

string panelName = "TradingManagerPanel";
string buttonPrefix = "TMBtn_";

//--- Support/Resistance levels
double supportLevels[10];
double resistanceLevels[10];
int supportCount = 0;
int resistanceCount = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   trade.SetExpertMagicNumber(MagicNumber);
   
   //--- Initialize indicators
   handleStochastic = iStochastic(_Symbol, PERIOD_CURRENT, Stoch_K_Period, Stoch_D_Period, Stoch_Slowing, MODE_SMA, STO_LOWHIGH);
   handleFastEMA = iMA(_Symbol, PERIOD_CURRENT, Fast_EMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleSlowEMA = iMA(_Symbol, PERIOD_CURRENT, Slow_EMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleSignalEMA = iMA(_Symbol, PERIOD_CURRENT, Signal_EMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handleRSI = iRSI(_Symbol, PERIOD_CURRENT, RSI_Period, PRICE_CLOSE);
   handleADX = iADX(_Symbol, PERIOD_CURRENT, ADX_Period);
   handleATR = iATR(_Symbol, PERIOD_CURRENT, ATR_Period);
   
   if(handleStochastic == INVALID_HANDLE || handleFastEMA == INVALID_HANDLE || 
      handleSlowEMA == INVALID_HANDLE || handleSignalEMA == INVALID_HANDLE ||
      handleRSI == INVALID_HANDLE || handleADX == INVALID_HANDLE || handleATR == INVALID_HANDLE)
   {
      Print("Error creating indicators");
      return(INIT_FAILED);
   }
   
   //--- Set arrays as series
   ArraySetAsSeries(stochMain, true);
   ArraySetAsSeries(stochSignal, true);
   ArraySetAsSeries(fastEMA, true);
   ArraySetAsSeries(slowEMA, true);
   ArraySetAsSeries(signalEMA, true);
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(adx, true);
   ArraySetAsSeries(atr, true);
   
   //--- Create dashboard
   CreateDashboard();
   
   //--- Calculate initial S/R levels
   CalculateSupportResistance();
   if(ShowSRLevels)
      DrawSupportResistance();
   
   Print("TradingManager initialized successfully");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicators
   if(handleStochastic != INVALID_HANDLE) IndicatorRelease(handleStochastic);
   if(handleFastEMA != INVALID_HANDLE) IndicatorRelease(handleFastEMA);
   if(handleSlowEMA != INVALID_HANDLE) IndicatorRelease(handleSlowEMA);
   if(handleSignalEMA != INVALID_HANDLE) IndicatorRelease(handleSignalEMA);
   if(handleRSI != INVALID_HANDLE) IndicatorRelease(handleRSI);
   if(handleADX != INVALID_HANDLE) IndicatorRelease(handleADX);
   if(handleATR != INVALID_HANDLE) IndicatorRelease(handleATR);
   
   //--- Delete dashboard
   DeleteDashboard();
   
   //--- Delete S/R lines
   ObjectsDeleteAll(0, "SR_");
   
   Print("TradingManager deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Update indicator values
   UpdateIndicators();
   
   //--- Update dashboard display
   UpdateDashboard();
   
   //--- Check for stochastic alerts
   if(EnableStochAlerts)
      CheckStochasticAlerts();
   
   //--- Check if we're near S/R levels
   CheckSupportResistanceProximity();
}

//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(StringFind(sparam, buttonPrefix) == 0)
      {
         HandleButtonClick(sparam);
      }
   }
}

//+------------------------------------------------------------------+
//| Create trading dashboard                                         |
//+------------------------------------------------------------------+
void CreateDashboard()
{
   int x = DashboardX;
   int y = DashboardY;
   int width = 300;
   int rowHeight = 25;
   
   //--- Main panel
   CreatePanel(panelName, x, y, width, 600, PanelColor);
   
   //--- Title
   CreateLabel(panelName + "_Title", x + 10, y + 5, "EA TRADING MANAGER", clrYellow, 12);
   y += 30;
   
   //--- Indicator section
   CreateLabel(panelName + "_IndTitle", x + 10, y, "=== INDICATORS ===", clrAqua, 10);
   y += rowHeight;
   
   CreateLabel(panelName + "_TrendLabel", x + 10, y, "Trend:", TextColor, 9);
   CreateLabel(panelName + "_TrendValue", x + 150, y, "---", clrGray, 9);
   y += rowHeight;
   
   CreateLabel(panelName + "_StochLabel", x + 10, y, "Stochastic:", TextColor, 9);
   CreateLabel(panelName + "_StochValue", x + 150, y, "---", clrGray, 9);
   y += rowHeight;
   
   CreateLabel(panelName + "_RSILabel", x + 10, y, "RSI:", TextColor, 9);
   CreateLabel(panelName + "_RSIValue", x + 150, y, "---", clrGray, 9);
   y += rowHeight;
   
   CreateLabel(panelName + "_ADXLabel", x + 10, y, "ADX:", TextColor, 9);
   CreateLabel(panelName + "_ADXValue", x + 150, y, "---", clrGray, 9);
   y += rowHeight;
   
   CreateLabel(panelName + "_ATRLabel", x + 10, y, "ATR:", TextColor, 9);
   CreateLabel(panelName + "_ATRValue", x + 150, y, "---", clrGray, 9);
   y += rowHeight + 5;
   
   //--- Position info section
   CreateLabel(panelName + "_PosTitle", x + 10, y, "=== POSITIONS ===", clrAqua, 10);
   y += rowHeight;
   
   CreateLabel(panelName + "_OpenLabel", x + 10, y, "Open Positions:", TextColor, 9);
   CreateLabel(panelName + "_OpenValue", x + 150, y, "0", clrGray, 9);
   y += rowHeight;
   
   CreateLabel(panelName + "_ProfitLabel", x + 10, y, "Total Profit:", TextColor, 9);
   CreateLabel(panelName + "_ProfitValue", x + 150, y, "$0.00", clrGray, 9);
   y += rowHeight + 10;
   
   //--- Trading buttons
   CreateLabel(panelName + "_BtnTitle", x + 10, y, "=== TRADING CONTROLS ===", clrAqua, 10);
   y += rowHeight + 5;
   
   CreateButton(buttonPrefix + "BUY", x + 10, y, 135, 35, "BUY", clrGreen);
   CreateButton(buttonPrefix + "SELL", x + 155, y, 135, 35, "SELL", clrRed);
   y += 45;
   
   CreateButton(buttonPrefix + "MULTI_BUY", x + 10, y, 135, 35, "OPEN " + IntegerToString(MultiTradeCount) + " BUYS", clrLimeGreen);
   CreateButton(buttonPrefix + "MULTI_SELL", x + 155, y, 135, 35, "OPEN " + IntegerToString(MultiTradeCount) + " SELLS", clrOrangeRed);
   y += 45;
   
   CreateButton(buttonPrefix + "CLOSE_PROFIT", x + 10, y, 280, 35, "CLOSE ALL PROFITABLE", clrGold);
   y += 45;
   
   CreateButton(buttonPrefix + "BREAKEVEN", x + 10, y, 280, 35, "SET BREAK-EVEN (LOSING)", clrOrange);
   y += 45;
   
   CreateButton(buttonPrefix + "CLOSE_ALL", x + 10, y, 280, 35, "CLOSE ALL POSITIONS", clrCrimson);
   y += 50;
   
   //--- S/R section
   CreateLabel(panelName + "_SRTitle", x + 10, y, "=== SUPPORT/RESISTANCE ===", clrAqua, 10);
   y += rowHeight;
   
   CreateLabel(panelName + "_SRInfo", x + 10, y, "Near S/R: ---", TextColor, 9);
   
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Update dashboard display                                         |
//+------------------------------------------------------------------+
void UpdateDashboard()
{
   //--- Update trend
   string trendText = "NEUTRAL";
   color trendColor = clrGray;
   
   if(ArraySize(fastEMA) > 0 && ArraySize(slowEMA) > 0)
   {
      if(fastEMA[0] > slowEMA[0])
      {
         trendText = "BULLISH ↑";
         trendColor = clrLimeGreen;
      }
      else if(fastEMA[0] < slowEMA[0])
      {
         trendText = "BEARISH ↓";
         trendColor = clrRed;
      }
   }
   ObjectSetString(0, panelName + "_TrendValue", OBJPROP_TEXT, trendText);
   ObjectSetInteger(0, panelName + "_TrendValue", OBJPROP_COLOR, trendColor);
   
   //--- Update Stochastic
   if(ArraySize(stochMain) > 0)
   {
      double stochVal = stochMain[0];
      string stochText = DoubleToString(stochVal, 1);
      color stochColor = clrGray;
      
      if(stochVal >= Stoch_Overbought)
      {
         stochText += " OVERBOUGHT";
         stochColor = clrRed;
      }
      else if(stochVal <= Stoch_Oversold)
      {
         stochText += " OVERSOLD";
         stochColor = clrLimeGreen;
      }
      
      ObjectSetString(0, panelName + "_StochValue", OBJPROP_TEXT, stochText);
      ObjectSetInteger(0, panelName + "_StochValue", OBJPROP_COLOR, stochColor);
   }
   
   //--- Update RSI
   if(ArraySize(rsi) > 0)
   {
      string rsiText = DoubleToString(rsi[0], 1);
      color rsiColor = clrGray;
      
      if(rsi[0] >= 70)
      {
         rsiText += " OVERBOUGHT";
         rsiColor = clrRed;
      }
      else if(rsi[0] <= 30)
      {
         rsiText += " OVERSOLD";
         rsiColor = clrLimeGreen;
      }
      
      ObjectSetString(0, panelName + "_RSIValue", OBJPROP_TEXT, rsiText);
      ObjectSetInteger(0, panelName + "_RSIValue", OBJPROP_COLOR, rsiColor);
   }
   
   //--- Update ADX
   if(ArraySize(adx) > 0)
   {
      string adxText = DoubleToString(adx[0], 1);
      color adxColor = clrGray;
      
      if(adx[0] >= 25)
      {
         adxText += " STRONG";
         adxColor = clrYellow;
      }
      else if(adx[0] < 20)
      {
         adxText += " WEAK";
         adxColor = clrGray;
      }
      
      ObjectSetString(0, panelName + "_ADXValue", OBJPROP_TEXT, adxText);
      ObjectSetInteger(0, panelName + "_ADXValue", OBJPROP_COLOR, adxColor);
   }
   
   //--- Update ATR
   if(ArraySize(atr) > 0)
   {
      ObjectSetString(0, panelName + "_ATRValue", OBJPROP_TEXT, DoubleToString(atr[0], _Digits));
   }
   
   //--- Update position info
   int totalPos = PositionsTotal();
   double totalProfit = 0.0;
   
   for(int i = 0; i < totalPos; i++)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            totalProfit += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
         }
      }
   }
   
   int myPositions = CountMyPositions();
   ObjectSetString(0, panelName + "_OpenValue", OBJPROP_TEXT, IntegerToString(myPositions));
   
   color profitColor = totalProfit >= 0 ? clrLimeGreen : clrRed;
   ObjectSetString(0, panelName + "_ProfitValue", OBJPROP_TEXT, "$" + DoubleToString(totalProfit, 2));
   ObjectSetInteger(0, panelName + "_ProfitValue", OBJPROP_COLOR, profitColor);
   
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Delete dashboard                                                 |
//+------------------------------------------------------------------+
void DeleteDashboard()
{
   ObjectsDeleteAll(0, panelName);
   ObjectsDeleteAll(0, buttonPrefix);
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Handle button click                                              |
//+------------------------------------------------------------------+
void HandleButtonClick(string buttonName)
{
   //--- Reset button state
   ObjectSetInteger(0, buttonName, OBJPROP_STATE, false);
   
   if(buttonName == buttonPrefix + "BUY")
   {
      OpenTrade(ORDER_TYPE_BUY, DefaultLotSize);
   }
   else if(buttonName == buttonPrefix + "SELL")
   {
      OpenTrade(ORDER_TYPE_SELL, DefaultLotSize);
   }
   else if(buttonName == buttonPrefix + "MULTI_BUY")
   {
      for(int i = 0; i < MultiTradeCount; i++)
      {
         OpenTrade(ORDER_TYPE_BUY, DefaultLotSize);
      }
      Print("Opened ", MultiTradeCount, " BUY positions");
   }
   else if(buttonName == buttonPrefix + "MULTI_SELL")
   {
      for(int i = 0; i < MultiTradeCount; i++)
      {
         OpenTrade(ORDER_TYPE_SELL, DefaultLotSize);
      }
      Print("Opened ", MultiTradeCount, " SELL positions");
   }
   else if(buttonName == buttonPrefix + "CLOSE_PROFIT")
   {
      CloseAllProfitable();
   }
   else if(buttonName == buttonPrefix + "BREAKEVEN")
   {
      SetBreakEvenForLosing();
   }
   else if(buttonName == buttonPrefix + "CLOSE_ALL")
   {
      CloseAllPositions();
   }
   
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Open trade                                                        |
//+------------------------------------------------------------------+
void OpenTrade(ENUM_ORDER_TYPE type, double lots)
{
   double price = (type == ORDER_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double sl = 0, tp = 0;
   
   if(StopLossPips > 0)
   {
      if(type == ORDER_TYPE_BUY)
         sl = price - StopLossPips * 10 * point;
      else
         sl = price + StopLossPips * 10 * point;
   }
   
   if(TakeProfitPips > 0)
   {
      if(type == ORDER_TYPE_BUY)
         tp = price + TakeProfitPips * 10 * point;
      else
         tp = price - TakeProfitPips * 10 * point;
   }
   
   if(trade.PositionOpen(_Symbol, type, lots, price, sl, tp, "TradingManager"))
   {
      Print("Trade opened: ", EnumToString(type), " ", lots, " lots at ", price);
   }
   else
   {
      Print("Failed to open trade: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Close all profitable positions                                   |
//+------------------------------------------------------------------+
void CloseAllProfitable()
{
   int closed = 0;
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            double profit = PositionGetDouble(POSITION_PROFIT);
            if(profit > 0)
            {
               if(trade.PositionClose(PositionGetTicket(i)))
                  closed++;
            }
         }
      }
   }
   
   Print("Closed ", closed, " profitable positions");
   
   if(EnableAudioAlerts && closed > 0)
      Alert("Closed ", closed, " profitable positions");
}

//+------------------------------------------------------------------+
//| Set break-even for losing positions                             |
//+------------------------------------------------------------------+
void SetBreakEvenForLosing()
{
   int modified = 0;
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            double profit = PositionGetDouble(POSITION_PROFIT);
            
            if(profit < 0) // Only losing positions
            {
               ulong ticket = PositionGetTicket(i);
               double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
               double currentSL = PositionGetDouble(POSITION_SL);
               double currentTP = PositionGetDouble(POSITION_TP);
               ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
               
               // Calculate current profit in pips
               double currentPrice = (posType == POSITION_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
               double currentPips = MathAbs(currentPrice - openPrice) / (10 * point);
               
               // Only set BE if we have some profit
               if(currentPips >= BreakEvenPips)
               {
                  double newSL = openPrice;
                  
                  if(trade.PositionModify(ticket, newSL, currentTP))
                     modified++;
               }
            }
         }
      }
   }
   
   Print("Set break-even for ", modified, " losing positions");
   
   if(EnableAudioAlerts && modified > 0)
      Alert("Set break-even for ", modified, " positions");
}

//+------------------------------------------------------------------+
//| Close all positions                                              |
//+------------------------------------------------------------------+
void CloseAllPositions()
{
   int closed = 0;
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            if(trade.PositionClose(PositionGetTicket(i)))
               closed++;
         }
      }
   }
   
   Print("Closed ", closed, " positions");
   
   if(EnableAudioAlerts && closed > 0)
      Alert("Closed all ", closed, " positions");
}

//+------------------------------------------------------------------+
//| Count positions managed by this EA                               |
//+------------------------------------------------------------------+
int CountMyPositions()
{
   int count = 0;
   
   for(int i = 0; i < PositionsTotal(); i++)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
            count++;
      }
   }
   
   return count;
}

//+------------------------------------------------------------------+
//| Update indicator values                                          |
//+------------------------------------------------------------------+
void UpdateIndicators()
{
   CopyBuffer(handleStochastic, 0, 0, 3, stochMain);
   CopyBuffer(handleStochastic, 1, 0, 3, stochSignal);
   CopyBuffer(handleFastEMA, 0, 0, 3, fastEMA);
   CopyBuffer(handleSlowEMA, 0, 0, 3, slowEMA);
   CopyBuffer(handleSignalEMA, 0, 0, 3, signalEMA);
   CopyBuffer(handleRSI, 0, 0, 3, rsi);
   CopyBuffer(handleADX, 0, 0, 3, adx);
   CopyBuffer(handleATR, 0, 0, 3, atr);
}

//+------------------------------------------------------------------+
//| Check for stochastic alerts                                      |
//+------------------------------------------------------------------+
void CheckStochasticAlerts()
{
   if(ArraySize(stochMain) > 1)
   {
      double currentStoch = stochMain[0];
      double previousStoch = stochMain[1];
      
      //--- Check for overbought alert
      if(currentStoch >= Stoch_Overbought && previousStoch < Stoch_Overbought && !stochOverboughtAlerted)
      {
         string message = "Stochastic OVERBOUGHT: " + DoubleToString(currentStoch, 1) + " (Resistance area)";
         
         if(EnableAudioAlerts)
            Alert(message);
         
         if(EnablePushAlerts)
            SendNotification(message);
         
         if(EnableEmailAlerts)
            SendMail("TradingManager Alert", message);
         
         Print(message);
         stochOverboughtAlerted = true;
         stochOversoldAlerted = false;
      }
      
      //--- Check for oversold alert
      if(currentStoch <= Stoch_Oversold && previousStoch > Stoch_Oversold && !stochOversoldAlerted)
      {
         string message = "Stochastic OVERSOLD: " + DoubleToString(currentStoch, 1) + " (Support area)";
         
         if(EnableAudioAlerts)
            Alert(message);
         
         if(EnablePushAlerts)
            SendNotification(message);
         
         if(EnableEmailAlerts)
            SendMail("TradingManager Alert", message);
         
         Print(message);
         stochOversoldAlerted = true;
         stochOverboughtAlerted = false;
      }
      
      //--- Reset alerts when back in neutral zone
      if(currentStoch > Stoch_Oversold + 10 && currentStoch < Stoch_Overbought - 10)
      {
         stochOverboughtAlerted = false;
         stochOversoldAlerted = false;
      }
   }
}

//+------------------------------------------------------------------+
//| Calculate support and resistance levels                          |
//+------------------------------------------------------------------+
void CalculateSupportResistance()
{
   supportCount = 0;
   resistanceCount = 0;
   
   double highs[], lows[];
   ArrayResize(highs, SR_Lookback);
   ArrayResize(lows, SR_Lookback);
   
   for(int i = 0; i < SR_Lookback; i++)
   {
      highs[i] = iHigh(_Symbol, PERIOD_CURRENT, i);
      lows[i] = iLow(_Symbol, PERIOD_CURRENT, i);
   }
   
   //--- Find resistance levels (swing highs)
   for(int i = 2; i < SR_Lookback - 2; i++)
   {
      if(highs[i] > highs[i-1] && highs[i] > highs[i-2] && 
         highs[i] > highs[i+1] && highs[i] > highs[i+2])
      {
         bool isDuplicate = false;
         for(int j = 0; j < resistanceCount; j++)
         {
            if(MathAbs(highs[i] - resistanceLevels[j]) < SR_Tolerance_Pips * 10 * SymbolInfoDouble(_Symbol, SYMBOL_POINT))
            {
               isDuplicate = true;
               break;
            }
         }
         
         if(!isDuplicate && resistanceCount < 10)
         {
            resistanceLevels[resistanceCount] = highs[i];
            resistanceCount++;
         }
      }
   }
   
   //--- Find support levels (swing lows)
   for(int i = 2; i < SR_Lookback - 2; i++)
   {
      if(lows[i] < lows[i-1] && lows[i] < lows[i-2] && 
         lows[i] < lows[i+1] && lows[i] < lows[i+2])
      {
         bool isDuplicate = false;
         for(int j = 0; j < supportCount; j++)
         {
            if(MathAbs(lows[i] - supportLevels[j]) < SR_Tolerance_Pips * 10 * SymbolInfoDouble(_Symbol, SYMBOL_POINT))
            {
               isDuplicate = true;
               break;
            }
         }
         
         if(!isDuplicate && supportCount < 10)
         {
            supportLevels[supportCount] = lows[i];
            supportCount++;
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Draw support and resistance on chart                             |
//+------------------------------------------------------------------+
void DrawSupportResistance()
{
   //--- Delete old lines
   ObjectsDeleteAll(0, "SR_");
   
   //--- Draw resistance lines
   for(int i = 0; i < resistanceCount; i++)
   {
      string name = "SR_Resistance_" + IntegerToString(i);
      ObjectCreate(0, name, OBJ_HLINE, 0, 0, resistanceLevels[i]);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clrRed);
      ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, name, OBJPROP_BACK, true);
      ObjectSetString(0, name, OBJPROP_TEXT, "Resistance");
   }
   
   //--- Draw support lines
   for(int i = 0; i < supportCount; i++)
   {
      string name = "SR_Support_" + IntegerToString(i);
      ObjectCreate(0, name, OBJ_HLINE, 0, 0, supportLevels[i]);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clrLimeGreen);
      ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, name, OBJPROP_BACK, true);
      ObjectSetString(0, name, OBJPROP_TEXT, "Support");
   }
   
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Check proximity to S/R levels                                    |
//+------------------------------------------------------------------+
void CheckSupportResistanceProximity()
{
   static datetime lastCheck = 0;
   
   if(TimeCurrent() - lastCheck < 60) // Check every minute
      return;
   
   lastCheck = TimeCurrent();
   
   double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double tolerance = SR_Tolerance_Pips * 10 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   string srInfo = "Near S/R: ---";
   
   //--- Check resistance
   for(int i = 0; i < resistanceCount; i++)
   {
      if(MathAbs(currentPrice - resistanceLevels[i]) < tolerance)
      {
         srInfo = "Near RESISTANCE: " + DoubleToString(resistanceLevels[i], _Digits);
         break;
      }
   }
   
   //--- Check support
   for(int i = 0; i < supportCount; i++)
   {
      if(MathAbs(currentPrice - supportLevels[i]) < tolerance)
      {
         srInfo = "Near SUPPORT: " + DoubleToString(supportLevels[i], _Digits);
         break;
      }
   }
   
   ObjectSetString(0, panelName + "_SRInfo", OBJPROP_TEXT, srInfo);
}

//+------------------------------------------------------------------+
//| Create panel object                                              |
//+------------------------------------------------------------------+
void CreatePanel(string name, int x, int y, int width, int height, color bgColor)
{
   ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_RAISED);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
}

//+------------------------------------------------------------------+
//| Create label object                                              |
//+------------------------------------------------------------------+
void CreateLabel(string name, int x, int y, string text, color clr, int fontSize)
{
   ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");
}

//+------------------------------------------------------------------+
//| Create button object                                             |
//+------------------------------------------------------------------+
void CreateButton(string name, int x, int y, int width, int height, string text, color clr)
{
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrBlack);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial Bold");
}
