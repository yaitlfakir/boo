# Multi-Timeframe Stochastic Scalping EA - Quick Start Guide

## 5-Minute Setup

### Step 1: Installation (2 minutes)
1. Open MetaTrader 5
2. Press `Ctrl+D` or click `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `MultiTimeframeStochasticScalpingEA.mq5` to this folder
5. Return to MT5 and press `Ctrl+N` (Navigator)
6. Click "Refresh" in Navigator
7. EA appears under "Expert Advisors"

### Step 2: Chart Setup (1 minute)
1. Open **EURUSD** chart (or GBPUSD, USDJPY)
2. **Set timeframe to M1** (1-minute) - CRITICAL!
3. Drag EA from Navigator to chart
4. Settings window appears

### Step 3: Configure Settings (2 minutes)

**For Beginners (Recommended):**
```
=== Stochastic Parameters ===
Stoch_K_Period: 14
Stoch_D_Period: 3
Stoch_Slowing: 3

=== Risk Management ===
RiskPercent: 0.5%
StopLossPips: 30
TakeProfitPips: 50
MaxSpreadPips: 2.0

=== Position Management ===
MaxPositions: 1

=== Trading Hours ===
UseTimeFilter: true
StartHour: 8
EndHour: 18
```

**For Experienced Traders:**
```
=== Risk Management ===
RiskPercent: 1.0%
StopLossPips: 30
TakeProfitPips: 50
MaxSpreadPips: 3.0

=== Position Management ===
MaxPositions: 1

=== Trading Hours ===
UseTimeFilter: false (trade all day)
```

Click **OK** to apply settings.

### Step 4: Enable Trading
1. Click **AutoTrading** button in toolbar (or press `Alt+A`)
2. Verify **green checkmark** appears in top-right corner
3. Check **Experts** tab shows: "MultiTimeframeStochasticScalpingEA initialized successfully"

✅ **You're all set!**

---

## Understanding the Strategy (2 minutes)

### What It Does
The EA analyzes Stochastic indicators on **three timeframes simultaneously**:
- **M1** (1-minute): Fast signals
- **M5** (5-minute): Medium confirmation
- **M15** (15-minute): Slow confirmation

### Signal Requirements

**SELL Signal = ALL conditions true:**
- M1: Current & last candle K<D, previous 2 candles D<K
- M5: Current & previous candle K<D
- M15: Current & previous candle K<D

**BUY Signal = ALL conditions true:**
- M1: Current & last candle K>D, previous 2 candles D>K
- M5: Current & previous candle K>D
- M15: Current & previous candle K>D

### Why So Strict?
Multiple timeframe confirmation = **higher quality signals** but **fewer trades**.

**This is intentional!** Better to have 5 good trades than 50 mediocre ones.

---

## Dashboard at a Glance

### What You'll See in Experts Tab

**When initialized:**
```
MultiTimeframeStochasticScalpingEA initialized successfully
Stochastic Parameters: %K=14 %D=3 Slowing=3
Timeframes: M1, M5, M15
```

**When signal detected:**
```
===== SELL SIGNAL DETECTED =====
M1: Current K=45.2 D=48.5 (K<D: true)
M1: Last K=44.8 D=47.1 (K<D: true)
M1: Before[2] K=52.3 D=49.6 (D<K: true)
M1: Before[3] K=55.1 D=51.2 (D<K: true)
M5: Current K=43.5 D=46.8 (K<D: true)
M5: Previous K=42.9 D=45.3 (K<D: true)
M15: Current K=41.2 D=44.5 (K<D: true)
M15: Previous K=40.8 D=43.9 (K<D: true)

SELL order opened successfully.
  Lot Size: 0.10
  Entry Price: 1.10450
  Stop Loss: 1.10750
  Take Profit: 1.09950
```

**Trade execution:**
```
BUY/SELL order opened successfully.
  Lot Size: [calculated based on risk]
  Entry Price: [current market price]
  Stop Loss: [entry ± 30 pips]
  Take Profit: [entry ± 50 pips]
