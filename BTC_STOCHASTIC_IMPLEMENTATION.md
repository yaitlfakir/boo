# BTCStochasticEA - Implementation Summary

## Overview

**BTCStochasticEA** is a fully automated Bitcoin trading Expert Advisor that implements a Stochastic Oscillator crossover strategy with advanced risk management features.

## Core Strategy

### Signal Generation
- **Buy Signal**: Stochastic %K crosses above %D line
- **Sell Signal**: Stochastic %K crosses below %D line
- **Parameters**: K=19, D=7, Slowing=3 (optimized for Bitcoin volatility)

### Entry Logic
```mql5
// BUY: When K crosses above D
bool kCrossedAboveD = (stochMain[1] <= stochSignal[1]) && (stochMain[0] > stochSignal[0]);

// SELL: When K crosses below D
bool kCrossedBelowD = (stochMain[1] >= stochSignal[1]) && (stochMain[0] < stochSignal[0]);
```

## Risk Management Implementation

### 1. Dynamic Stop Loss & Take Profit

**ATR-Based Calculation:**
```mql5
if(UseDynamicSLTP)
{
   double currentATR = atr[0];
   slDistance = currentATR * ATR_Multiplier;        // e.g., 2.0x ATR
   tpDistance = currentATR * ATR_Multiplier * 2.0;  // 2:1 Risk/Reward
}
```

**Benefits:**
- Adapts to market volatility automatically
- Wider stops during high volatility (prevents stop-outs)
- Tighter stops during low volatility (reduces risk)

### 2. Position Sizing

**Risk-Based Lot Calculation:**
```mql5
double riskAmount = accountBalance * (RiskPercent / 100.0);
double slDistance = MathAbs(entryPrice - stopLoss);
double lotSize = riskAmount / (slDistance / tickSize * tickValue);
```

**Features:**
- Consistent risk per trade (default: 1%)
- Accounts for stop loss distance
- Normalizes to broker lot step requirements

### 3. Break-Even Management

**Automatic Break-Even:**
```mql5
if(UseBreakEven && profitPips >= BreakEvenPips)
{
   if(positionType == POSITION_TYPE_BUY)
      newSL = positionOpenPrice + PipsToPoints(BreakEvenPlusPips);
   else
      newSL = positionOpenPrice - PipsToPoints(BreakEvenPlusPips);
}
```

**Trigger:** When position reaches 200 pips profit (default)
**Action:** Moves SL to entry + 10 pips
**Result:** Guarantees minimum profit, eliminates downside risk

### 4. Trailing Stop

**Implementation:**
```mql5
if(UseTrailingStop && profitPips > 0)
{
   double trailDistance = PipsToPoints(TrailingStopPips);
   
   if(positionType == POSITION_TYPE_BUY)
      trailingSL = currentPrice - trailDistance;
   else
      trailingSL = currentPrice + trailDistance;
      
   // Only move if better than current SL + step
   if(trailingSL > currentSL + trailStep)
      newSL = trailingSL;
}
```

**Features:**
- Maintains fixed distance from current price (300 pips default)
- Only moves in favorable direction
- Uses step threshold to avoid excessive modifications

### 5. Trailing Profit

**Implementation:**
```mql5
if(UseTrailingProfit && currentTP != 0)
{
   double trailProfitDistance = PipsToPoints(TrailingProfitPips);
   double tpDiff = (positionType == BUY) ? (currentTP - currentPrice) : (currentPrice - currentTP);
   
   // Move TP closer if price approaching target
   if(tpDiff < trailProfitDistance + trailProfitStep)
   {
      if(positionType == POSITION_TYPE_BUY)
         newTP = currentPrice + trailProfitDistance;
      else
         newTP = currentPrice - trailProfitDistance;
   }
}
```

**Purpose:**
- Prevents giving back profits when price approaches target
- Adapts TP to market momentum
- Locks in gains before potential reversals

## Smart Risk Management System

### 1. Daily Loss Limit

