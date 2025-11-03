# BTCStochasticEA - Automated Bitcoin Trading with Stochastic Oscillator

## Overview

**BTCStochasticEA** is an automated Expert Advisor (EA) specifically designed for Bitcoin (BTCUSD) trading that uses the Stochastic Oscillator (19,7,3) to generate trading signals. The strategy is simple yet effective:
- **BUY** when the Stochastic %K line crosses above the %D line
- **SELL** when the Stochastic %K line crosses below the %D line

This EA is optimized for Bitcoin's high volatility with dynamic stop losses based on ATR (Average True Range) and comprehensive risk management features.

## Features

### Simple and Clear Strategy
- **Stochastic Oscillator (19,7,3)**: Uses %K=19, %D=7, Slowing=3 parameters
- **BUY Signal**: Automatically opens a BUY position when %K crosses above %D
- **SELL Signal**: Automatically opens a SELL position when %K crosses below %D
- **No Complex Filters**: Pure stochastic crossover strategy for clear entry signals

### Bitcoin-Optimized Risk Management
- **Dynamic Stop Loss/Take Profit**: ATR-based adaptive stops that adjust to Bitcoin's volatility
- **Position Sizing**: Automatic lot size calculation based on account balance and risk percentage
- **Spread Filter**: Avoids trading during high spread conditions (protects from poor entries)
- **Trailing Stop**: Locks in profits as Bitcoin price moves favorably
- **Maximum Position Limit**: Controls exposure with configurable position count

### Key Advantages for Bitcoin
- **Volatility Adapted**: Uses ATR multiplier for dynamic stops (default: 2x ATR)
- **Large Stop Distances**: Default 500 pips for Bitcoin's large price movements
- **24/7 Trading Ready**: Optional time filter (disabled by default for crypto markets)
- **High Spread Tolerance**: 50 pips max spread (suitable for crypto markets)

## Installation

1. Open MetaTrader 5
2. Click `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `BTCStochasticEA.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in Navigator
6. The EA appears under "Expert Advisors" in Navigator

## Configuration

### Quick Start Settings

#### Conservative (Recommended for Beginners)
```
RiskPercent: 0.5%
UseDynamicSLTP: true
ATR_Multiplier: 2.5
MaxOpenPositions: 1
Timeframe: H1 or H4
```

#### Moderate (Balanced Risk)
```
RiskPercent: 1.0%
UseDynamicSLTP: true
ATR_Multiplier: 2.0
MaxOpenPositions: 1
Timeframe: H1
```

#### Aggressive (High Risk - Experienced Traders Only)
```
RiskPercent: 2.0%
UseDynamicSLTP: true
ATR_Multiplier: 1.5
MaxOpenPositions: 2
Timeframe: M30 or H1
```

### Parameter Explanations

#### Stochastic Parameters
- **Stoch_K_Period** (default: 19): The %K period for Stochastic calculation
- **Stoch_D_Period** (default: 7): The %D signal line period
- **Stoch_Slowing** (default: 3): Smoothing factor for Stochastic

#### Risk Management
- **RiskPercent** (default: 1.0%): Risk per trade as percentage of account balance
  - 0.5% = Very Conservative
  - 1.0% = Moderate
  - 2.0% = Aggressive
  
- **StopLossPips** (default: 500.0): Base stop loss in pips for fixed SL mode
  - Only used when UseDynamicSLTP = false
  
- **TakeProfitPips** (default: 1000.0): Base take profit in pips for fixed TP mode
  - Only used when UseDynamicSLTP = false
  
- **UseDynamicSLTP** (default: true): Enable ATR-based dynamic stop loss and take profit
  - **Recommended: true** for Bitcoin's varying volatility
  
- **ATR_Period** (default: 14): Period for ATR calculation
  
- **ATR_Multiplier** (default: 2.0): Multiplier for ATR-based stop distance
  - SL Distance = ATR × Multiplier
  - TP Distance = ATR × Multiplier × 2
  - Higher = Wider stops (more room for volatility)
  - Lower = Tighter stops (less room for volatility)
  
- **MaxSpreadPips** (default: 50.0): Maximum allowed spread in pips
  - Prevents trading during low liquidity periods
  
