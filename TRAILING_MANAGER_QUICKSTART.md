# TrailingManager EA - Quick Start Guide

## What is TrailingManager?

TrailingManager is a **complete automated trading solution** that combines:
1. **Automatic Position Opening** - Opens trades based on EMA crossover and RSI signals
2. **Position Management** - Manages stop loss, take profit, break-even, and trailing stops
3. **Risk Management** - Controls daily losses, position limits, and position sizing

Unlike the ScalpingEA which is just for scalping, TrailingManager can open positions **and** manage them comprehensively with advanced trailing features.

## Key Differences from Other EAs

| Feature | ScalpingEA | MultiTimeframeSignalEA | TrailingManager |
|---------|------------|------------------------|-----------------|
| Auto Trading | ✓ Yes | ✗ No (signals only) | ✓ Yes |
| Trailing Stop | ✓ Basic | ✗ No | ✓ Advanced |
| Break-Even | ✗ No | ✗ No | ✓ Yes |
| Trailing TP | ✗ No | ✗ No | ✓ Yes |
| Daily Loss Limit | ✗ No | ✗ No | ✓ Yes |
| Position Limit | ✓ One at a time | N/A | ✓ Configurable |
| Risk per Trade | ✓ Yes | N/A | ✓ Yes |

## Installation in 3 Steps

1. **Copy the file**: Place `TrailingManager.mq5` in `MetaTrader 5/MQL5/Experts/`
2. **Compile**: Open MetaEditor and compile (F7)
3. **Attach**: Drag EA to a chart (EURUSD M5 recommended)

## Recommended Settings for Beginners

### Conservative Setup (Start Here!)
```
[Position Management]
InpMagicNumber = 0
InpOnlyThisSymbol = true

[Auto Trading]
InpAutoTrade = true
InpFastEMA_Period = 5
InpSlowEMA_Period = 20
InpRSI_Period = 14

[Risk Management]
InpRiskPercent = 0.5%          ← Start with 0.5% risk
InpMaxOpenPositions = 2        ← Only 2 positions max
InpMaxDailyLossPercent = 3.0%  ← Stop if lose 3% in a day
InpMaxSpreadPips = 2.0

[Trading Hours]
InpUseTimeFilter = true
InpStartHour = 8
InpEndHour = 20

[Initial SL/TP]
InpInitialSL_Points = 150
InpInitialTP_Points = 250

[Break-Even]
InpUseBreakEven = true
InpBE_Trigger_Points = 300     ← Move to BE after 30 pips profit
InpBE_Offset_Points = 20

[Trailing Stop]
InpUseTrailingStop = true
InpTS_Trigger_Points = 400
InpTS_Distance_Points = 150
InpTS_Step_Points = 20
```

## How It Works - Step by Step

### 1. Signal Detection (Every New Bar)
- Checks if Fast EMA crosses Slow EMA
- Confirms with RSI (oversold for buy, overbought for sell)
- Verifies spread is acceptable
- Checks if within trading hours
- Ensures position and daily loss limits not exceeded

### 2. Position Opening
- Calculates lot size based on risk percentage and stop loss
- Opens position with initial SL and TP
- Logs the action to Experts tab

### 3. Position Management (Every Tick)
For each open position:

**Stage 1 - Initial Protection**
- If no SL set, adds initial stop loss
- If no TP set, adds initial take profit

**Stage 2 - Break-Even (after 30-50 pips profit)**
- Moves stop loss to entry price + small offset
- Locks in zero-loss position

**Stage 3 - Trailing Stop (after 40-60 pips profit)**
- Stop loss follows price at configured distance
- Only moves in favorable direction
- Never loosens

**Stage 4 - Trailing Take-Profit**
- Keeps take profit target ahead of price
- Adjusts as price moves favorably
- Maximizes profit potential

### 4. Risk Protection
- **Daily Loss Limit**: Stops opening new positions if daily loss exceeds limit
- **Position Limit**: Prevents overexposure by limiting concurrent positions
- **Position Sizing**: Automatically calculates safe lot size based on account and risk

## Quick Test (5 Minutes)

