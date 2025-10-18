//+------------------------------------------------------------------+
//|                                                TrailingManager.mq5
//|                            Simple, safe SL/TP/BE/Trailing manager
//|                                        with Automatic Trading
//+------------------------------------------------------------------+
#property copyright "TrailingManager"
#property version   "2.00"
#property description "Automated trading with comprehensive trailing stop management"
#property strict

#include <Trade/Trade.mqh>
CTrade Trade;

//---------------------------- Inputs --------------------------------
input group "=== Position Management ==="
input long   InpMagicNumber        = 0;          // Manage only this Magic (0 = any)
input bool   InpOnlyThisSymbol     = true;       // Manage only current chart symbol

input group "=== Auto Trading Parameters ==="
input bool   InpAutoTrade          = true;       // Enable Automatic Trading
input int    InpFastEMA_Period     = 5;          // Fast EMA Period
input int    InpSlowEMA_Period     = 20;         // Slow EMA Period
input int    InpRSI_Period         = 14;         // RSI Period
input int    InpRSI_Oversold       = 30;         // RSI Oversold Level
input int    InpRSI_Overbought     = 70;         // RSI Overbought Level

input group "=== Risk Management ==="
input double InpRiskPercent        = 1.0;        // Risk Per Trade (% of balance)
input int    InpMaxOpenPositions   = 3;          // Maximum Open Positions
input double InpMaxDailyLossPercent= 5.0;        // Max Daily Loss (% of balance)
input double InpMaxSpreadPips      = 2.0;        // Maximum Spread (pips)

input group "=== Trading Hours ==="
input bool   InpUseTimeFilter      = true;       // Use Time Filter
input int    InpStartHour          = 8;          // Start Trading Hour
input int    InpEndHour            = 20;         // End Trading Hour

input group "=== Initial SL/TP Placement ==="
input int    InpInitialSL_Points   = 150;        // Initial SL (points) [0=skip]
input int    InpInitialTP_Points   = 250;        // Initial TP (points) [0=skip]

input group "=== Break-Even Settings ==="
input bool   InpUseBreakEven       = true;       // Enable Break-Even
input int    InpBE_Trigger_Points  = 500;        // When profit reaches (points)
input int    InpBE_Offset_Points   = 20;         // Offset beyond entry (points)

input group "=== Trailing Stop Settings ==="
input bool   InpUseTrailingStop    = true;       // Enable trailing stop
input int    InpTS_Trigger_Points  = 600;        // Start trailing after profit (points)
input int    InpTS_Distance_Points = 150;        // Distance from current price (points)
input int    InpTS_Step_Points     = 20;         // Update step (points)

input group "=== Trailing Take-Profit Settings ==="
input bool   InpUseTrailingTP      = true;       // Enable trailing TP
input int    InpTTP_Distance_Points= 2000;       // TP distance ahead of price (points)
input int    InpTTP_Step_Points    = 20;         // Update step (points)

input group "=== Misc Settings ==="
input int    InpModifyThrottleMs   = 100;        // Min ms between modifications per position
input bool   InpLogActions         = true;       // Log actions to Experts tab
//----------------------------------------------------------------------

struct LastModInfo {
  ulong ticket;
  ulong last_ms;
};
LastModInfo lastMods[100];
int lastModsCount = 0;

//--- Indicator handles and buffers
int handleFastEMA;
int handleSlowEMA;
int handleRSI;
double fastEMA[];
double slowEMA[];
double rsi[];
datetime lastBarTime = 0;