- **UseTrailingStop** (default: true): Enable trailing stop to lock in profits
  
- **TrailingStopPips** (default: 300.0): Distance of trailing stop from current price
  
- **TrailingStepPips** (default: 100.0): Minimum price movement to adjust trailing stop

#### Position Management
- **MagicNumber** (default: 191973): Unique identifier for this EA's trades
  - Change if running multiple EAs on same account
  
- **TradeComment** (default: "BTC-Stoch"): Comment added to each trade
  
- **MaxLotSize** (default: 10.0): Maximum position size limit
  
- **MinLotSize** (default: 0.01): Minimum position size limit
  
- **MaxOpenPositions** (default: 1): Maximum number of simultaneous positions
  - 1 = Only one trade at a time (recommended)
  - 2+ = Multiple positions allowed (higher risk)

#### Trading Hours
- **UseTimeFilter** (default: false): Enable/disable time-based trading restrictions
  - false = Trade 24/7 (recommended for Bitcoin)
  - true = Only trade during specified hours
  
- **StartHour** (default: 0): Start trading hour (0-23, server time)
  
- **EndHour** (default: 23): End trading hour (0-23, server time)

## Usage Instructions

### Step 1: Attach to Bitcoin Chart
1. Open a **BTCUSD** chart (ensure your broker offers Bitcoin)
2. Choose a timeframe:
   - **M30**: More signals, faster trades (active trading)
   - **H1**: Balanced signals and trades (recommended)
   - **H4**: Fewer signals, longer-term trades (swing trading)
3. Drag and drop **BTCStochasticEA** from Navigator to the chart

### Step 2: Configure Settings
1. In the EA settings dialog, adjust parameters based on your risk tolerance
2. For beginners: Start with **Conservative** settings (0.5% risk, H1 timeframe)
3. Enable **UseDynamicSLTP** for automatic volatility adjustment
4. Keep **MaxOpenPositions** at 1 initially

### Step 3: Enable Auto Trading
1. Click the "AutoTrading" button in the toolbar (or press Alt+A)
2. Verify a green checkmark appears in the top-right corner
3. Ensure "Allow algorithmic trading" is enabled in **Tools → Options → Expert Advisors**

### Step 4: Monitor Performance
1. Check the **Experts** tab for EA activity and signals
2. Review open positions in the **Trade** tab
3. Monitor closed trades and profit/loss in the **History** tab
4. Watch for BUY/SELL signal messages in the log

## How the Strategy Works

### Signal Generation

#### BUY Signal (Long Entry)
The EA opens a BUY position when the Stochastic %K line crosses above the %D line:
```
Previous Bar: %K ≤ %D
Current Bar:  %K > %D
→ BUY Signal Generated
```

**Example:**
- Bar 1: K=45, D=50 (K below D)
- Bar 2: K=52, D=50 (K crossed above D) → **BUY**

#### SELL Signal (Short Entry)
The EA opens a SELL position when the Stochastic %K line crosses below the %D line:
```
Previous Bar: %K ≥ %D
Current Bar:  %K < %D
→ SELL Signal Generated
```

**Example:**
- Bar 1: K=55, D=50 (K above D)
- Bar 2: K=48, D=50 (K crossed below D) → **SELL**

### Stop Loss and Take Profit Calculation

#### Dynamic Mode (Recommended)
When `UseDynamicSLTP = true`:
```
ATR = Average True Range (14 periods)
Stop Loss Distance = ATR × ATR_Multiplier (e.g., ATR × 2.0)
Take Profit Distance = ATR × ATR_Multiplier × 2.0 (e.g., ATR × 4.0)
```

**Benefits:**
- Automatically adapts to market volatility
- Wider stops during high volatility (prevents premature stop-outs)
- Tighter stops during low volatility (reduces risk)

**Example:**
- ATR = 300 pips, Multiplier = 2.0
- SL Distance = 600 pips
- TP Distance = 1200 pips

#### Fixed Mode
When `UseDynamicSLTP = false`:
```
Stop Loss Distance = StopLossPips (default: 500 pips)
Take Profit Distance = TakeProfitPips (default: 1000 pips)
```

### Position Sizing

