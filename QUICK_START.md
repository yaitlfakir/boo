# Quick Start Guide - ScalpingEA

## Installation (5 minutes)

1. **Download the EA**
   - Download `ScalpingEA.mq5` from this repository

2. **Install in MT5**
   - Open MetaTrader 5
   - File → Open Data Folder
   - Navigate to `MQL5/Experts/`
   - Copy `ScalpingEA.mq5` here
   - Restart MT5 or refresh Navigator (F5)

3. **Enable Auto Trading**
   - Click "AutoTrading" button in toolbar (or Alt+A)
   - Tools → Options → Expert Advisors → Check "Allow algorithmic trading"

## First Run Setup

### Step 1: Choose Your Symbol
- **Recommended**: EURUSD, GBPUSD, USDJPY
- **Timeframe**: M5 or M15
- Open the chart for your chosen symbol

### Step 2: Attach the EA
- Drag `ScalpingEA` from Navigator onto the chart
- Or right-click chart → Expert Advisors → ScalpingEA

### Step 3: Configure Settings

**For Beginners (Conservative):**
```
Risk Management:
├─ RiskPercent: 0.5%
├─ StopLossPips: 20
├─ TakeProfitPips: 30
├─ MaxSpreadPips: 1.5
└─ UseTrailingStop: true
```

**For Intermediate (Moderate):**
```
Risk Management:
├─ RiskPercent: 1.0%
├─ StopLossPips: 15
├─ TakeProfitPips: 25
├─ MaxSpreadPips: 2.0
└─ UseTrailingStop: true
```

### Step 4: Verify EA is Active
- Check top-right corner of chart shows "ScalpingEA" with smiley face 😊
- Look for "ScalpingEA initialized successfully" in Experts tab

## Understanding Your First Trade

When EA opens a position, you'll see in the Experts tab:
```
Buy order opened successfully. Lot: 0.10 SL: 1.08523 TP: 1.08773
```

This means:
- **Lot**: Position size (automatically calculated)
- **SL**: Stop Loss level (where trade closes if price goes against you)
- **TP**: Take Profit level (where trade closes with profit)

## Monitoring Performance

### Check Active Trades
- **Trade tab**: Shows open positions
- **History tab**: Shows closed trades
- **Account tab**: Shows current balance and equity

### Key Metrics to Watch
1. **Balance**: Your actual money
2. **Equity**: Balance + floating profit/loss
3. **Margin**: Money used to maintain positions
4. **Free Margin**: Available for new trades

## Common Questions

### "Why isn't the EA trading?"
Check:
- ✓ AutoTrading is enabled (green button in toolbar)
- ✓ Spread is within limit (< MaxSpreadPips)
- ✓ Current time is within trading hours (8:00-20:00 by default)
- ✓ No open positions exist (EA allows only 1 position at a time)
- ✓ Indicators are working (no errors in Experts tab)

### "What lot size will be used?"
EA calculates automatically based on:
- Your account balance
- Risk percentage setting
- Stop loss distance
- Symbol's contract size

Formula: Lot = (Balance × Risk%) / (SL distance × Tick Value)

### "How often will it trade?"
Depends on:
- **Timeframe**: M5 = more trades, M15 = fewer trades
- **Market conditions**: Trending markets = more signals
- **Settings**: Tighter parameters = fewer trades
- **Typical**: 2-10 trades per day on M5

### "What's the expected profit?"
No guarantees, but with proper settings:
- **Win rate**: Target 55-65%
- **Risk/Reward**: 1:1.5 to 1:2
- **Monthly return**: Varies widely (test first!)

## Safety Tips

### ⚠️ Always Remember
1. **Test First**: Use demo account for 30+ days
2. **Start Small**: Begin with minimum risk (0.5%)
3. **Monitor Daily**: Check trades and performance
4. **Set Limits**: Stop if you hit daily/weekly loss limit
5. **Understand Risk**: You can lose money

### Emergency Stop
If something goes wrong:
1. Click "AutoTrading" button to disable (turns red)
2. Manually close any open positions
3. Check Experts tab for error messages
4. Review settings before re-enabling

## Testing the EA

### Demo Account Testing
1. Open demo account (File → Open Account → Demo)
2. Fund with realistic amount (e.g., $10,000)
3. Run EA for minimum 30 days
4. Track these metrics:
   - Total profit/loss
   - Number of trades
   - Win rate
   - Largest loss
   - Maximum drawdown

### Strategy Tester (Backtesting)
1. Press Ctrl+R to open Strategy Tester
2. Select ScalpingEA from list
3. Choose symbol (e.g., EURUSD)
4. Choose timeframe (M5)
5. Set date range (3-6 months)
6. Click "Start"
7. Review Results tab

## Optimization Tips

### If Too Many Losses
- Increase StopLossPips
- Decrease RiskPercent
- Use time filter (avoid low liquidity hours)
- Reduce MaxSpreadPips
- Switch to higher timeframe (M15 instead of M5)

### If Not Enough Trades
- Decrease FastMA_Period (make it more sensitive)
- Widen RSI levels (e.g., 35/65 instead of 30/70)
- Disable time filter
- Increase MaxSpreadPips slightly
- Use lower timeframe (M5 instead of M15)

### If Trailing Stop Too Tight
- Increase TrailingStopPips
- Increase TrailingStepPips
- Test without trailing stop first

## Best Practices

### Daily Routine
- **Morning**: Check overnight positions, verify EA is running
- **Midday**: Review any trades taken, check spread conditions
- **Evening**: Analyze day's performance, note any issues

### Weekly Review
- Calculate win rate (wins / total trades)
- Review largest loss (should be close to StopLossPips)
- Check if parameters need adjustment
- Compare with backtest expectations

### Monthly Analysis
- Calculate total return (%)
- Determine if EA is meeting goals
- Consider re-optimization if market changed
- Review and adjust risk settings

## Support Resources

### Log Files
- Location: File → Open Data Folder → MQL5 → Logs
- Check for errors or unusual activity
- Include in support requests

### Common Error Codes
- **130**: Invalid stops (SL/TP too close to price)
- **131**: Invalid trade volume (lot size issue)
- **134**: Not enough money (insufficient margin)
- **136**: Market is closed
- **4756**: Trade context is busy (wait and retry)

### Getting Help
- Check Experts tab for error messages
- Review TECHNICAL_DOCUMENTATION.md for details
- Verify broker allows Expert Advisors
- Ensure sufficient account balance

## Checklist for Success

Before going live:
- [ ] Tested on demo for 30+ days
- [ ] Backtested for 6+ months of historical data
- [ ] Understand all input parameters
- [ ] Know how to stop the EA in emergency
- [ ] Have realistic profit expectations
- [ ] Account is funded appropriately
- [ ] Broker has low spreads (< 1 pip for EURUSD)
- [ ] Using conservative risk settings (≤ 1%)
- [ ] Monitoring plan in place

## Contact & Feedback

If you find issues or have suggestions:
- Open an issue on GitHub
- Provide logs and screenshots
- Describe your settings and broker
- Include backtest results if relevant

---

**Remember**: Automated trading is not a guaranteed profit system. Always trade responsibly and never risk more than you can afford to lose.
