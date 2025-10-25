//+------------------------------------------------------------------+
//|                                           EurusdPredictorEA.mq5 |
//|                                    MetaTrader 5 Expert Advisor   |
//|                       EURUSD Price Movement Prediction & Signals  |
//+------------------------------------------------------------------+
#property copyright "EurusdPredictorEA"
#property version   "2.00"
#property description "EURUSD price movement predictor with visual signals"
#property description "Displays UP/DOWN signals based on technical analysis"
#property description "Enhanced with volatility filter, trend strength, and multi-timeframe analysis"

//--- Input Parameters
input group "=== Signal Display Settings ==="
input color    UpSignalColor = clrLime;          // UP Signal Color
input color    DownSignalColor = clrRed;         // DOWN Signal Color
input int      SignalSize = 3;                   // Signal Size (1-5)
input bool     ShowSignalText = true;            // Show UP/DOWN Text

input group "=== Prediction Parameters ==="
input int      FastEMA_Period = 12;              // Fast EMA Period
input int      SlowEMA_Period = 26;              // Slow EMA Period
input int      SignalEMA_Period = 9;             // Signal EMA Period
input int      RSI_Period = 14;                  // RSI Period
input double   RSI_UpLevel = 55.0;               // RSI UP Threshold
input double   RSI_DownLevel = 45.0;             // RSI DOWN Threshold
input int      MACD_Fast = 12;                   // MACD Fast Period
input int      MACD_Slow = 26;                   // MACD Slow Period
input int      MACD_Signal = 9;                  // MACD Signal Period
input int      ATR_Period = 14;                  // ATR Period for Volatility
input int      ADX_Period = 14;                  // ADX Period for Trend Strength
input double   MinADX_Level = 20.0;              // Minimum ADX for Strong Trend

input group "=== Alert Settings ==="
input bool     EnableAudioAlerts = true;         // Enable Audio Alerts
input bool     EnablePushNotifications = false;  // Enable Push Notifications
input bool     EnableEmailAlerts = false;        // Enable Email Alerts

input group "=== Advanced Settings ==="
input int      MinBarsRequired = 50;             // Minimum Bars for Analysis
input bool     CheckSymbol = true;               // Restrict to EURUSD Only
input int      TextOffsetPoints = 50;            // Text Offset from Arrow (points)
input bool     UseVolatilityFilter = true;       // Use ATR Volatility Filter
input bool     UseTrendFilter = true;            // Use ADX Trend Filter
input bool     UseMultiTimeframe = true;         // Use Multi-Timeframe Confirmation
input int      SignalThreshold = 6;              // Minimum Score for Signal (5-9)

//--- Constants
#define TARGET_SYMBOL "EURUSD"                    // Target symbol for EA
#define SIGNAL_PREFIX "EurusdSignal_"             // Prefix for signal arrows
#define TEXT_PREFIX "EurusdText_"                 // Prefix for signal text

//--- Global Variables
int handle_FastEMA;
int handle_SlowEMA;
int handle_SignalEMA;
int handle_RSI;
int handle_MACD;
int handle_ATR;
int handle_ADX;

// Multi-timeframe handles
int handle_FastEMA_HTF;
int handle_SlowEMA_HTF;