1. **Attach to Chart**: Drag TrailingManager to EURUSD M5
2. **Enable AutoTrading**: Click AutoTrading button (or Alt+A)
3. **Check Initialization**: Look for "TrailingManager initialized successfully" in Experts tab
4. **Wait for Signal**: Can take minutes to hours depending on market
5. **Monitor**: Watch Experts tab for actions

## Understanding the Logs

The EA logs everything to the Experts tab:

```
2024.10.18 12:00:00   TrailingManager initialized successfully
2024.10.18 12:00:00   Auto Trading: Enabled
2024.10.18 12:05:00   BUY opened: Lot=0.10, Price=1.10500, SL=1.10350, TP=1.10750
2024.10.18 12:10:00   Modified #12345678 | BUY | SL: 1.10350 -> 1.10520 | TP: 1.10750 -> 1.10750
```

**What these mean:**
- **"initialized successfully"** - EA is ready
- **"BUY opened"** - New position created
- **"Modified"** - SL or TP adjusted (break-even or trailing)
- **"Daily loss limit exceeded"** - No new trades today (protective)

## Safety Features

### 1. Daily Loss Limit
If you lose 3-5% of your starting balance in a day:
- ✅ Existing positions continue to be managed
- ❌ No new positions opened until tomorrow
- 🔄 Resets automatically at start of new day

### 2. Maximum Positions
Can't open more than configured number (default: 2-3):
- Prevents overexposure during volatile markets
- Reduces correlation risk
- Limits capital at risk

### 3. Broker Safety
- Respects broker's minimum stop level
- Honors freeze level
- Throttles modifications (doesn't spam broker)

## Troubleshooting

### "No positions opening"
**Check:**
- [ ] AutoTrading enabled (green button in toolbar)
- [ ] InpAutoTrade = true in settings
- [ ] Spread not too high
- [ ] Within trading hours
- [ ] Daily loss limit not exceeded
- [ ] Max positions not reached
- [ ] Wait for EMA crossover (can take time)

### "Daily loss limit exceeded"
**Solution:**
- This is **protective** - you lost enough today
- Wait until tomorrow
- Review your settings (maybe too aggressive)
- Check if stop losses are too tight

### "Invalid lot size"
**Fix:**
- Reduce InpRiskPercent (try 0.5% or 0.25%)
- Check account balance is sufficient
- Verify broker minimum lot size

### "Modify failed"
**Usually means:**
- Stop level too close to current price
- Market is frozen
- Connection issue
- This is normal occasionally, EA will retry

## Next Steps

### After Testing on Demo (1-2 weeks):
1. **Review Results**:
   - How many positions opened?
   - What was the win rate?
   - Did break-even and trailing work?
   - Any errors in Experts tab?

2. **Optimize Settings**:
   - Adjust EMA periods for your symbol
   - Fine-tune break-even trigger
   - Adjust trailing distance
   - Test different risk percentages

3. **Go Live** (if satisfied):
   - Start with minimum settings
   - Use conservative risk (0.5%)
   - Monitor closely for first week

## Pro Tips

1. **Start Conservative**: Better to make small gains than big losses
2. **Monitor Daily**: Check at least once per day
3. **Review Weekly**: Analyze what worked and what didn't
4. **Adjust Gradually**: Change one parameter at a time
5. **Use VPS**: For 24/7 operation without interruptions
6. **Diversify**: Run on multiple uncorrelated pairs
7. **Keep Learning**: Study why trades won/lost

## Risk Warning

⚠️ **IMPORTANT**:
- Trading is risky - you can lose money
- Start with demo account
- Never risk more than you can afford to lose
- This EA is a tool, not a guarantee
- Past performance ≠ future results
- Always monitor your positions

## Support

For issues or questions:
- Check Experts tab for error messages
- Review this guide and main documentation
- Test on demo before live trading
- Read TRAILING_MANAGER.md for detailed info

## Summary

TrailingManager is your **complete trading assistant**:
- 🎯 Opens positions automatically when conditions align
- 🛡️ Protects capital with multiple safety features
- 📈 Maximizes profits with advanced trailing
- ⚙️ Fully configurable to match your risk tolerance
- 🔍 Transparent with detailed logging

**Remember**: Start small, test thoroughly, and scale up gradually as you gain confidence! 🚀
