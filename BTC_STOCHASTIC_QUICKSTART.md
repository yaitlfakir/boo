# BTCStochasticEA - Quick Start Guide

## 5-Minute Setup

### What This EA Does
- **Automatically trades Bitcoin** based on Stochastic Oscillator signals
- **BUY** when Stochastic %K crosses above %D
- **SELL** when Stochastic %K crosses below %D
- Uses ATR-based dynamic stops that adapt to Bitcoin's volatility

### Installation (2 minutes)

1. **Copy the EA file**
   - Open MetaTrader 5
   - Click `File` → `Open Data Folder`
   - Navigate to `MQL5/Experts/`
   - Copy `BTCStochasticEA.mq5` to this folder
   - Click `Refresh` in Navigator or restart MT5

2. **Attach to chart**
   - Open a **BTCUSD** chart
   - Choose **H1** (1 hour) timeframe
   - Drag `BTCStochasticEA` from Navigator to chart

3. **Configure basic settings**
   ```
   RiskPercent: 1.0%
   UseDynamicSLTP: true
   MaxOpenPositions: 1
   ```

4. **Enable auto trading**
   - Click "AutoTrading" button (or press Alt+A)
   - Verify green checkmark appears
   - Done! EA is now running

### Recommended Settings

#### For Beginners (Safe)
```
RiskPercent: 0.5%
ATR_Multiplier: 2.5
MaxOpenPositions: 1
Timeframe: H1
```

#### For Experienced Traders (Moderate)
```
RiskPercent: 1.0%
ATR_Multiplier: 2.0
MaxOpenPositions: 1
Timeframe: H1
```

## Understanding the Strategy

### Trading Signals

**BUY Signal (Long)**
```
When Stochastic %K crosses ABOVE %D
→ EA opens BUY position
```

**SELL Signal (Short)**
```
When Stochastic %K crosses BELOW %D
→ EA opens SELL position
```

### Simple Example

```
Bar 1: K=45, D=50  (K is below D)
Bar 2: K=52, D=50  (K crossed above D)
→ BUY SIGNAL! EA opens long position

Later...
Bar 5: K=58, D=55  (K is above D)  
Bar 6: K=53, D=55  (K crossed below D)
→ SELL SIGNAL! EA opens short position
```

### Risk Management

The EA automatically:
- Calculates lot size based on your risk %
- Sets stop loss using ATR (adapts to volatility)
- Sets take profit at 2x the stop loss distance
- Trails the stop to lock in profits

## Key Parameters Explained

### Must-Know Settings

| Parameter | What It Does | Recommended Value |
|-----------|--------------|-------------------|
| **RiskPercent** | How much of your balance to risk per trade | 0.5% - 1.0% |
| **UseDynamicSLTP** | Use ATR-based stops (recommended) | true |
| **ATR_Multiplier** | How wide the stops are | 2.0 - 2.5 |
| **MaxOpenPositions** | Maximum trades at once | 1 |
| **StopLossPips** | Fixed SL if not using dynamic | 500 |
| **TakeProfitPips** | Fixed TP if not using dynamic | 1000 |

### When to Adjust

**If stops are hit too often:**
- Increase `ATR_Multiplier` to 2.5 or 3.0
- Use higher timeframe (H4 instead of H1)

**If you want more/less risk:**
- Adjust `RiskPercent` (0.5% = safe, 1% = moderate, 2% = aggressive)

**If you want more/fewer trades:**
- Lower timeframe (M30) = more trades
- Higher timeframe (H4) = fewer trades

## Monitoring Your EA

### Where to Look

1. **Experts Tab** (Ctrl+T)
   - Shows EA activity and signals
   - Look for "BUY SIGNAL DETECTED" or "SELL SIGNAL DETECTED"

2. **Trade Tab**
   - Shows open positions
   - Current profit/loss

3. **History Tab**
   - Past closed trades
   - Overall profit/loss

### What to Expect

**Signal Frequency (H1 timeframe):**
- 3-8 trades per week typically
- More during volatile periods
- Fewer during consolidation

**Win Rate:**
- Target: 45-55%
- Combined with 2:1 reward-to-risk = profitable

**Drawdown:**
- Expect 10-20% drawdowns occasionally
- Part of normal trading

