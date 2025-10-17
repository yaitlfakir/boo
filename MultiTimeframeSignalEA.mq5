//+------------------------------------------------------------------+
//|                                      MultiTimeframeSignalEA.mq5 |
//|                                         MetaTrader 5 Expert Advisor |
//|                    Multi-Timeframe Buy/Sell Signal Display       |
//+------------------------------------------------------------------+
#property copyright "MultiTimeframeSignalEA"
#property version   "1.00"
#property description "Shows buy/sell signals based on multi-timeframe analysis"

//--- Input Parameters
input group "=== Signal Display Settings ==="
input color    BuyArrowColor = clrLime;       // Buy Arrow Color
input color    SellArrowColor = clrRed;       // Sell Arrow Color
input int      ArrowSize = 2;                 // Arrow Size (1-5)

input group "=== Alert Settings ==="
input bool     EnableAlerts = true;           // Enable Audio Alerts
input bool     EnableVisualAlerts = true;     // Enable Visual Alerts
input bool     EnableEmailAlerts = false;     // Enable Email Alerts

//--- Global Variables
int handle_Stoch_M1;      // Stochastic handle for 1-minute
int handle_MA3_M1;        // MA 3 handle for 1-minute
int handle_MA9_M1;        // MA 9 handle for 1-minute

int handle_Stoch_M5;      // Stochastic handle for 5-minute
int handle_MA3_M5;        // MA 3 handle for 5-minute
int handle_MA9_M5;        // MA 9 handle for 5-minute

int handle_Stoch_M15;     // Stochastic handle for 15-minute
int handle_MA3_M15;       // MA 3 handle for 15-minute
int handle_MA9_M15;       // MA 9 handle for 15-minute