The EA calculates lot size based on:
```
Risk Amount = Account Balance × (RiskPercent / 100)
Lot Size = Risk Amount / (SL Distance in Money)
```

**Example:**
- Account: $10,000
- Risk: 1%
- Risk Amount: $100
- SL Distance: 600 pips = $200 per lot
- Calculated Lot Size: 0.5 lots

The EA then normalizes and applies min/max limits.

### Trailing Stop

When price moves favorably:
- **BUY positions**: Stop loss moves up to lock in profit
- **SELL positions**: Stop loss moves down to lock in profit

**Activation:**
- Trailing only activates when profit exceeds `TrailingStopPips`
- Stop loss moves by `TrailingStepPips` increments

**Example (BUY):**
- Entry: 50,000
- Trailing Distance: 300 pips
- Current Price: 50,500 (500 pips profit)
- New SL: 50,200 (300 pips below current price)
- Locked Profit: 200 pips minimum

## Trading Strategy Examples

### Strategy 1: Pure Stochastic Crossover (Default)
This is the EA's built-in strategy:
1. Wait for %K to cross above %D → BUY
2. Wait for %K to cross below %D → SELL
3. Let the EA manage entries, exits, and trailing stops automatically
4. Monitor performance and adjust risk settings as needed

**Best For:**
- Traders who want full automation
- Following momentum shifts in Bitcoin
- Capturing trend changes early

### Strategy 2: Combine with Manual Analysis
Use the EA as a signal generator while applying manual filters:
1. Let the EA generate signals
2. Before each trade, check:
   - Overall Bitcoin trend (daily/weekly chart)
   - Major support/resistance levels
   - Recent news or events
3. Disable the EA temporarily if conditions are unfavorable
4. Re-enable when market conditions improve

**Best For:**
- Semi-automated trading
- Traders who want control over entries
- Filtering trades during major news events

### Strategy 3: Multi-Timeframe Approach
Run the EA on different timeframes for different strategies:
- **H4 Chart**: Swing trading (longer-term positions)
- **H1 Chart**: Day trading (medium-term positions)
- **M30 Chart**: Active trading (shorter-term positions)

**Best For:**
- Diversifying trading approaches
- Capturing moves on different time scales
- Advanced traders with larger accounts

## Best Practices

### ✅ DO:

1. **Test Extensively on Demo**
   - Run EA on demo account for at least 30 days
   - Test different timeframes and settings
   - Understand the signal frequency and win rate

2. **Start Conservative**
   - Begin with 0.5% risk per trade
   - Use H1 or H4 timeframe
   - Keep MaxOpenPositions = 1
   - Enable UseDynamicSLTP

3. **Use Dynamic Stops**
   - Keep UseDynamicSLTP = true
   - Let ATR adapt stops to volatility
   - Review ATR_Multiplier based on results

4. **Monitor Daily**
   - Check open positions daily
   - Review profit/loss in History tab
   - Read EA messages in Experts tab
   - Adjust settings if needed

5. **Use VPS Hosting**
   - Bitcoin trades 24/7
   - VPS ensures EA runs continuously
   - Prevents missed signals and disconnections

### ❌ DON'T:

1. **Don't Over-Leverage**
   - Never risk more than 2% per trade
   - Don't use maximum account leverage
   - Don't open too many simultaneous positions

2. **Don't Interfere with EA Trades**
   - Let the EA manage stop loss and take profit
   - Don't manually close positions prematurely
   - Trust the trailing stop system

3. **Don't Ignore Risk Management**
   - Always use stop losses
   - Don't increase risk after losses
   - Don't disable UseDynamicSLTP without testing

4. **Don't Run Without Testing**
   - Never start with real money immediately
   - Test on demo account first
   - Verify EA works correctly with your broker

5. **Don't Expect Consistent Wins**
   - No strategy wins 100% of the time
   - Expect drawdowns and losing streaks
   - Focus on long-term profitability

## Risk Warnings

### ⚠️ CRITICAL DISCLAIMERS:

**High Risk Trading:**
- Trading Bitcoin and cryptocurrencies is extremely risky
- Bitcoin can move 5-10% or more in a single day
- You can lose 100% of your trading capital
- Never invest money you cannot afford to lose