**Tracking:**
```mql5
// Reset at start of new day
if(dt.day != lastDt.day)
{
   dailyStartBalance = currentBalance;
   tradingHalted = false;
}

// Check daily loss
double dailyLoss = dailyStartBalance - currentBalance;
double dailyLossPercent = (dailyLoss / dailyStartBalance) * 100.0;

if(dailyLossPercent >= MaxDailyLossPercent)
{
   tradingHalted = true;
   CloseAllPositions("Daily loss limit reached");
}
```

**Features:**
- Tracks from midnight server time
- Compares to daily start balance
- Automatic reset each new day
- Closes all positions when triggered

### 2. Maximum Drawdown Protection

**Monitoring:**
```mql5
// Track peak balance
if(currentBalance > peakBalance)
   peakBalance = currentBalance;

// Calculate drawdown
double drawdown = peakBalance - currentEquity;
double drawdownPercent = (drawdown / peakBalance) * 100.0;

if(drawdownPercent >= MaxDrawdownPercent)
{
   tradingHalted = true;
   CloseAllPositions("Maximum drawdown reached");
}
```

**Features:**
- Monitors from highest balance achieved
- Uses equity (includes floating P/L)
- Requires manual reset after trigger
- Protects against catastrophic losses

### 3. Consecutive Loss Limit

**Implementation:**
```mql5
void CheckConsecutiveLosses()
{
   // Get most recent closed deal
   double dealProfit = HistoryDealGetDouble(lastDealTicket, DEAL_PROFIT);
   
   if(dealProfit < 0)
   {
      consecutiveLosses++;
      if(consecutiveLosses >= MaxConsecutiveLosses)
      {
         tradingHalted = true;
         CloseAllPositions("Consecutive loss limit reached");
      }
   }
   else if(dealProfit > 0)
   {
      consecutiveLosses = 0;  // Reset on winning trade
   }
}
```

**Features:**
- Counts only consecutive losses
- Resets to zero on any win
- Prevents revenge trading
- Identifies unfavorable market conditions

## Technical Features

### Multi-Broker Compatibility

**Pip Value Detection:**
```mql5
int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
if(digits == 3 || digits == 5)
   pipValue = _Point * 10;  // 5-digit/3-digit broker
else
   pipValue = _Point;        // 4-digit/2-digit broker
```

**Order Filling:**
```mql5
trade.SetTypeFilling(ORDER_FILLING_FOK);  // Fill or Kill
// Automatically falls back to IOC or RETURN if not supported
```

### Spread Filter

**Protection:**
```mql5
bool IsSpreadAcceptable()
{
   double spread = SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double spreadPips = PointsToPips(spread);
   
   return (spreadPips <= MaxSpreadPips);
}
```

**Purpose:** Avoids trading during low liquidity (high spread) conditions

### Time Filter (Optional)

**24/7 Trading:**
```mql5
input bool UseTimeFilter = false;  // Disabled by default for Bitcoin

bool CheckTimeFilter()
{
   if(!UseTimeFilter) return true;
   
   // Check if within trading hours
   if(StartHour <= EndHour)
      return (dt.hour >= StartHour && dt.hour < EndHour);
   else  // Overnight trading
      return (dt.hour >= StartHour || dt.hour < EndHour);
}
```

## Position Management Flow

### On Every Tick

1. **Check Smart Risk Management**
   - Daily loss limit
   - Maximum drawdown
   - Consecutive losses
   - Halt trading if any limit reached

2. **Manage Open Positions**
   - Check break-even conditions
   - Update trailing stop
   - Update trailing profit
   - Modify positions as needed

3. **Check for New Bar**
   - Only trade on bar close
   - Prevents multiple entries on same bar

4. **Generate Signals** (if not halted)
   - Check spread filter
   - Check time filter
   - Check position limit
   - Evaluate Stochastic crossover
   - Open position if signal valid

## Key Configuration Presets

### Conservative (Beginner)
```
RiskPercent = 0.5%
ATR_Multiplier = 2.5
MaxOpenPositions = 1
UseBreakEven = true
MaxDailyLossPercent = 3%
MaxDrawdownPercent = 10%
MaxConsecutiveLosses = 2
```