datetime lastBarTime = 0;
datetime lastSignalTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Check if symbol is EURUSD
   if(CheckSymbol && _Symbol != TARGET_SYMBOL)
   {
      Print("ERROR: This EA is designed for ", TARGET_SYMBOL, " only. Current symbol: ", _Symbol);
      Alert("EurusdPredictorEA: This EA works only on ", TARGET_SYMBOL, " chart!");
      return(INIT_FAILED);
   }
   
   //--- Check if we have enough bars
   int bars = iBars(_Symbol, PERIOD_CURRENT);
   if(bars < MinBarsRequired)
   {
      Print("ERROR: Not enough bars. Required: ", MinBarsRequired, ", Available: ", bars);
      return(INIT_FAILED);
   }
   
   //--- Initialize indicators
   handle_FastEMA = iMA(_Symbol, PERIOD_CURRENT, FastEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handle_SlowEMA = iMA(_Symbol, PERIOD_CURRENT, SlowEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handle_SignalEMA = iMA(_Symbol, PERIOD_CURRENT, SignalEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   handle_RSI = iRSI(_Symbol, PERIOD_CURRENT, RSI_Period, PRICE_CLOSE);
   handle_MACD = iMACD(_Symbol, PERIOD_CURRENT, MACD_Fast, MACD_Slow, MACD_Signal, PRICE_CLOSE);
   handle_ATR = iATR(_Symbol, PERIOD_CURRENT, ATR_Period);
   handle_ADX = iADX(_Symbol, PERIOD_CURRENT, ADX_Period);
   
   //--- Initialize higher timeframe indicators if multi-timeframe is enabled
   if(UseMultiTimeframe)
   {
      ENUM_TIMEFRAMES htf = GetHigherTimeframe(PERIOD_CURRENT);
      handle_FastEMA_HTF = iMA(_Symbol, htf, FastEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
      handle_SlowEMA_HTF = iMA(_Symbol, htf, SlowEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   }
   
   //--- Check if indicators are created successfully
   if(handle_FastEMA == INVALID_HANDLE || handle_SlowEMA == INVALID_HANDLE || 
      handle_SignalEMA == INVALID_HANDLE || handle_RSI == INVALID_HANDLE || 
      handle_MACD == INVALID_HANDLE || handle_ATR == INVALID_HANDLE || 
      handle_ADX == INVALID_HANDLE)
   {
      Print("ERROR: Failed to create indicators");
      return(INIT_FAILED);
   }
   
   //--- Check multi-timeframe indicators
   if(UseMultiTimeframe && (handle_FastEMA_HTF == INVALID_HANDLE || handle_SlowEMA_HTF == INVALID_HANDLE))
   {
      Print("ERROR: Failed to create higher timeframe indicators");
      return(INIT_FAILED);
   }
   
   Print("==================================================");
   Print("EurusdPredictorEA initialized successfully");
   Print("Symbol: ", _Symbol);
   Print("Timeframe: ", EnumToString(PERIOD_CURRENT));
   Print("Fast EMA: ", FastEMA_Period, " | Slow EMA: ", SlowEMA_Period);
   Print("RSI Period: ", RSI_Period, " | ATR Period: ", ATR_Period);
   Print("ADX Period: ", ADX_Period, " | Min ADX: ", MinADX_Level);
   Print("Signal Threshold: ", SignalThreshold);
   Print("Volatility Filter: ", UseVolatilityFilter ? "ON" : "OFF");
   Print("Trend Filter: ", UseTrendFilter ? "ON" : "OFF");
   Print("Multi-Timeframe: ", UseMultiTimeframe ? "ON" : "OFF");
   Print("==================================================");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(handle_FastEMA != INVALID_HANDLE) IndicatorRelease(handle_FastEMA);
   if(handle_SlowEMA != INVALID_HANDLE) IndicatorRelease(handle_SlowEMA);
   if(handle_SignalEMA != INVALID_HANDLE) IndicatorRelease(handle_SignalEMA);
   if(handle_RSI != INVALID_HANDLE) IndicatorRelease(handle_RSI);
   if(handle_MACD != INVALID_HANDLE) IndicatorRelease(handle_MACD);
   if(handle_ATR != INVALID_HANDLE) IndicatorRelease(handle_ATR);
   if(handle_ADX != INVALID_HANDLE) IndicatorRelease(handle_ADX);
   if(handle_FastEMA_HTF != INVALID_HANDLE) IndicatorRelease(handle_FastEMA_HTF);
   if(handle_SlowEMA_HTF != INVALID_HANDLE) IndicatorRelease(handle_SlowEMA_HTF);
   
   //--- Clean up chart objects
   ObjectsDeleteAll(0, SIGNAL_PREFIX);
   ObjectsDeleteAll(0, TEXT_PREFIX);
   
   Print("EurusdPredictorEA deinitialized. Reason: ", reason);
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
   double fastEMA[], slowEMA[], signalEMA[];
   double rsi[];
   double macd_main[], macd_signal[];
   double atr[];
   double adx_main[], adx_plus[], adx_minus[];
   double fastEMA_HTF[], slowEMA_HTF[];
   
   //--- Set arrays as series
   ArraySetAsSeries(fastEMA, true);
   ArraySetAsSeries(slowEMA, true);
   ArraySetAsSeries(signalEMA, true);
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(macd_main, true);
   ArraySetAsSeries(macd_signal, true);
   ArraySetAsSeries(atr, true);
   ArraySetAsSeries(adx_main, true);
   ArraySetAsSeries(adx_plus, true);
   ArraySetAsSeries(adx_minus, true);
   ArraySetAsSeries(fastEMA_HTF, true);
   ArraySetAsSeries(slowEMA_HTF, true);
   
   //--- Copy indicator data (need current [0] and previous [1] bars)
   if(CopyBuffer(handle_FastEMA, 0, 0, 3, fastEMA) < 3) return;
   if(CopyBuffer(handle_SlowEMA, 0, 0, 3, slowEMA) < 3) return;
   if(CopyBuffer(handle_SignalEMA, 0, 0, 3, signalEMA) < 3) return;
   if(CopyBuffer(handle_RSI, 0, 0, 3, rsi) < 3) return;
   if(CopyBuffer(handle_MACD, 0, 0, 3, macd_main) < 3) return;
   if(CopyBuffer(handle_MACD, 1, 0, 3, macd_signal) < 3) return;
   if(CopyBuffer(handle_ATR, 0, 0, 3, atr) < 3) return;
   if(CopyBuffer(handle_ADX, 0, 0, 3, adx_main) < 3) return;
   if(CopyBuffer(handle_ADX, 1, 0, 3, adx_plus) < 3) return;
   if(CopyBuffer(handle_ADX, 2, 0, 3, adx_minus) < 3) return;
   
   //--- Copy higher timeframe data if enabled
   if(UseMultiTimeframe)
   {
      if(CopyBuffer(handle_FastEMA_HTF, 0, 0, 2, fastEMA_HTF) < 2) return;
      if(CopyBuffer(handle_SlowEMA_HTF, 0, 0, 2, slowEMA_HTF) < 2) return;
   }
   
   //--- Get price data
   double high = iHigh(_Symbol, PERIOD_CURRENT, 0);
   double low = iLow(_Symbol, PERIOD_CURRENT, 0);
   double close = iClose(_Symbol, PERIOD_CURRENT, 0);
   double prevClose = iClose(_Symbol, PERIOD_CURRENT, 1);
   
   //--- Apply Volatility Filter using ATR
   if(UseVolatilityFilter)
   {
      double avgATR = (atr[0] + atr[1] + atr[2]) / 3.0;
      if(atr[0] < avgATR * 0.5)
      {
         // Too low volatility - unreliable signals
         return;
      }
   }
   
   //--- Apply Trend Strength Filter using ADX
   if(UseTrendFilter)
   {
      if(adx_main[0] < MinADX_Level)
      {
         // Market is ranging, skip signals
         return;
      }
   }
   
   //--- Apply Multi-Timeframe Filter
   bool htf_bullish = true;
   bool htf_bearish = true;
   if(UseMultiTimeframe)
   {
      htf_bullish = (fastEMA_HTF[0] > slowEMA_HTF[0]);
      htf_bearish = (fastEMA_HTF[0] < slowEMA_HTF[0]);
   }
   
   //--- Analyze prediction signals
   int upScore = 0;
   int downScore = 0;
   
   //--- 1. EMA Crossover Analysis (Weight: 3 points for strong crossover)
   // Fast EMA crosses above Slow EMA = Bullish
   // Fast EMA crosses below Slow EMA = Bearish
   if(fastEMA[1] <= slowEMA[1] && fastEMA[0] > slowEMA[0])
      upScore += 3;  // Strong bullish crossover
   else if(fastEMA[1] >= slowEMA[1] && fastEMA[0] < slowEMA[0])
      downScore += 3;  // Strong bearish crossover
      
   //--- 2. EMA Trend Analysis (Weight: 1 point)
   // Fast EMA above Slow EMA = Uptrend
   if(fastEMA[0] > slowEMA[0])
      upScore += 1;
   else
      downScore += 1;
   
   //--- 3. RSI Analysis (Weight: 2 points for momentum, 1 for bias)
   // RSI > 55 and rising = Bullish momentum
   // RSI < 45 and falling = Bearish momentum
   if(rsi[0] > RSI_UpLevel && rsi[0] > rsi[1])
      upScore += 2;
   else if(rsi[0] < RSI_DownLevel && rsi[0] < rsi[1])
      downScore += 2;
   else if(rsi[0] > 50)
      upScore += 1;  // Slight bullish bias
   else if(rsi[0] < 50)
      downScore += 1;  // Slight bearish bias
   
   //--- 4. MACD Analysis (Weight: 3 points for crossover, 1 for position)
   // MACD line crosses above signal line = Bullish
   // MACD line crosses below signal line = Bearish
   if(macd_main[1] <= macd_signal[1] && macd_main[0] > macd_signal[0])
      upScore += 3;  // Strong bullish MACD crossover
   else if(macd_main[1] >= macd_signal[1] && macd_main[0] < macd_signal[0])
      downScore += 3;  // Strong bearish MACD crossover
   else if(macd_main[0] > macd_signal[0])
      upScore += 1;  // MACD above signal
   else
      downScore += 1;  // MACD below signal
   
   //--- 5. Price vs Signal EMA (Weight: 1 point)
   if(close > signalEMA[0])
      upScore += 1;
   else
      downScore += 1;
      
   //--- 6. ADX Direction Analysis (Weight: 2 points)
   // +DI above -DI = Bullish pressure
   // -DI above +DI = Bearish pressure
   if(adx_plus[0] > adx_minus[0])
      upScore += 2;
   else if(adx_minus[0] > adx_plus[0])
      downScore += 2;
      
   //--- 7. Price Momentum (Weight: 1 point)
   // Closing above previous close = Bullish momentum
   if(close > prevClose)
      upScore += 1;
   else if(close < prevClose)
      downScore += 1;
      
   //--- 8. Multi-Timeframe Confirmation (Weight: 2 points)
   if(UseMultiTimeframe)
   {
      if(htf_bullish)
         upScore += 2;
      else if(htf_bearish)
         downScore += 2;
   }
   
   //--- Determine signal based on scores
   // Threshold: Use configurable SignalThreshold (default 6+ points for strong signal)
   // Maximum possible score: 16 points per direction (with multi-timeframe)
   string signalType = "";
   string signalQuality = "";
   color signalColor = clrNONE;
   int arrowCode = 0;
   
   if(upScore >= SignalThreshold && upScore > downScore)
   {
      signalType = "UP";
      signalColor = UpSignalColor;
      arrowCode = 233;  // Up arrow
      
      // Determine signal quality
      if(upScore >= 10)
         signalQuality = "STRONG";
      else if(upScore >= 8)
         signalQuality = "MEDIUM";
      else
         signalQuality = "WEAK";
   }
   else if(downScore >= SignalThreshold && downScore > upScore)
   {
      signalType = "DOWN";
      signalColor = DownSignalColor;
      arrowCode = 234;  // Down arrow
      
      // Determine signal quality
      if(downScore >= 10)
         signalQuality = "STRONG";
      else if(downScore >= 8)
         signalQuality = "MEDIUM";
      else
         signalQuality = "WEAK";
   }
   
   //--- Display signal if detected
   if(signalType != "")
   {
      string signalName = SIGNAL_PREFIX + TimeToString(currentBarTime);
      string textName = TEXT_PREFIX + TimeToString(currentBarTime);
      
      //--- Draw arrow
      if(signalType == "UP")
         DrawSignalArrow(signalName, currentBarTime, low, arrowCode, signalColor);
      else
         DrawSignalArrow(signalName, currentBarTime, high, arrowCode, signalColor);
      
      //--- Draw text if enabled
      if(ShowSignalText)
      {
         string displayText = signalType + " [" + signalQuality + "]";
         if(signalType == "UP")
            DrawSignalText(textName, currentBarTime, low, displayText, signalColor);
         else
            DrawSignalText(textName, currentBarTime, high, displayText, signalColor);
      }
      
      //--- Send alerts (only once per bar)
      if(currentBarTime != lastSignalTime)
      {
         lastSignalTime = currentBarTime;
         
         string alertMsg = "EURUSD Price Prediction: " + signalType + " [" + signalQuality + "]" +
                          " | Score: " + (signalType == "UP" ? IntegerToString(upScore) : IntegerToString(downScore)) +
                          " | ADX: " + DoubleToString(adx_main[0], 1) +
                          " | ATR: " + DoubleToString(atr[0] / _Point, 1) +
                          " | Time: " + TimeToString(currentBarTime, TIME_DATE|TIME_MINUTES);
         
         if(EnableAudioAlerts)
            Alert(alertMsg);
         
         if(EnablePushNotifications)
            SendNotification(alertMsg);
         
         if(EnableEmailAlerts)
            SendMail("EURUSD Signal - " + signalType, alertMsg);
         
         //--- Print to experts log
         Print("==================================================");
         Print("SIGNAL DETECTED: ", signalType, " [", signalQuality, "]");
         Print("UP Score: ", upScore, " | DOWN Score: ", downScore);
         Print("Fast EMA: ", NormalizeDouble(fastEMA[0], 5));
         Print("Slow EMA: ", NormalizeDouble(slowEMA[0], 5));
         Print("RSI: ", NormalizeDouble(rsi[0], 2));
         Print("MACD Main: ", NormalizeDouble(macd_main[0], 5));
         Print("MACD Signal: ", NormalizeDouble(macd_signal[0], 5));
         Print("ADX: ", NormalizeDouble(adx_main[0], 2), " | +DI: ", NormalizeDouble(adx_plus[0], 2), " | -DI: ", NormalizeDouble(adx_minus[0], 2));
         Print("ATR: ", NormalizeDouble(atr[0] / _Point, 1), " points");
         if(UseMultiTimeframe)
            Print("HTF Trend: ", (fastEMA_HTF[0] > slowEMA_HTF[0] ? "Bullish" : "Bearish"));
         Print("==================================================");
      }
   }
}

//+------------------------------------------------------------------+
//| Draw signal arrow on chart                                       |
//+------------------------------------------------------------------+
void DrawSignalArrow(string name, datetime time, double price, int arrowCode, color arrowColor)
{
   //--- Delete existing object if it exists
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
   
   //--- Create arrow object
   if(ObjectCreate(0, name, OBJ_ARROW, 0, time, price))
   {
      ObjectSetInteger(0, name, OBJPROP_ARROWCODE, arrowCode);
      ObjectSetInteger(0, name, OBJPROP_COLOR, arrowColor);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, SignalSize);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   }
   else
   {
      Print("ERROR: Failed to create arrow object: ", name);
   }
}

//+------------------------------------------------------------------+
//| Draw signal text on chart                                        |
//+------------------------------------------------------------------+
void DrawSignalText(string name, datetime time, double price, string text, color textColor)
{
   //--- Delete existing object if it exists
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
   
   //--- Adjust price for text placement
   double offset = _Point * TextOffsetPoints;  // Offset text from arrow
   if(text == "UP")
      price -= offset;
   else
      price += offset;
   
   //--- Create text object
   if(ObjectCreate(0, name, OBJ_TEXT, 0, time, price))
   {
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 10);
      ObjectSetString(0, name, OBJPROP_FONT, "Arial Bold");
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   }
   else
   {
      Print("ERROR: Failed to create text object: ", name);
   }
}

//+------------------------------------------------------------------+
//| Get higher timeframe for multi-timeframe analysis               |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES GetHigherTimeframe(ENUM_TIMEFRAMES current_tf)
{
   // Return the next higher timeframe for confirmation
   switch(current_tf)
   {
      case PERIOD_M1:  return PERIOD_M5;
      case PERIOD_M5:  return PERIOD_M15;
      case PERIOD_M15: return PERIOD_M30;
      case PERIOD_M30: return PERIOD_H1;
      case PERIOD_H1:  return PERIOD_H4;
      case PERIOD_H4:  return PERIOD_D1;
      case PERIOD_D1:  return PERIOD_W1;
      default:         return PERIOD_H4;  // Default fallback
   }
}
//+------------------------------------------------------------------+