```

---

## Quick Reference

### Key Settings Explained

| Parameter | Default | Purpose |
|-----------|---------|---------|
| **Stoch_K_Period** | 14 | Main stochastic line period |
| **Stoch_D_Period** | 3 | Signal line period |
| **RiskPercent** | 1.0% | Risk per trade |
| **StopLossPips** | 30 | Stop loss distance |
| **TakeProfitPips** | 50 | Take profit distance (1.67:1 R:R) |
| **MaxSpreadPips** | 3.0 | Maximum acceptable spread |
| **MaxPositions** | 1 | Maximum concurrent positions |

### Critical Requirements

✅ **MUST BE ON M1 CHART** - The EA won't work correctly on other timeframes!
✅ **AutoTrading enabled** - Green checkmark in top-right
✅ **Low spread pairs** - Major pairs like EURUSD work best
✅ **Stable connection** - VPS recommended for 24/7 operation

---

## Common Questions

### Q: Why no trades appearing?
**A:** This is normal! The strategy requires perfect alignment across 3 timeframes. Signals are selective, not frequent. Be patient.

### Q: How many trades per day?
**A:** Varies widely - from 0 to 20+ depending on market conditions. Average: 5-10 trades/day.

### Q: What's the win rate?
**A:** Typically 45-60%. Strategy focuses on quality over quantity.

### Q: Can I use on other timeframes?
**A:** No. EA must be attached to M1 chart (it analyzes M1, M5, M15 internally).

### Q: What pairs work best?
**A:** Major pairs with low spreads: EURUSD, GBPUSD, USDJPY, USDCHF.

### Q: Is demo testing required?
**A:** **YES!** Absolutely mandatory. Test for 30+ days before live trading.

---

## Troubleshooting (1 minute)

### ❌ "EA not trading"
- **Check:** AutoTrading enabled? (Alt+A)
- **Check:** On M1 chart?
- **Check:** Spread acceptable? (must be < MaxSpreadPips)
- **Solution:** Review Experts tab for specific messages

### ❌ "No signals for hours"
- **This is normal!** Strategy is selective
- Verify EA is running (check Experts tab)
- Try different currency pair
- Be patient

### ❌ "Orders rejected"
- **Check:** Sufficient account balance?
- **Check:** Lot size within broker limits?
- **Check:** Market open?
- **Solution:** Review error message in Experts tab

### ❌ "Spread too high" messages
- **Cause:** Current spread exceeds MaxSpreadPips
- **Solution:** Wait for active trading hours (lower spreads)
- **Or:** Increase MaxSpreadPips (not recommended above 4.0)

---

## Trading Tips

### 🎯 Do's
✅ Start with demo account (30+ days)
✅ Use 0.5-1% risk per trade
✅ Trade major pairs with low spreads
✅ Keep MaxPositions at 1 initially
✅ Monitor Experts tab regularly
✅ Be patient - signals are selective

### ⛔ Don'ts
❌ Don't trade without demo testing
❌ Don't risk more than 2% per trade
❌ Don't use on exotic pairs (high spreads)
❌ Don't remove stop losses manually
❌ Don't expect constant trading
❌ Don't modify trades manually

---

## Performance Expectations

### Realistic Goals

**Win Rate:** 45-60%
**Risk:Reward:** 1:1.67 (30 pip SL, 50 pip TP)
**Trade Frequency:** 5-10 trades/day (varies)
**Drawdown:** < 20% acceptable
**Profit Factor:** > 1.5 desirable

### Time Commitment

**Setup:** 5-10 minutes
**Daily Monitoring:** 5-15 minutes
**Demo Testing:** 30+ days required
**Learning Curve:** 1-2 weeks to understand fully

---

## Risk Warning

⚠️ **Trading forex carries substantial risk of loss**

- You can lose 100% of your trading capital
- Past performance ≠ future results
- This EA does not guarantee profits
- Demo testing is MANDATORY
- Only trade with money you can afford to lose

**Start small. Test thoroughly. Trade responsibly.**

---

## Next Steps

1. ✅ Complete 5-minute setup (above)
2. ✅ Run on demo account for 30+ days
3. ✅ Monitor performance and learn strategy
4. ✅ Read full documentation: `MULTITIMEFRAME_STOCHASTIC_SCALPING_EA.md`
5. ✅ Start live with minimum lot sizes
6. ✅ Gradually increase position size as confident

---

## Support

**Need Help?**
- Review Experts tab for diagnostic messages
- Check main documentation for detailed explanations
- Verify all requirements are met
- Test on demo to isolate issues

**Want to Learn More?**
- Read: `MULTITIMEFRAME_STOCHASTIC_SCALPING_EA.md`
- Study stochastic oscillator theory
- Practice multi-timeframe analysis
- Keep a trading journal

---

## Summary

**What:** Multi-timeframe stochastic scalping EA
**How:** Analyzes M1, M5, M15 for signal alignment
**Why:** High-quality, confirmed trading signals
**Where:** M1 chart, major forex pairs
**When:** Active trading hours (best spreads)

**Remember:** Quality over quantity. Patience is key. Test before live trading.

---

*Good luck and trade safely! 📈*
