# Bitcoin Trading EA - Quick Start Guide

Get started with automated Bitcoin trading in MetaTrader 5 in just 5 minutes!

## Prerequisites

Before you begin, ensure you have:
- ✅ MetaTrader 5 installed (build 3300 or higher)
- ✅ A broker account that offers Bitcoin trading (BTCUSD or BTC/USD)
- ✅ Demo account for testing (recommended for first 30 days)
- ✅ Minimum $500-1000 account balance (demo or live)

## Step-by-Step Installation

### Step 1: Install the EA (2 minutes)

1. **Locate Data Folder**:
   - Open MetaTrader 5
   - Click `File` → `Open Data Folder`
   - A Windows Explorer window will open

2. **Copy EA File**:
   - Navigate to `MQL5` → `Experts` folder
   - Copy `BitcoinTradingEA.mq5` into this folder

3. **Refresh Navigator**:
   - Go back to MetaTrader 5
   - In Navigator panel (left side), right-click "Expert Advisors"
   - Click "Refresh" or press F5
   - You should see "BitcoinTradingEA" appear in the list

### Step 2: Setup Bitcoin Chart (1 minute)

1. **Open Bitcoin Symbol**:
   - In Market Watch (left panel), find BTCUSD or BTC/USD
   - If not visible, right-click Market Watch → "Symbols" → search "BTC"
   - Add the Bitcoin symbol your broker offers
   - Double-click BTCUSD to open a chart

2. **Set Timeframe**:
   - Right-click chart → "Timeframes" → Select **H1** (1 hour)
   - Or use toolbar: Click timeframe dropdown → select H1
   - For more conservative trading, use **H4** (4 hours)

### Step 3: Attach EA to Chart (1 minute)

1. **Drag and Drop**:
   - In Navigator, locate "BitcoinTradingEA" under Expert Advisors
   - Drag it onto your BTCUSD chart
   - A settings dialog will appear

2. **Configure for First Run** (use these safe settings):
   ```
   === Trading Strategy ===
   [Keep all defaults]
   
   === Risk Management ===
   RiskPercent: 0.5%          ← Start conservative!
   UseDynamicSLTP: true       ← Recommended
   UseTrailingStop: true      ← Protect profits
   
   === Position Management ===
   MaxOpenPositions: 1        ← One position at a time
   
   === Volatility Filter ===
   UseVolatilityFilter: true  ← Important for Bitcoin
   
   === Trend Strength ===
   UseTrendFilter: true       ← Avoid choppy markets
   
   === Trading Hours ===
   UseTimeFilter: false       ← Trade 24/7
   ```

3. **Common Tab Settings**:
   - ✅ Check "Allow live trading"
   - ✅ Check "Allow DLL imports" (if available)
   - ✅ Keep "Allow import of external experts" checked

4. **Click OK** to activate

### Step 4: Enable Auto Trading (30 seconds)

1. **Activate AutoTrading**:
   - Click the "AutoTrading" button in the toolbar (looks like a play button)
   - Or press **Alt+A** keyboard shortcut
   - The button should turn green/highlighted

2. **Verify Activation**:
   - Look at top-right corner of chart
   - You should see a **green checkmark** with the EA name
   - If you see a red "X", AutoTrading is not enabled

3. **Check Global Settings**:
   - Go to `Tools` → `Options`
   - Click "Expert Advisors" tab
   - Ensure "Allow algorithmic trading" is checked
   - Click "OK"

### Step 5: Monitor the EA (Ongoing)

1. **Open Experts Tab** (bottom of screen):
   - View → Toolbox → Experts tab
   - This shows EA activity logs, signals, and decisions

2. **Watch for Messages**:
   - Initialization success message
   - Signal detection logs
   - Trade execution confirmations
   - Any error or warning messages

3. **Check Open Positions**:
   - Toolbox → Trade tab
   - Shows any currently open positions
   - Monitor profit/loss in real-time

## What to Expect

### First 24 Hours
- **Don't panic if no trades**: Bitcoin signals may take time to align
- **Monitor Experts tab**: EA logs why it's not trading (spread, volatility, etc.)
- **Watch for signals**: EA logs potential signals and why they qualify

### Typical Signal Frequency
- **H1 timeframe**: 2-5 signals per week
- **H4 timeframe**: 1-3 signals per week
- **Not every signal = trade**: Filters may reject some signals

### Expected Behavior
- ✅ EA checks for signals every new candle
- ✅ Logs filter checks (spread, volatility, trend)
- ✅ Opens position when all conditions met
- ✅ Manages trailing stop automatically
- ✅ Closes at stop loss or take profit

## Common Issues & Solutions

### ❌ EA Not Trading

**Check 1 - AutoTrading Enabled**:
- Toolbar button should be green/highlighted
- Press Alt+A to toggle
- Restart MetaTrader if needed

**Check 2 - Spread Too High**:
- Current spread > 50 pips default limit
- Wait for lower spread periods
- Or increase MaxSpreadPips (not recommended initially)

**Check 3 - Volatility Out of Range**:
- ATR below 100 pips or above 2000 pips
- Add ATR indicator to chart to monitor
- This is normal - EA waits for optimal conditions

**Check 4 - No Trend Detected**:
- ADX below 20 (minimum for trending market)
- Add ADX indicator to chart
- EA waits for stronger trends