datetime lastBarTime = 0;
datetime lastAlertTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   
   //--- Initialize indicators for 1-minute timeframe
   handle_Stoch_M1 = iStochastic(_Symbol, PERIOD_M1, 19, 7, 1, MODE_SMA, STO_LOWHIGH);
   handle_MA3_M1 = iMA(_Symbol, PERIOD_M1, 3, 0, MODE_SMA, PRICE_CLOSE);
   handle_MA9_M1 = iMA(_Symbol, PERIOD_M1, 9, 0, MODE_SMA, PRICE_CLOSE);
   
   //--- Initialize indicators for 5-minute timeframe
   handle_Stoch_M5 = iStochastic(_Symbol, PERIOD_M5, 19, 3, 1, MODE_SMA, STO_LOWHIGH);
   handle_MA3_M5 = iMA(_Symbol, PERIOD_M5, 3, 0, MODE_SMA, PRICE_CLOSE);
   handle_MA9_M5 = iMA(_Symbol, PERIOD_M5, 9, 0, MODE_SMA, PRICE_CLOSE);
   
   //--- Initialize indicators for 15-minute timeframe
   handle_Stoch_M15 = iStochastic(_Symbol, PERIOD_M15, 19, 3, 1, MODE_SMA, STO_LOWHIGH);
   handle_MA3_M15 = iMA(_Symbol, PERIOD_M15, 3, 0, MODE_SMA, PRICE_CLOSE);
   handle_MA9_M15 = iMA(_Symbol, PERIOD_M15, 9, 0, MODE_SMA, PRICE_CLOSE);
   
   //--- Check if indicators are created successfully
   if(handle_Stoch_M1 == INVALID_HANDLE || handle_MA3_M1 == INVALID_HANDLE || handle_MA9_M1 == INVALID_HANDLE ||
      handle_Stoch_M5 == INVALID_HANDLE || handle_MA3_M5 == INVALID_HANDLE || handle_MA9_M5 == INVALID_HANDLE ||
      handle_Stoch_M15 == INVALID_HANDLE || handle_MA3_M15 == INVALID_HANDLE || handle_MA9_M15 == INVALID_HANDLE)
   {
      Print("Error creating indicators");
      return(INIT_FAILED);
   }
   
   Print("MultiTimeframeSignalEA initialized successfully");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(handle_Stoch_M1 != INVALID_HANDLE) IndicatorRelease(handle_Stoch_M1);
   if(handle_MA3_M1 != INVALID_HANDLE) IndicatorRelease(handle_MA3_M1);
   if(handle_MA9_M1 != INVALID_HANDLE) IndicatorRelease(handle_MA9_M1);
   
   if(handle_Stoch_M5 != INVALID_HANDLE) IndicatorRelease(handle_Stoch_M5);
   if(handle_MA3_M5 != INVALID_HANDLE) IndicatorRelease(handle_MA3_M5);
   if(handle_MA9_M5 != INVALID_HANDLE) IndicatorRelease(handle_MA9_M5);
   
   if(handle_Stoch_M15 != INVALID_HANDLE) IndicatorRelease(handle_Stoch_M15);
   if(handle_MA3_M15 != INVALID_HANDLE) IndicatorRelease(handle_MA3_M15);
   if(handle_MA9_M15 != INVALID_HANDLE) IndicatorRelease(handle_MA9_M15);
   
   Print("MultiTimeframeSignalEA deinitialized");
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
   
   //--- Arrays for indicator values
   double stoch_main_m1[], stoch_signal_m1[];
   double ma3_m1[], ma9_m1[];
   
   double stoch_main_m5[], stoch_signal_m5[];
   double ma3_m5[], ma9_m5[];
   
   double stoch_main_m15[], stoch_signal_m15[];
   double ma3_m15[], ma9_m15[];
   
   ArraySetAsSeries(stoch_main_m1, true);
   ArraySetAsSeries(stoch_signal_m1, true);
   ArraySetAsSeries(ma3_m1, true);
   ArraySetAsSeries(ma9_m1, true);
   
   ArraySetAsSeries(stoch_main_m5, true);
   ArraySetAsSeries(stoch_signal_m5, true);
   ArraySetAsSeries(ma3_m5, true);
   ArraySetAsSeries(ma9_m5, true);
   
   ArraySetAsSeries(stoch_main_m15, true);
   ArraySetAsSeries(stoch_signal_m15, true);
   ArraySetAsSeries(ma3_m15, true);
   ArraySetAsSeries(ma9_m15, true);
   
   //--- Copy indicator data for 1-minute
   if(CopyBuffer(handle_Stoch_M1, 0, 0, 2, stoch_main_m1) < 2) return;
   if(CopyBuffer(handle_Stoch_M1, 1, 0, 2, stoch_signal_m1) < 2) return;
   if(CopyBuffer(handle_MA3_M1, 0, 0, 2, ma3_m1) < 2) return;
   if(CopyBuffer(handle_MA9_M1, 0, 0, 2, ma9_m1) < 2) return;
   
   //--- Copy indicator data for 5-minute
   if(CopyBuffer(handle_Stoch_M5, 0, 0, 2, stoch_main_m5) < 2) return;
   if(CopyBuffer(handle_Stoch_M5, 1, 0, 2, stoch_signal_m5) < 2) return;
   if(CopyBuffer(handle_MA3_M5, 0, 0, 2, ma3_m5) < 2) return;
   if(CopyBuffer(handle_MA9_M5, 0, 0, 2, ma9_m5) < 2) return;
   
   //--- Copy indicator data for 15-minute
   if(CopyBuffer(handle_Stoch_M15, 0, 0, 2, stoch_main_m15) < 2) return;
   if(CopyBuffer(handle_Stoch_M15, 1, 0, 2, stoch_signal_m15) < 2) return;
   if(CopyBuffer(handle_MA3_M15, 0, 0, 2, ma3_m15) < 2) return;
   if(CopyBuffer(handle_MA9_M15, 0, 0, 2, ma9_m15) < 2) return;
   
   //--- Get current price data
   double high = iHigh(_Symbol, PERIOD_CURRENT, 0);
   double low = iLow(_Symbol, PERIOD_CURRENT, 0);
   
   //--- Check for SELL signal
   // Conditions:
   // 1. M1: MA(3) was < MA(9) in previous candle [1] AND MA(3) > MA(9) in current candle [0] (crossover up)
   // 2. M1: Stochastic signal value > 80 AND stochastic main < signal
   // 3. M5: Stochastic main < signal
   // 4. M15: Stochastic main < signal
   bool sellSignal = false;
   if(ma3_m1[1] < ma9_m1[1] && ma3_m1[0] > ma9_m1[0])  // MA crossover up on M1
   {
      if(stoch_signal_m1[0] > 80 && stoch_main_m1[0] < stoch_signal_m1[0])  // Stoch conditions on M1
      {
         if(stoch_main_m5[0] < stoch_signal_m5[0])  // Stoch on M5
         {
            if(stoch_main_m15[0] < stoch_signal_m15[0])  // Stoch on M15
            {
               sellSignal = true;
               DrawArrow("Sell_" + TimeToString(currentBarTime), currentBarTime, high, 234, SellArrowColor);
            }
         }
      }
   }
   
   //--- Check for BUY signal
   // Conditions:
   // 1. M1: MA(3) was > MA(9) in previous candle [1] AND MA(3) < MA(9) in current candle [0] (crossover down)
   // 2. M1: Stochastic signal value < 30 AND stochastic main > signal
   // 3. M5: Stochastic main > signal
   // 4. M15: Stochastic main > signal
   bool buySignal = false;
   if(ma3_m1[1] > ma9_m1[1] && ma3_m1[0] < ma9_m1[0])  // MA crossover down on M1
   {
      if(stoch_signal_m1[0] < 30 && stoch_main_m1[0] > stoch_signal_m1[0])  // Stoch conditions on M1
      {
         if(stoch_main_m5[0] > stoch_signal_m5[0])  // Stoch on M5
         {
            if(stoch_main_m15[0] > stoch_signal_m15[0])  // Stoch on M15
            {
               buySignal = true;
               DrawArrow("Buy_" + TimeToString(currentBarTime), currentBarTime, low, 233, BuyArrowColor);
            }
         }
      }
   }
   
   //--- Send alerts if signals detected
   if((buySignal || sellSignal) && (currentBarTime != lastAlertTime))
   {
      lastAlertTime = currentBarTime;
      
      if(buySignal)
      {
         if(EnableAlerts)
            Alert("BUY Signal detected on ", _Symbol);
         if(EnableVisualAlerts)
            SendNotification("BUY Signal detected on " + _Symbol);
         if(EnableEmailAlerts)
            SendMail("BUY Signal - " + _Symbol, "BUY Signal detected on " + _Symbol + " at " + TimeToString(currentBarTime));
      }
      else if(sellSignal)
      {
         if(EnableAlerts)
            Alert("SELL Signal detected on ", _Symbol);
         if(EnableVisualAlerts)
            SendNotification("SELL Signal detected on " + _Symbol);
         if(EnableEmailAlerts)
            SendMail("SELL Signal - " + _Symbol, "SELL Signal detected on " + _Symbol + " at " + TimeToString(currentBarTime));
      }
   }
   
}

//+------------------------------------------------------------------+
//| Draw arrow on chart                                              |
//+------------------------------------------------------------------+
void DrawArrow(string name, datetime time, double price, int arrowCode, color arrowColor)
{
   //--- Delete existing object if it exists
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
   
   //--- Create arrow object
   if(ObjectCreate(0, name, OBJ_ARROW, 0, time, price))
   {
      ObjectSetInteger(0, name, OBJPROP_ARROWCODE, arrowCode);
      ObjectSetInteger(0, name, OBJPROP_COLOR, arrowColor);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, ArrowSize);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   }
}
//+------------------------------------------------------------------+