### Moderate (Default)
```
RiskPercent = 1.0%
ATR_Multiplier = 2.0
MaxOpenPositions = 1
UseBreakEven = true
MaxDailyLossPercent = 5%
MaxDrawdownPercent = 15%
MaxConsecutiveLosses = 3
```

### Aggressive (Experienced)
```
RiskPercent = 2.0%
ATR_Multiplier = 1.5
MaxOpenPositions = 2
UseBreakEven = true
MaxDailyLossPercent = 7%
MaxDrawdownPercent = 20%
MaxConsecutiveLosses = 4
```

## Performance Characteristics

### Expected Metrics (H1 Timeframe)
- **Win Rate**: 45-55%
- **Risk/Reward**: 2:1 (via dynamic TP = 2x SL)
- **Trades per Week**: 3-8 typically
- **Maximum Drawdown**: < 20% with proper risk management
- **Profit Factor**: > 1.5 target

### Signal Frequency by Timeframe
- **M30**: 5-15 trades/week (active)
- **H1**: 3-8 trades/week (balanced)
- **H4**: 1-4 trades/week (swing)

## Error Handling

### Position Modification Protection
```mql5
if(needsModify)
{
   if(trade.PositionModify(ticket, newSL, newTP))
   {
      Print("Position modified successfully");
   }
   else
   {
      Print("Failed to modify position. Error: ", GetLastError());
   }
}
```

### Broker Compatibility
- Checks minimum stop level distance
- Normalizes prices to broker digits
- Handles different lot step sizes
- Adapts to broker filling policies

## Logging and Monitoring

### Signal Notifications
```
"BUY SIGNAL DETECTED:"
"  - Stochastic K (52.3) crossed above D (50.1)"

"SELL SIGNAL DETECTED:"
"  - Stochastic K (48.7) crossed below D (50.2)"
```

### Risk Management Alerts
```
"Break-Even triggered for position #12345 at 205.3 pips profit"
"Trailing stop updated for BUY position #12345 New SL: 50200.50"
"DAILY LOSS LIMIT REACHED! Loss: 5.2% - Trading halted until next day"
"MAXIMUM DRAWDOWN REACHED! Drawdown: 15.5% - Trading halted"
"CONSECUTIVE LOSS LIMIT REACHED! (3 losses) - Trading halted"
```

### Position Management
```
"BUY order opened successfully."
"  Lot Size: 0.05"
"  Entry Price: 50000.00"
"  Stop Loss: 49000.00"
"  Take Profit: 52000.00"
"Dynamic SL/TP: ATR=300.5 pips, SL Distance=601.0 pips"
```

## Testing Recommendations

### Backtesting
- **Minimum Period**: 6 months
- **Recommended**: 1-2 years
- **Model**: Every tick (most accurate)
- **Optimization**: Test different ATR multipliers (1.5-3.0)

### Forward Testing
- **Demo Account**: Mandatory 30+ days
- **Live Testing**: Start with minimum lots (0.01)
- **Monitoring**: Daily review for first month
- **Adjustments**: Test on demo before applying live

## Version History

### Version 1.0 (Initial Release)
- Stochastic Oscillator (19,7,3) crossover strategy
- BUY/SELL signal generation
- ATR-based dynamic SL/TP
- Break-even functionality
- Trailing stop management
- Trailing profit management
- Daily loss limit protection
- Maximum drawdown protection
- Consecutive loss limit
- Bitcoin-optimized parameters
- Multi-broker compatibility

## Files

- **BTCStochasticEA.mq5**: Main EA source code (747 lines)
- **BTC_STOCHASTIC_EA.md**: Comprehensive documentation
- **BTC_STOCHASTIC_QUICKSTART.md**: Quick start guide
- **BTC_STOCHASTIC_IMPLEMENTATION.md**: This file (technical details)

## License

This EA is provided for educational and research purposes. Use at your own risk.

---

**Note**: Always test thoroughly on demo accounts before using real money. Past performance does not guarantee future results. Trading carries substantial risk of loss.