**No Guarantees:**
- This EA does not guarantee profits
- Past performance does not predict future results
- Market conditions change constantly
- The EA may lose money during unfavorable conditions

**Market Risks:**
- **Volatility**: Extreme price swings can trigger stop losses rapidly
- **Slippage**: Execution price may differ from expected price during fast markets
- **Gaps**: Bitcoin can gap despite 24/7 trading (exchange issues, network congestion)
- **News Events**: Regulatory news can cause sudden crashes or rallies
- **Liquidity**: Low liquidity periods can result in high spreads

**Technical Risks:**
- **Internet Connection**: Disconnections can prevent EA from managing positions
- **Broker Issues**: Server problems can affect trade execution
- **EA Settings**: Incorrect parameters can result in excessive risk
- **Software Bugs**: While tested, no software is 100% bug-free

### Required Actions:

1. **Test on Demo Account**: MANDATORY 30+ days of demo testing before live trading
2. **Start Small**: Begin with minimum lot sizes on live account
3. **Use Stop Losses**: NEVER disable stop losses
4. **Monitor Regularly**: Check EA performance daily
5. **Understand the Strategy**: Know how the EA works before using it
6. **Accept Responsibility**: You make the decision to use this EA - all risks are yours

## Troubleshooting

### EA Not Trading

**Possible Causes:**
- AutoTrading is disabled
- Spread exceeds MaxSpreadPips
- Time filter is enabled and outside trading hours
- Already have MaxOpenPositions open
- No Stochastic crossover signal generated

**Solutions:**
1. Enable AutoTrading (Alt+A)
2. Increase MaxSpreadPips if spread is too high
3. Disable UseTimeFilter or adjust hours
4. Close some positions or increase MaxOpenPositions
5. Wait for a crossover signal to occur

### No Signals Appearing

**Possible Causes:**
- Market is ranging (no clear crossovers)
- Wrong symbol (not BTCUSD)
- Incorrect timeframe

**Solutions:**
1. Be patient - wait for Stochastic %K and %D to cross
2. Check you're on a BTCUSD chart
3. Try different timeframes (H1, H4)
4. Review Experts tab for any error messages

### Trades Closing Too Quickly

**Possible Causes:**
- Stop loss too tight (ATR_Multiplier too low)
- Market is very volatile
- Not using dynamic stops

**Solutions:**
1. Increase ATR_Multiplier (try 2.5 or 3.0)
2. Enable UseDynamicSLTP if disabled
3. Use higher timeframe (H4 instead of M30)
4. Increase StopLossPips if using fixed stops

### Lot Size Too Small/Large

**Possible Causes:**
- RiskPercent too low/high
- Stop loss distance very large/small
- Account balance too small

**Solutions:**
1. Adjust RiskPercent (0.5% to 2%)
2. Check calculated SL distance in logs
3. Verify ATR_Multiplier is reasonable
4. Review MinLotSize and MaxLotSize settings

### High Spread Error

**Possible Causes:**
- Broker has high spreads during low liquidity
- Market is closed (weekend for some brokers)

**Solutions:**
1. Increase MaxSpreadPips parameter
2. Trade during high liquidity hours
3. Consider switching to a broker with lower spreads

## Strategy Testing

### Backtesting in MetaTrader 5

1. Press **Ctrl+R** to open Strategy Tester
2. Select **BTCStochasticEA** from Expert Advisor list
3. Choose **BTCUSD** symbol
4. Select timeframe (H1 or H4 recommended)
5. Set date range (minimum 6 months, preferably 1+ years)
6. Select **"Every tick"** model for highest accuracy
7. Configure input parameters (match your planned live settings)
8. Click **"Start"** to run backtest
9. Review results:
   - Total trades and win rate
   - Profit factor and drawdown
   - Average trade duration
   - Best/worst trades

### Evaluating Results

**Good Performance Indicators:**
- Win rate: 40-60% (depends on timeframe)
- Profit factor: > 1.5
- Maximum drawdown: < 30%
- Risk/reward ratio: > 1.5