## Common Issues & Solutions

### EA Not Trading?

**Check:**
- ✅ Is AutoTrading enabled? (green checkmark)
- ✅ Is chart symbol BTCUSD?
- ✅ Are you on H1 timeframe?
- ✅ Is spread acceptable? (check MaxSpreadPips)

**Solution:** Enable AutoTrading and wait for Stochastic crossover

### No Signals?

**Reason:** Market may be ranging without clear crossovers

**Solution:** 
- Be patient - wait for crossover
- Try different timeframe (H4, M30)
- Check Experts tab for any errors

### Trades Closing Too Fast?

**Reason:** Stop loss too tight for current volatility

**Solution:**
- Increase `ATR_Multiplier` to 2.5 or 3.0
- Enable `UseDynamicSLTP` if disabled
- Use H4 timeframe for longer trades

### Lot Size Too Small?

**Reason:** Risk % is low or account balance is small

**Solution:**
- Increase `RiskPercent` (carefully!)
- Verify `MinLotSize` setting
- Check your account balance

## Quick Reference

### Signal Logic
```
BUY:  K crosses above D
SELL: K crosses below D
```

### Stochastic Parameters
```
%K Period: 19
%D Period: 7
Slowing:   3
```

### Default Risk Settings
```
Risk Per Trade: 1.0%
Stop Loss: 2.0 × ATR
Take Profit: 4.0 × ATR
Max Positions: 1
```

### Best Timeframes
```
M30: Active trading (more signals)
H1:  Balanced (recommended)
H4:  Swing trading (fewer signals)
```

## Testing Before Live Trading

### Demo Testing (REQUIRED)

1. **Open demo account** in MetaTrader 5
2. **Run EA for 30 days minimum**
3. **Track performance:**
   - Number of trades
   - Win rate
   - Average profit/loss
   - Maximum drawdown
4. **Adjust settings** based on results
5. **Only go live** after consistent demo results

### Backtest First

1. Press `Ctrl+R` (Strategy Tester)
2. Select `BTCStochasticEA`
3. Choose `BTCUSD` symbol
4. Set timeframe `H1`
5. Date range: 6-12 months
6. Model: "Every tick"
7. Click `Start`

**Good Results:**
- 40%+ win rate
- Profit factor > 1.5
- Drawdown < 30%

## Risk Warning

⚠️ **READ BEFORE TRADING:**

- **High Risk:** Bitcoin is extremely volatile
- **Loss Risk:** You can lose 100% of trading capital
- **No Guarantee:** EA doesn't guarantee profits
- **Demo First:** ALWAYS test 30+ days on demo
- **Start Small:** Begin with minimum risk (0.5%)
- **Monitor Daily:** Check EA performance regularly
- **Your Risk:** All trading decisions and risks are yours

## Getting Started Checklist

- [ ] Installed EA in MT5
- [ ] Attached to BTCUSD H1 chart
- [ ] Set RiskPercent to 0.5% or 1.0%
- [ ] Enabled UseDynamicSLTP
- [ ] Set MaxOpenPositions to 1
- [ ] Enabled AutoTrading (green checkmark)
- [ ] Tested on demo account (30 days minimum)
- [ ] Understand the strategy and risks
- [ ] Started with small position sizes
- [ ] Know how to monitor EA performance

## Quick Tips

✅ **DO:**
- Test on demo first (30+ days)
- Start with 0.5-1% risk
- Use H1 or H4 timeframe
- Enable dynamic SL/TP
- Monitor daily
- Use VPS for 24/7 trading

❌ **DON'T:**
- Skip demo testing
- Risk more than 2% per trade
- Interfere with EA trades
- Disable stop losses
- Ignore risk management
- Expect consistent wins

## Need More Details?

See the full documentation: **BTC_STOCHASTIC_EA.md**

Covers:
- Complete parameter explanations
- Advanced configuration
- Strategy optimization
- Troubleshooting guide
- Performance tuning
- FAQ section

## Support

For issues or questions:
1. Check Experts tab for error messages
2. Review full documentation
3. Verify settings match this guide
4. Test on demo account first

---

**Remember:** Start small, test thoroughly, manage risk carefully. Good luck! 🚀