**Check 5 - Already Has Position**:
- MaxOpenPositions = 1 by default
- Check Trade tab for existing position
- Wait for current trade to close

### ❌ "Invalid Volume" Error

**Solution**:
- Reduce RiskPercent (try 0.3% or 0.2%)
- Check account balance is sufficient
- Verify broker's minimum lot size
- Increase account balance if too low

### ❌ "Not Enough Money" Error

**Solution**:
- Account balance too small for risk percentage
- Reduce RiskPercent to 0.2-0.3%
- Add more funds to account
- Ensure you're using micro/mini lots if available

### ❌ EA Keeps Losing Money

**Action Steps**:
1. **Stop Live Trading Immediately**
2. Switch to demo account
3. Review last 10 trades in History tab
4. Check if market was trending or ranging
5. Consider these adjustments:
   - Increase MinADX (25-30 for stronger trends)
   - Reduce ATR_Multiplier (1.5 for tighter stops)
   - Enable stricter volatility filtering
   - Increase risk-reward (ATR_Multiplier for TP)

## Daily Monitoring Checklist

Spend 5-10 minutes daily:

1. ✅ **Check EA Status**:
   - Green checkmark visible on chart
   - AutoTrading still enabled
   - No error messages in Experts tab

2. ✅ **Review Open Positions**:
   - Current profit/loss
   - Stop loss and take profit levels
   - Trailing stop updates

3. ✅ **Check Recent Logs**:
   - Any signals detected
   - Filter rejections explained
   - Trade executions successful

4. ✅ **Monitor Account**:
   - Current balance
   - Total profit/loss for period
   - Drawdown percentage

5. ✅ **Market Conditions**:
   - Current Bitcoin price movement
   - News events scheduled
   - Overall market sentiment

## Next Steps After 30 Days

### If Profitable on Demo:
1. Review performance metrics:
   - Win rate (target: > 40%)
   - Profit factor (target: > 1.5)
   - Max drawdown (target: < 30%)

2. Start with live account:
   - Use same settings as demo
   - Start with 0.5% risk
   - Minimum $500-1000 balance
   - Monitor more frequently

3. Gradually scale up:
   - After 2 months profitable: increase to 1% risk
   - After 6 months profitable: consider 1.5% risk
   - Never exceed 2% risk per trade

### If Not Profitable on Demo:
1. **Don't go live** - continue testing
2. Review trade history for patterns
3. Consider adjustments:
   - Higher timeframe (H4 instead of H1)
   - Stricter filters (higher MinADX)
   - Different ATR_Multiplier values

4. Backtest extensively:
   - Use Strategy Tester
   - Test 1-2 years of data
   - Optimize parameters
   - Verify results on different periods

## Advanced Configuration (After 30 Days)

Once comfortable with basics, you can optimize:

### Higher Timeframes
- Try **H4** for fewer but higher quality signals
- Or **D1** (Daily) for long-term swing trading
- Higher timeframes = more stable trends

### Dynamic Stop Optimization
- Adjust **ATR_Multiplier**:
  - 1.5 = Tighter stops, earlier exits
  - 2.0 = Balanced (default)
  - 2.5-3.0 = Wider stops, let trends run

### Volatility Range Tuning
- **Bull markets**: Increase MaxATR to 2500-3000
- **Bear markets**: Decrease MinATR to 50-75
- **High volatility periods**: Enable strict filtering

### Position Management
- Increase **MaxOpenPositions** to 2-3 (carefully!)
- Adjust **TrailingStopPips** based on ATR
- Consider partial position closing (requires code modification)

## Performance Targets

Set realistic expectations:

### Monthly Returns
- **Conservative**: 2-5% per month
- **Moderate**: 5-10% per month
- **Aggressive**: 10-15% per month (higher risk)

### Win Rate
- **Trend-following**: 35-45% is acceptable
- Many small losses, fewer large wins
- Profit factor > 1.5 more important than win rate

### Drawdown Tolerance
- **Maximum acceptable**: 30% of account
- **Stop trading if**: Drawdown > 40%
- **Re-evaluate strategy if**: Consistent drawdown > 25%

## Support Resources

### Documentation
- **Full Guide**: BITCOIN_TRADING_EA.md
- **Main README**: README.md
- **This Guide**: BITCOIN_TRADING_QUICKSTART.md

### Learning Resources
- MetaTrader 5 Help: F1 key
- Strategy Tester Guide: Built into MT5
- MQL5 Community: mql5.com/en/forum

### Broker Requirements
Look for brokers with:
- Low Bitcoin spreads (< 30 pips typical)
- Good execution speed
- MT5 platform support
- Crypto trading available
- Regulated and reputable

## Final Reminders

⚠️ **NEVER**:
- Trade with money you can't afford to lose
- Use maximum leverage (2:1 or 3:1 maximum recommended)
- Ignore risk management settings
- Disable filters thinking you'll get more trades
- Rush from demo to live trading

✅ **ALWAYS**:
- Start with demo account (30+ days minimum)
- Use conservative risk settings (0.5% initially)
- Monitor daily for first month
- Keep MetaTrader running 24/7 (use VPS if needed)
- Keep learning and adapting strategy

---

**You're ready to start! Remember: Patience, discipline, and proper risk management are keys to success in Bitcoin trading.**

**Good luck, and trade safely! 🚀**