**Red Flags:**
- Very few trades (< 20 in 6 months)
- Very high win rate (> 80% - might be curve-fitted)
- Large drawdowns (> 50%)
- Profit factor < 1.0

### Forward Testing

After backtesting:
1. Run EA on demo account for 30+ days
2. Use same settings planned for live trading
3. Monitor daily performance
4. Track:
   - Number of trades per week
   - Average win/loss size
   - Drawdown periods
   - Signal quality

## Performance Optimization

### Timeframe Selection

- **M15/M30**: More signals, more active, higher transaction costs
- **H1**: Balanced - good for most traders
- **H4**: Fewer signals, longer-term, lower transaction costs
- **D1**: Very few signals, suitable for swing trading

**Recommendation:** Start with H1, then experiment.

### ATR Multiplier Tuning

- **1.5**: Tight stops, less room for volatility, higher risk of stop-outs
- **2.0**: Balanced (default)
- **2.5**: Wider stops, more room for volatility, lower risk of stop-outs
- **3.0+**: Very wide stops, may reduce win rate but increases R:R

**Recommendation:** Start with 2.0, increase to 2.5 if stops are hit frequently.

### Risk Percentage

- **0.5%**: Conservative, slow growth, better for small accounts
- **1.0%**: Moderate, balanced growth (default)
- **1.5%**: Aggressive, faster growth, higher drawdowns
- **2.0%**: Very aggressive, high risk

**Recommendation:** Start with 0.5% or 1.0%, never exceed 2%.

## Frequently Asked Questions

### Q: What is the best timeframe for this EA?
**A:** H1 (1 hour) provides a good balance between signal frequency and trade quality. H4 (4 hours) is better for swing trading with fewer but higher-quality signals.

### Q: Can I use this EA on other cryptocurrencies?
**A:** Yes, but it's optimized for Bitcoin. For other cryptos, you may need to adjust StopLossPips, MaxSpreadPips, and ATR_Multiplier based on their volatility.

### Q: Can I use this EA on forex pairs?
**A:** Not recommended. This EA is designed for Bitcoin's high volatility. For forex, use much smaller stop losses (20-50 pips) and adjust MaxSpreadPips (2-3 pips).

### Q: How many trades should I expect per week?
**A:** Depends on timeframe:
- M30: 5-15 trades per week
- H1: 3-8 trades per week
- H4: 1-4 trades per week

### Q: What is a good win rate for this strategy?
**A:** 45-55% is reasonable. With 2:1 reward-to-risk ratio (via trailing stop and dynamic TP), you can be profitable even with 40% win rate.

### Q: Should I use fixed or dynamic SL/TP?
**A:** Dynamic (UseDynamicSLTP = true) is highly recommended for Bitcoin because volatility changes frequently. ATR-based stops adapt automatically.

### Q: Can I run multiple instances of this EA?
**A:** Yes, but use different MagicNumbers for each instance. You can run it on different timeframes or with different settings simultaneously.

### Q: What's the minimum account size recommended?
**A:** Minimum $1,000 for conservative trading (0.5% risk). Ideally $5,000+ to handle drawdowns comfortably.

### Q: Do I need a VPS?
**A:** Highly recommended for Bitcoin trading since it's 24/7. A VPS ensures your EA runs continuously without interruptions.

### Q: How do I know if the EA is working correctly?
**A:** Check the Experts tab - you should see initialization messages and signal notifications. Review your broker's trading log for executed trades.

## Version History

### Version 1.00 (Current)
- Initial release
- Stochastic Oscillator (19,7,3) crossover strategy
- BUY when %K crosses above %D
- SELL when %K crosses below %D
- ATR-based dynamic SL/TP
- Trailing stop functionality
- Bitcoin-optimized risk management
- 24/7 trading support

## Support & Development

This EA is part of an open-source collection of MetaTrader 5 Expert Advisors. Feel free to:
- Report issues or bugs
- Suggest improvements or new features
- Share your optimization results
- Contribute code enhancements

## License

This Expert Advisor is provided for educational and research purposes. Use at your own risk.

---

**Remember:** Trading carries substantial risk of loss. This EA is a tool, not a guarantee of profits. Always use proper risk management, test thoroughly on demo accounts, and never risk more than you can afford to lose.
