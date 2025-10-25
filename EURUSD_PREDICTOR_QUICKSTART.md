# EURUSD Predictor EA - Quick Start Guide

## What It Does

**EurusdPredictorEA** analyzes EURUSD price movements and displays clear **UP** or **DOWN** signals on your chart to predict where the price is likely to go next.

⚠️ **Important**: This EA **does NOT trade automatically** - it only shows signals!

## 5-Minute Setup

### Step 1: Install the EA
1. Open MetaTrader 5
2. Press `Ctrl+Shift+D` (Open Data Folder)
3. Go to `MQL5/Experts/` folder
4. Copy `EurusdPredictorEA.mq5` file there
5. Restart MT5 or press F5 in Navigator

### Step 2: Attach to Chart
1. Open a **EURUSD** chart (any timeframe)
2. Find `EurusdPredictorEA` in Navigator panel
3. Drag and drop it onto the EURUSD chart
4. Click "OK" in the settings window (default settings are fine)

### Step 3: Enable AutoTrading
1. Click the **AutoTrading** button in toolbar (or press Alt+A)
2. Look for a green checkmark ✓ in the top-right corner
3. If you see a smiling face, the EA is running!

### Step 4: Watch for Signals
- **Green UP Arrow** 🟢⬆️ = Price predicted to go UP
- **Red DOWN Arrow** 🔴⬇️ = Price predicted to go DOWN

That's it! You're ready to go!

## What the Signals Mean

### UP Signal (Green Arrow ⬆️)
- **Meaning**: Multiple indicators suggest price will move upward
- **Possible Action**: Consider entering a BUY trade
- **Recommendation**: Wait 1-2 bars to confirm the direction

### DOWN Signal (Red Arrow ⬇️)
- **Meaning**: Multiple indicators suggest price will move downward
- **Possible Action**: Consider entering a SELL trade
- **Recommendation**: Wait 1-2 bars to confirm the direction

## Best Timeframes

| Timeframe | Signals Per Day | Best For |
|-----------|----------------|----------|
| M15 | 5-10 | Scalpers |
| H1 | 1-3 | Day Traders ⭐ **Recommended** |
| H4 | 1-2 per week | Swing Traders |

**Start with H1 (1-hour) for best results!**

## Common Questions

**Q: Why no signals appearing?**
- Be patient! Signals only appear when conditions are strong
- Try different timeframes
- Market might be ranging (no clear direction)

**Q: EA says "works only on EURUSD"?**
- You attached it to wrong chart
- Make sure you're on EURUSD chart
- Close and reopen EA on EURUSD

**Q: Can I change the colors?**
- Yes! Right-click EA → Properties → Inputs
- Change `UpSignalColor` and `DownSignalColor`

**Q: How accurate are the signals?**
- Not 100% accurate (nothing is!)
- Always use stop loss
- Test on demo first
- Combine with your own analysis

## Settings You Might Want to Change

Right-click on EA → Properties → Inputs tab:

| Setting | What to Change | Why |
|---------|---------------|-----|
| `UpSignalColor` | Pick your favorite color | Better visibility |
| `DownSignalColor` | Pick your favorite color | Better visibility |
| `SignalSize` | 1-5 | Make arrows bigger/smaller |
| `ShowSignalText` | true/false | Show/hide "UP"/"DOWN" text |
| `EnableAudioAlerts` | true/false | Turn sound alerts on/off |

## Trading Tips

### ✅ DO:
- Wait for 1-2 bars after signal before entering
- Use stop loss always (20-30 pips for H1)
- Check higher timeframe for trend
- Test on demo account first
- Start with small position sizes

### ❌ DON'T:
- Don't jump in immediately on signal
- Don't trade without stop loss
- Don't ignore higher timeframe trend
- Don't use on live account without testing
- Don't trade during major news

## Quick Trading Example

1. **UP Signal appears on H1 chart**
2. Wait 1-2 bars to see if price confirms upward movement
3. If price moving up, consider BUY
4. Set Stop Loss: 20-30 pips below entry
5. Set Take Profit: 40-60 pips above entry
6. Monitor trade

## Troubleshooting

### Problem: EA not showing on chart
**Fix**: 
- Check Navigator → Expert Advisors
- Make sure file is in MQL5/Experts/ folder
- Restart MetaTrader 5

### Problem: No green checkmark
**Fix**:
- Press Alt+A to enable AutoTrading
- Check Tools → Options → Expert Advisors → "Allow algorithmic trading"

### Problem: Signals disappear
**Fix**:
- Signals stay on chart permanently
- If missing, you might have deleted them
- Remove EA and reattach it

### Problem: Too many/too few signals
**Fix** (Advanced):
- Right-click EA → Properties → Inputs
- Change `RSI_UpLevel` and `RSI_DownLevel`
- Wider range (60/40) = fewer signals
- Narrow range (52/48) = more signals

## Example Screenshots Descriptions

### Good Setup:
```
Chart: EURUSD H1
Signal: UP Arrow at 1.0850
Action: Wait 1-2 bars
Result: Price moves to 1.0880 ✓
```

### What You'll See:
- Green arrow pointing up below a candlestick
- "UP" text near the arrow (if enabled)
- Alert popup (if enabled)
- Details in Experts tab

## Next Steps

1. **Watch and Learn** (1 week)
   - Don't trade yet
   - Just observe signals
   - See how price moves after signals

2. **Demo Test** (2-4 weeks)
   - Open demo account
   - Follow signals with small demo trades
   - Track your results

3. **Live Trading** (when ready)
   - Start with minimum lot size
   - Use proper risk management
   - Never risk more than 1-2% per trade

## Important Reminders

⚠️ **This EA predicts, it doesn't guarantee!**
⚠️ **Always use stop loss**
⚠️ **Test on demo first**
⚠️ **Don't risk money you can't afford to lose**

## Getting More Info

For detailed documentation, see: `EURUSD_PREDICTOR_EA.md`

For how the prediction works, read the "How the Prediction Works" section in the full documentation.

---

**Happy Trading!** 📈📉

Remember: The EA is a tool to help you, not a money-printing machine. Use it wisely, combine with your knowledge, and always manage your risk!