//--- Daily loss tracking
double dailyStartBalance = 0;
datetime lastResetDate = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
  lastModsCount = 0;
  
  // Initialize indicators for auto trading
  if(InpAutoTrade)
  {
    handleFastEMA = iMA(_Symbol, PERIOD_CURRENT, InpFastEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
    handleSlowEMA = iMA(_Symbol, PERIOD_CURRENT, InpSlowEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
    handleRSI = iRSI(_Symbol, PERIOD_CURRENT, InpRSI_Period, PRICE_CLOSE);
    
    if(handleFastEMA == INVALID_HANDLE || handleSlowEMA == INVALID_HANDLE || handleRSI == INVALID_HANDLE)
    {
      Print("Error creating indicators");
      return(INIT_FAILED);
    }
    
    ArraySetAsSeries(fastEMA, true);
    ArraySetAsSeries(slowEMA, true);
    ArraySetAsSeries(rsi, true);
  }
  
  // Initialize daily tracking
  dailyStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
  lastResetDate = TimeCurrent();
  
  Print("TrailingManager initialized successfully");
  Print("Auto Trading: ", InpAutoTrade ? "Enabled" : "Disabled");
  
  return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  if(InpAutoTrade)
  {
    if(handleFastEMA != INVALID_HANDLE) IndicatorRelease(handleFastEMA);
    if(handleSlowEMA != INVALID_HANDLE) IndicatorRelease(handleSlowEMA);
    if(handleRSI != INVALID_HANDLE) IndicatorRelease(handleRSI);
  }
  
  Print("TrailingManager deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  const string sym = _Symbol;
  const double point = SymbolInfoDouble(sym, SYMBOL_POINT);
  const int digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);

  // Check and reset daily loss tracking
  CheckDailyReset();
  
  // Check if daily loss limit exceeded
  if(IsDailyLossLimitExceeded())
  {
    if(InpLogActions)
      Print("Daily loss limit exceeded. No new trades today.");
    // Still manage existing positions
    ManageExistingPositions(sym, point, digits);
    return;
  }
  
  // Auto trading logic (new position opening)
  if(InpAutoTrade)
  {
    datetime currentBarTime = iTime(sym, PERIOD_CURRENT, 0);
    if(currentBarTime != lastBarTime)
    {
      lastBarTime = currentBarTime;
      
      // Check if we can open new positions
      if(CanOpenNewPosition())
      {
        // Copy indicator data
        if(CopyBuffer(handleFastEMA, 0, 0, 3, fastEMA) >= 3 &&
           CopyBuffer(handleSlowEMA, 0, 0, 3, slowEMA) >= 3 &&
           CopyBuffer(handleRSI, 0, 0, 3, rsi) >= 3)
        {
          int signal = GetTradingSignal();
          
          if(signal == 1)
            OpenBuyPosition(sym, point, digits);
          else if(signal == -1)
            OpenSellPosition(sym, point, digits);
        }
      }
    }
  }
  
  // Manage existing positions (trailing, BE, etc.)
  ManageExistingPositions(sym, point, digits);
}

//+------------------------------------------------------------------+
//| Check and reset daily loss tracking                             |
//+------------------------------------------------------------------+
void CheckDailyReset()
{
  MqlDateTime currentTime, lastTime;
  TimeToStruct(TimeCurrent(), currentTime);
  TimeToStruct(lastResetDate, lastTime);
  
  // Reset at start of new day
  if(currentTime.day != lastTime.day || currentTime.mon != lastTime.mon || currentTime.year != lastTime.year)
  {
    dailyStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    lastResetDate = TimeCurrent();
    if(InpLogActions)
      Print("Daily tracking reset. Starting balance: ", dailyStartBalance);
  }
}

//+------------------------------------------------------------------+
//| Check if daily loss limit is exceeded                           |
//+------------------------------------------------------------------+
bool IsDailyLossLimitExceeded()
{
  double currentBalance = AccountInfoDouble(ACCOUNT_BALANCE);
  double dailyLoss = dailyStartBalance - currentBalance;
  double maxLoss = dailyStartBalance * InpMaxDailyLossPercent / 100.0;
  
  return (dailyLoss >= maxLoss);
}

//+------------------------------------------------------------------+
//| Check if can open new position                                   |
//+------------------------------------------------------------------+
bool CanOpenNewPosition()
{
  // Check max positions
  int currentPositions = CountManagedPositions();
  if(currentPositions >= InpMaxOpenPositions)
    return false;
  
  // Check spread
  if(!IsSpreadAcceptable())
    return false;
  
  // Check trading hours
  if(InpUseTimeFilter && !IsWithinTradingHours())
    return false;
  
  return true;
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
    
    if(InpOnlyThisSymbol && psym != _Symbol) continue;
    if(InpMagicNumber != 0 && magic != InpMagicNumber) continue;
    
    count++;
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
  
  double spreadPips = (ask - bid) / (10 * point);
  
  return (spreadPips <= InpMaxSpreadPips);
}

//+------------------------------------------------------------------+
//| Check if within trading hours                                    |
//+------------------------------------------------------------------+
bool IsWithinTradingHours()
{
  MqlDateTime time;
  TimeToStruct(TimeCurrent(), time);
  
  return (time.hour >= InpStartHour && time.hour < InpEndHour);
}

//+------------------------------------------------------------------+
//| Get trading signal                                               |
//+------------------------------------------------------------------+
int GetTradingSignal()
{
  // Buy signal: Fast EMA crosses above Slow EMA and RSI is oversold
  if(fastEMA[1] > slowEMA[1] && fastEMA[2] <= slowEMA[2] && rsi[1] < InpRSI_Oversold + 10)
    return 1;
  
  // Sell signal: Fast EMA crosses below Slow EMA and RSI is overbought
  if(fastEMA[1] < slowEMA[1] && fastEMA[2] >= slowEMA[2] && rsi[1] > InpRSI_Overbought - 10)
    return -1;
  
  return 0;
}

//+------------------------------------------------------------------+
//| Open Buy Position                                                |
//+------------------------------------------------------------------+
void OpenBuyPosition(string sym, double point, int digits)
{
  double ask = SymbolInfoDouble(sym, SYMBOL_ASK);
  double lotSize = CalculateLotSize(sym, InpInitialSL_Points * point);
  
  double sl = 0;
  double tp = 0;
  
  if(InpInitialSL_Points > 0)
    sl = NormalizeDouble(ask - InpInitialSL_Points * point, digits);
  
  if(InpInitialTP_Points > 0)
    tp = NormalizeDouble(ask + InpInitialTP_Points * point, digits);
  
  Trade.SetExpertMagicNumber(InpMagicNumber);
  Trade.SetAsyncMode(false);
  
  if(Trade.Buy(lotSize, sym, ask, sl, tp, "TrailMgr"))
  {
    if(InpLogActions)
      PrintFormat("BUY opened: Lot=%.2f, Price=%.5f, SL=%.5f, TP=%.5f", 
                  lotSize, ask, sl, tp);
  }
  else
  {
    if(InpLogActions)
      PrintFormat("BUY failed: Error=%d", GetLastError());
  }
}

//+------------------------------------------------------------------+
//| Open Sell Position                                               |
//+------------------------------------------------------------------+
void OpenSellPosition(string sym, double point, int digits)
{
  double bid = SymbolInfoDouble(sym, SYMBOL_BID);
  double lotSize = CalculateLotSize(sym, InpInitialSL_Points * point);
  
  double sl = 0;
  double tp = 0;
  
  if(InpInitialSL_Points > 0)
    sl = NormalizeDouble(bid + InpInitialSL_Points * point, digits);
  
  if(InpInitialTP_Points > 0)
    tp = NormalizeDouble(bid - InpInitialTP_Points * point, digits);
  
  Trade.SetExpertMagicNumber(InpMagicNumber);
  Trade.SetAsyncMode(false);
  
  if(Trade.Sell(lotSize, sym, bid, sl, tp, "TrailMgr"))
  {
    if(InpLogActions)
      PrintFormat("SELL opened: Lot=%.2f, Price=%.5f, SL=%.5f, TP=%.5f", 
                  lotSize, bid, sl, tp);
  }
  else
  {
    if(InpLogActions)
      PrintFormat("SELL failed: Error=%d", GetLastError());
  }
}

//+------------------------------------------------------------------+
//| Calculate lot size based on risk                                |
//+------------------------------------------------------------------+
double CalculateLotSize(string sym, double stopLossDistance)
{
  double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
  double riskAmount = accountBalance * InpRiskPercent / 100.0;
  
  double tickValue = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
  double tickSize = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
  double point = SymbolInfoDouble(sym, SYMBOL_POINT);
  
  if(stopLossDistance == 0)
    stopLossDistance = 150 * point; // Default
  
  double stopLossPoints = stopLossDistance / point;
  
  if(stopLossPoints == 0)
    return SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
  
  double lotSize = riskAmount / (stopLossPoints * tickValue / tickSize);
  
  // Normalize lot size
  double lotStep = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
  lotSize = MathFloor(lotSize / lotStep) * lotStep;
  
  // Apply limits
  double minLot = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
  double maxLot = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
  
  if(lotSize < minLot) lotSize = minLot;
  if(lotSize > maxLot) lotSize = maxLot;
  
  return NormalizeDouble(lotSize, 2);
}

//+------------------------------------------------------------------+
//| Manage existing positions                                        |
//+------------------------------------------------------------------+
void ManageExistingPositions(string sym, double point, int digits)
{
  // broker constraints
  int stopsLevelPoints = (int)SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL);
  int freezeLevelPoints= (int)SymbolInfoInteger(sym, SYMBOL_TRADE_FREEZE_LEVEL);

  int total = PositionsTotal();
  for(int i=0; i<total; i++)
  {
    ulong ticket = PositionGetTicket(i);
    if(!PositionSelectByTicket(ticket)) continue;

    string psym      = PositionGetString(POSITION_SYMBOL);
    long   magic     = PositionGetInteger(POSITION_MAGIC);
    int    type      = (int)PositionGetInteger(POSITION_TYPE); // 0=BUY,1=SELL
    double volume    = PositionGetDouble(POSITION_VOLUME);
    double priceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
    double sl        = PositionGetDouble(POSITION_SL);
    double tp        = PositionGetDouble(POSITION_TP);

    if(volume <= 0) continue;
    if(InpOnlyThisSymbol && psym != sym) continue;
    if(InpMagicNumber != 0 && magic != InpMagicNumber) continue;

    double bid = SymbolInfoDouble(psym, SYMBOL_BID);
    double ask = SymbolInfoDouble(psym, SYMBOL_ASK);
    double priceNow = (type==POSITION_TYPE_BUY) ? bid : ask;

    // --- Initial SL/TP placement if missing ---
    double newSL = sl;
    double newTP = tp;

    if(InpInitialSL_Points > 0 && sl <= 0.0)
    {
      if(type==POSITION_TYPE_BUY)
        newSL = NormalizeDouble(priceOpen - InpInitialSL_Points*point, digits);
      else
        newSL = NormalizeDouble(priceOpen + InpInitialSL_Points*point, digits);
    }

    if(InpInitialTP_Points > 0 && tp <= 0.0)
    {
      if(type==POSITION_TYPE_BUY)
        newTP = NormalizeDouble(priceOpen + InpInitialTP_Points*point, digits);
      else
        newTP = NormalizeDouble(priceOpen - InpInitialTP_Points*point, digits);
    }

    // --- Break-Even logic ---
    if(InpUseBreakEven)
    {
      double profitPoints = (type==POSITION_TYPE_BUY)
                            ? (priceNow - priceOpen)/point
                            : (priceOpen - priceNow)/point;

      if(profitPoints >= InpBE_Trigger_Points)
      {
        double bePrice = (type==POSITION_TYPE_BUY)
                         ? priceOpen + InpBE_Offset_Points*point
                         : priceOpen - InpBE_Offset_Points*point;

        // Only move SL forward (never loosen)
        if(type==POSITION_TYPE_BUY)
        {
          if(newSL<=0.0 || bePrice>newSL)
            newSL = NormalizeDouble(bePrice, digits);
        }
        else
        {
          if(newSL<=0.0 || bePrice<newSL)
            newSL = NormalizeDouble(bePrice, digits);
        }
      }
    }

    // --- Trailing Stop logic ---
    if(InpUseTrailingStop)
    {
      double profitPoints = (type==POSITION_TYPE_BUY)
                            ? (priceNow - priceOpen)/point
                            : (priceOpen - priceNow)/point;

      if(profitPoints >= InpTS_Trigger_Points)
      {
        double trailPrice = (type==POSITION_TYPE_BUY)
                            ? priceNow - InpTS_Distance_Points*point
                            : priceNow + InpTS_Distance_Points*point;

        // step check (avoid micro-mods)
        bool passStep = false;
        if(newSL<=0.0) passStep = true;
        else
        {
          double diffPts = MathAbs((trailPrice - newSL)/point);
          passStep = (diffPts >= InpTS_Step_Points);
        }

        if(passStep)
        {
          if(type==POSITION_TYPE_BUY)
          {
            if(newSL<=0.0 || trailPrice>newSL)
              newSL = NormalizeDouble(trailPrice, digits);
          }
          else
          {
            if(newSL<=0.0 || trailPrice<newSL)
              newSL = NormalizeDouble(trailPrice, digits);
          }
        }
      }
    }

    // --- Trailing Take-Profit logic ---
    if(InpUseTrailingTP)
    {
      double desiredTP = (type==POSITION_TYPE_BUY)
                         ? priceNow + InpTTP_Distance_Points*point
                         : priceNow - InpTTP_Distance_Points*point;

      bool passStepTP = false;
      if(tp<=0.0) passStepTP = true;
      else
      {
        double diffPtsTP = MathAbs((desiredTP - tp)/point);
        passStepTP = (diffPtsTP >= InpTTP_Step_Points);
      }

      if(passStepTP)
      {
        // Only move TP further into profit (never closer)
        if(type==POSITION_TYPE_BUY)
        {
          if(tp<=0.0 || desiredTP>tp)
            newTP = NormalizeDouble(desiredTP, digits);
        }
        else
        {
          if(tp<=0.0 || desiredTP<tp)
            newTP = NormalizeDouble(desiredTP, digits);
        }
      }
    }

    // --- Broker safety checks: stops/freeze levels ---
    int minDistPts = (int)MathMax(stopsLevelPoints, freezeLevelPoints);
    double minDist = minDistPts * point;

    // Ensure SL/TP are at least min distance from current opposite quote
    if(newSL>0.0)
    {
      if(type==POSITION_TYPE_BUY)
      {
        // SL must be below Bid by minDist
        if((bid - newSL) < minDist) newSL = NormalizeDouble(bid - minDist, digits);
      }
      else
      {
        // SL must be above Ask by minDist
        if((newSL - ask) < minDist) newSL = NormalizeDouble(ask + minDist, digits);
      }
    }

    if(newTP>0.0)
    {
      if(type==POSITION_TYPE_BUY)
      {
        // TP must be above Ask by minDist
        if((newTP - ask) < minDist) newTP = NormalizeDouble(ask + minDist, digits);
      }
      else
      {
        // TP must be below Bid by minDist
        if((bid - newTP) < minDist) newTP = NormalizeDouble(bid - minDist, digits);
      }
    }

    // --- Only modify if something actually changed and we're past throttle ---
    bool needModify = (AlmostDiff(newSL, sl, point) || AlmostDiff(newTP, tp, point));
    if(!needModify) continue;

    if(!PassThrottle(ticket, InpModifyThrottleMs)) continue;

    Trade.SetExpertMagicNumber(magic);
    Trade.SetAsyncMode(false);

    bool ok = Trade.PositionModify(ticket, newSL, newTP);
    if(ok)
    {
      StampThrottle(ticket);
      if(InpLogActions)
        PrintFormat("Modified #%I64u | %s | SL: %.5f -> %.5f | TP: %.5f -> %.5f",
                    ticket, (type==POSITION_TYPE_BUY?"BUY":"SELL"),
                    sl, newSL, tp, newTP);
    }
    else
    {
      int err = (int)GetLastError();
      if(InpLogActions)
        PrintFormat("Modify FAILED #%I64u err=%d | tried SL=%.5f TP=%.5f",
                    ticket, err, newSL, newTP);
      ResetLastError();
    }
  }
}

//+------------------------------------------------------------------+
//| Helpers                                                          |
//+------------------------------------------------------------------+
bool AlmostDiff(double a, double b, double point)
{
  if(a<=0.0 && b<=0.0) return false;
  return (MathAbs(a-b) >= (0.5*point)); // consider as changed if >= half point
}

bool PassThrottle(ulong ticket, int minMs)
{
  ulong now = GetTickCount64();
  for(int i=0;i<lastModsCount;i++)
  {
    if(lastMods[i].ticket==ticket)
      return (now - lastMods[i].last_ms) >= (ulong)minMs;
  }
  return true;
}

void StampThrottle(ulong ticket)
{
  ulong now = GetTickCount64();
  for(int i=0;i<lastModsCount;i++)
  {
    if(lastMods[i].ticket==ticket)
    {
      lastMods[i].last_ms = now;
      return;
    }
  }
  if(lastModsCount < ArraySize(lastMods))
  {
    lastMods[lastModsCount].ticket = ticket;
    lastMods[lastModsCount].last_ms = now;
    lastModsCount++;
  }
}
//+------------------------------------------------------------------+
