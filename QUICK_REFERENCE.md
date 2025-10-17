# MultiTimeframeSignalEA - Quick Reference Card

## Signal Conditions Summary

### 📈 BUY SIGNAL (Green Arrow ↑ Below Bar)

All conditions must be TRUE simultaneously:

| Timeframe | Condition 1 | Condition 2 | Condition 3 |
|-----------|-------------|-------------|-------------|
| **M1** (1-min) | Stochastic Main < 30 | Stochastic Main < Signal | MA(3) > MA(9) |
| **M5** (5-min) | Stochastic Main < Signal | MA(3) > MA(9) | — |
| **M15** (15-min) | MA(3) > MA(9) | — | — |

**Stochastic Parameters:**
- M1: %K=19, %D=7, Slowing=1
- M5: %K=19, %D=3, Slowing=1

**Moving Averages:**
- Type: Simple Moving Average (SMA)
- Periods: 3 and 9
- Applied to: Close price

---

### 📉 SELL SIGNAL (Red Arrow ↓ Above Bar)

All conditions must be TRUE simultaneously:

| Timeframe | Condition 1 | Condition 2 | Condition 3 |
|-----------|-------------|-------------|-------------|
| **M1** (1-min) | Stochastic Main > 50 | Stochastic Main > Signal | MA(3) < MA(9) |
| **M5** (5-min) | Stochastic Main > Signal | MA(3) < MA(9) | — |
| **M15** (15-min) | MA(3) < MA(9) | — | — |

**Stochastic Parameters:**
- M1: %K=19, %D=7, Slowing=1
- M5: %K=19, %D=3, Slowing=1

**Moving Averages:**
- Type: Simple Moving Average (SMA)
- Periods: 3 and 9
- Applied to: Close price

---

## Trading Interpretation

### BUY Signal Interpretation
- **M1**: Oversold momentum (Stoch < 30) with bullish MA crossover
- **M5**: Bullish momentum confirmation with MA alignment
- **M15**: Trend confirmation (bullish MA alignment)

**What it means:** Strong multi-timeframe alignment for potential upward move

### SELL Signal Interpretation
- **M1**: Overbought momentum (Stoch > 50) with bearish MA crossover
- **M5**: Bearish momentum confirmation with MA alignment
- **M15**: Trend confirmation (bearish MA alignment)

**What it means:** Strong multi-timeframe alignment for potential downward move

---

## Key Features

✅ Multi-timeframe confluence (M1 + M5 + M15)
✅ Momentum filter (Stochastic Oscillator)
✅ Trend filter (Moving Average crossover)
✅ Visual signals (Colored arrows on chart)
✅ Alert system (Audio + Push + Email)

---

## Important Notes

⚠️ **Signal Frequency:** Signals may be rare due to strict multi-timeframe requirements

⚠️ **Not Trading Advice:** Signals are for informational purposes only

⚠️ **Verification:** Always verify signals with your own analysis

⚠️ **Demo First:** Test thoroughly on demo account before any live use

⚠️ **No Automation:** This EA does NOT place trades automatically

---

## Input Parameters

### Signal Display
- `BuyArrowColor`: Color of buy arrows (default: Lime)
- `SellArrowColor`: Color of sell arrows (default: Red)
- `ArrowSize`: Arrow width 1-5 (default: 2)

### Alerts
- `EnableAlerts`: Audio alerts (default: true)
- `EnableVisualAlerts`: Push notifications (default: true)
- `EnableEmailAlerts`: Email notifications (default: false)

---

## Quick Setup

1. Copy `MultiTimeframeSignalEA.mq5` to `MQL5/Experts/` folder
2. Compile in MetaEditor (F7)
3. Attach to any chart
4. Enable Auto Trading (Alt+A)
5. Wait for signals!

---

## Verification Steps

To manually verify a signal, check indicators on each timeframe:

### For BUY Signal:
1. **On M1 chart:** Add Stochastic(19,7,1) + MA(3) + MA(9)
2. **On M5 chart:** Add Stochastic(19,3,1) + MA(3) + MA(9)
3. **On M15 chart:** Add MA(3) + MA(9)
4. Verify all conditions match the table above

### For SELL Signal:
Same steps, but verify against SELL conditions

---

## Support

- Full Documentation: `MULTITIMEFRAME_SIGNAL_EA.md`
- Testing Guide: `TESTING_GUIDE.md`
- Main README: `README.md`

---

## Version
**Version:** 1.00  
**Date:** 2025-10-17  
**Status:** Production Ready  
**License:** Educational/Research Use
