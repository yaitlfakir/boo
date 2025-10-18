# StochasticSellEA Quick Start Guide

## What This EA Does

StochasticSellEA is an automated Expert Advisor that opens SELL positions when specific market conditions are met. It combines Stochastic Oscillator momentum analysis with Moving Average trend confirmation.

## Quick Setup (5 Minutes)

### 1. Install the EA
1. Open MetaTrader 5
2. Press `Ctrl+Shift+D` (or File → Open Data Folder)
3. Navigate to `MQL5\Experts`
4. Copy `StochasticSellEA.mq5` to this folder
5. Restart MT5 or press F5 in Navigator

### 2. Compile (First Time Only)
1. In MT5, press F4 to open MetaEditor
2. In Navigator, find `StochasticSellEA.mq5` under `Experts`
3. Double-click to open it
4. Press F7 to compile
5. Check for "0 error(s), 0 warning(s)" at the bottom
6. Close MetaEditor

### 3. Attach to Chart
1. Open a chart (e.g., EURUSD, GBPUSD)
2. Choose timeframe (H1 or H4 recommended)
3. Drag `StochasticSellEA` from Navigator → Expert Advisors to chart
4. Click OK in the settings window (use defaults for now)
5. Press Alt+A to enable AutoTrading
6. Check for a smiley face in the top-right corner

### 4. Verify It's Working
1. Open Toolbox (Ctrl+T)
2. Go to "Experts" tab
3. Look for: "StochasticSellEA initialized successfully"
4. You should see stochastic and MA parameters listed

## Entry Signal Explained Simply

The EA opens a SELL when:
1. ✅ Stochastic momentum indicator crosses above 60 (entering overbought zone)
2. ✅ Stochastic Main line crosses below Signal line (momentum turning bearish)
3. ✅ Slower MA(33) is below faster MA(19) with -9 shift (trend confirmation)

All three must happen together!

## Default Settings

```
Stochastic: %K=14, %D=19, Slowing=9
Crossover Level: 60
Fast MA: 19 periods, Shift: -9
Slow MA: 33 periods, Shift: -9
Risk: 1% per trade
Stop Loss: 50 pips
Take Profit: 100 pips
Max Positions: 1
```

## First Day Checklist

- [ ] EA compiled without errors
- [ ] EA attached to chart with smiley face showing
- [ ] AutoTrading enabled (Alt+A)
- [ ] Initialization message in Experts tab
- [ ] Test on DEMO account first!
- [ ] Set RiskPercent to 0.5% or less initially

## Important Notes

⚠️ **This EA Only Opens SELL Positions**
- It will never open BUY positions
- Best for bearish or ranging markets
- Consider market direction before activating

⚠️ **Signals May Be Rare**
- All three conditions must align
- This is normal and expected
- Quality over quantity approach

⚠️ **Always Test First**
- Use demo account for at least 1 week
- Backtest using Strategy Tester (Ctrl+R)
- Monitor spread during your trading hours

## Recommended Currency Pairs

Good pairs to start with:
- EURUSD (low spread, high liquidity)
- GBPUSD (moderate volatility)
- USDJPY (good for Asian session)
- AUDUSD (clear trends)

## How to Backtest (5 Minutes)

1. Press Ctrl+R (Strategy Tester)
2. Select `StochasticSellEA`
3. Choose symbol: EURUSD
4. Choose period: H1
5. Set date range: Last 1 year
6. Click Start
7. Review Results tab after completion

Look for:
- Total trades (should have some trades)
- Win rate (expect 40-60%)
- Profit factor (> 1.2 is good)
- Max drawdown (< 20% is better)

## Quick Settings Changes

### More Conservative (Lower Risk)
```
RiskPercent = 0.5
StopLossPips = 60
TakeProfitPips = 120
MaxPositions = 1
```

### More Aggressive (Higher Risk)
```
RiskPercent = 2.0
StopLossPips = 40
TakeProfitPips = 80
MaxPositions = 2
```

### Different Stochastic Sensitivity
```
Stoch_K_Period = 10 (faster, more signals)
Stoch_K_Period = 20 (slower, fewer signals)
Stoch_Level = 70 (stricter overbought)
Stoch_Level = 50 (looser overbought)
```

## Troubleshooting

### No Signals Appearing
- ✅ This is NORMAL - signals can be rare
- Wait at least 24 hours before worrying
- Check multiple currency pairs
- Try backtesting to see historical signal frequency

### EA Not Trading
- Check AutoTrading is ON (Alt+A)
- Check smiley face is "smiling" not "sad"
- Look in Experts tab for error messages
- Verify spread < MaxSpreadPips (3.0 default)

### Lot Size Errors
- Check account balance > $100
- Reduce RiskPercent to 0.5% or 1.0%
- Check broker's minimum lot size
- Verify symbol allows trading

## Next Steps

Once comfortable with defaults:

1. **Optimize Parameters**
   - Run optimization in Strategy Tester
   - Test different Stochastic periods
   - Adjust MA periods and shift values

2. **Multi-Symbol Setup**
   - Attach to 3-4 different pairs
   - Diversify signal sources
   - Monitor overall risk

3. **Monitor and Adjust**
   - Review weekly performance
   - Adjust risk based on results
   - Consider market conditions

## Getting Help

Check these files for more details:
- `STOCHASTIC_SELL_EA.md` - Full documentation
- `README.md` - Overview of all EAs
- Experts tab in MT5 - Real-time logs

## Safety Reminders

🛡️ **Always:**
- Test on demo first (1+ week minimum)
- Start with low risk (0.5-1%)
- Monitor daily for first week
- Never risk more than you can afford to lose

🛡️ **Never:**
- Run on live account without testing
- Risk more than 2% per trade
- Trade without understanding the strategy
- Ignore maximum drawdown limits

---

**Ready to Go?**
1. Install → 2. Compile → 3. Attach to Chart → 4. Enable AutoTrading → 5. Monitor!

Good luck with your trading! 🚀
