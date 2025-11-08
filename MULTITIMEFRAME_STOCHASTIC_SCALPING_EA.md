# Multi-Timeframe Stochastic Scalping EA

## Overview

**MultiTimeframeStochasticScalpingEA** is a sophisticated scalping Expert Advisor that uses Stochastic Oscillator signals across three different timeframes (M1, M5, and M15) to identify high-probability trading opportunities. The EA requires precise alignment of stochastic conditions across all timeframes before opening positions, ensuring strong signal confirmation.

## Trading Strategy

### Core Concept

The EA analyzes the relationship between Stochastic %K (main line) and %D (signal line) across multiple timeframes to identify momentum shifts and trend reversals. By requiring confirmation from three different timeframes, the strategy filters out false signals and only trades when multiple time horizons agree on market direction.

### SELL Signal Conditions

A SELL position is opened only when **ALL** of the following conditions are met simultaneously:

#### M1 (1-Minute) Timeframe:
1. **Current candle [0]**: K < D (bearish momentum present)
2. **Last candle [1]**: K < D (bearish momentum confirmed)
3. **Candle [2] before**: D < K (previous bullish momentum)
4. **Candle [3] before**: D < K (earlier bullish momentum)

*This pattern shows a recent crossover from bullish (K>D) to bearish (K<D) momentum with confirmation.*

#### M5 (5-Minute) Timeframe:
1. **Current candle [0]**: K < D (bearish momentum)
2. **Previous candle [1]**: K < D (bearish momentum confirmed)

*Confirms bearish momentum on a higher timeframe.*

#### M15 (15-Minute) Timeframe:
1. **Current candle [0]**: K < D (bearish momentum)
2. **Previous candle [1]**: K < D (bearish momentum confirmed)

*Confirms bearish momentum on the highest analyzed timeframe.*

### BUY Signal Conditions

A BUY position is opened only when **ALL** of the following conditions are met simultaneously:

#### M1 (1-Minute) Timeframe:
1. **Current candle [0]**: K > D (bullish momentum present)
2. **Last candle [1]**: K > D (bullish momentum confirmed)
3. **Candle [2] before**: D > K (previous bearish momentum)
4. **Candle [3] before**: D > K (earlier bearish momentum)

*This pattern shows a recent crossover from bearish (K<D) to bullish (K>D) momentum with confirmation.*

#### M5 (5-Minute) Timeframe:
1. **Current candle [0]**: K > D (bullish momentum)
2. **Previous candle [1]**: K > D (bullish momentum confirmed)

*Confirms bullish momentum on a higher timeframe.*

#### M15 (15-Minute) Timeframe:
1. **Current candle [0]**: K > D (bullish momentum)
2. **Previous candle [1]**: K > D (bullish momentum confirmed)

*Confirms bullish momentum on the highest analyzed timeframe.*

## Key Features

### Multi-Timeframe Confirmation
- **Three Timeframes**: Analyzes M1, M5, and M15 simultaneously
- **Signal Alignment**: All timeframes must agree before trade entry
- **False Signal Filtering**: Multiple timeframe confirmation reduces whipsaws
- **Trend Verification**: Higher timeframes confirm lower timeframe signals

### Precise Entry Logic
- **4-Candle Analysis on M1**: Looks for crossover with confirmation
- **2-Candle Confirmation**: M5 and M15 require consistent momentum
- **No Repainting**: Uses only confirmed candle data
- **Clear Signal Logic**: Detailed logging of all conditions

### Risk Management
- **Position Sizing**: Automatic lot calculation based on risk percentage
- **Fixed Stop Loss**: Configurable SL distance (default: 30 pips)
- **Fixed Take Profit**: Configurable TP distance (default: 50 pips)
- **Spread Filter**: Avoids high-spread entries (max 3 pips default)
- **Position Limits**: Controls concurrent positions (default: 1)

### Trading Controls
- **Time Filter**: Optional trading hours restriction
- **Maximum Positions**: Limits simultaneous open positions
- **Magic Number**: Unique identifier for EA trades
- **Trade Comments**: Labels trades for easy identification

## Installation

1. Open MetaTrader 5
2. Click `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `MultiTimeframeStochasticScalpingEA.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in Navigator
6. The EA appears under "Expert Advisors" in Navigator

## Configuration

### Input Parameters

#### Stochastic Parameters
- **Stoch_K_Period** (default: 14): %K period for stochastic calculation
- **Stoch_D_Period** (default: 3): %D signal line period
- **Stoch_Slowing** (default: 3): Slowing factor for smoothing

#### Risk Management
- **RiskPercent** (default: 1.0%): Risk per trade as percentage of account balance
- **StopLossPips** (default: 30.0): Stop loss distance in pips
- **TakeProfitPips** (default: 50.0): Take profit distance in pips (1.67:1 reward/risk)
- **MaxSpreadPips** (default: 3.0): Maximum acceptable spread in pips

#### Position Management
- **MagicNumber** (default: 987654): Unique identifier for EA's trades
- **TradeComment** (default: "MTFStochScalp"): Comment added to all trades
- **MaxLotSize** (default: 10.0): Maximum position size limit
- **MinLotSize** (default: 0.01): Minimum position size
- **MaxPositions** (default: 1): Maximum concurrent open positions

#### Trading Hours
- **UseTimeFilter** (default: false): Enable/disable time-based trading
- **StartHour** (default: 8): Start trading hour (server time)
- **EndHour** (default: 20): End trading hour (server time)

## Recommended Settings

### Conservative (Recommended for Beginners)
```
Timeframe: M1 (attach EA to M1 chart)
RiskPercent: 0.5%
StopLossPips: 30
TakeProfitPips: 50
MaxSpreadPips: 2.0
MaxPositions: 1
UseTimeFilter: true
StartHour: 8
EndHour: 18
```

### Moderate (Balanced Risk)
```
Timeframe: M1 (attach EA to M1 chart)
RiskPercent: 1.0%
StopLossPips: 30
TakeProfitPips: 50
MaxSpreadPips: 3.0
MaxPositions: 1
UseTimeFilter: true
StartHour: 7
EndHour: 20
```

### Aggressive (Higher Risk - Experienced Traders Only)
```
Timeframe: M1 (attach EA to M1 chart)
RiskPercent: 2.0%
StopLossPips: 25
TakeProfitPips: 45
MaxSpreadPips: 3.5
MaxPositions: 2
UseTimeFilter: false (trade 24/5)
```

## Usage Guide

### Setup

1. **Attach to Chart**:
   - Open any currency pair chart (EURUSD, GBPUSD, USDJPY recommended)
   - **Set timeframe to M1 (1-minute)** - This is critical!
   - Drag and drop MultiTimeframeStochasticScalpingEA from Navigator to chart

2. **Configure Settings**:
   - Adjust parameters based on your risk tolerance
   - Start with Conservative settings for testing
   - Keep default stochastic parameters initially

3. **Enable Auto Trading**:
   - Click "AutoTrading" button in toolbar (or press Alt+A)
   - Verify green checkmark appears in top-right corner
   - Ensure "Allow algorithmic trading" is enabled in Tools → Options

4. **Monitor Performance**:
   - Check "Experts" tab for signal detection and trade execution
   - Review open positions in "Trade" tab
   - Monitor closed trades in "History" tab
   - Observe detailed signal logging

### Understanding Signals

When a signal is detected, the EA logs detailed information:

**Example SELL Signal:**
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

## Strategy Logic Explained

### Why This Strategy Works

1. **Crossover Detection (M1)**:
   - The EA identifies when momentum shifts from bullish to bearish (or vice versa)
   - Requires two candles showing the new direction (0 and 1)
   - Verifies there was opposite momentum before (candles 2 and 3)
   - This confirms a genuine crossover, not just noise

2. **Higher Timeframe Confirmation (M5, M15)**:
   - Ensures the momentum shift is not just a short-term fluctuation
   - M5 and M15 provide "bigger picture" context
   - Reduces false signals from M1 noise
   - Aligns entries with broader market direction

3. **Multi-Timeframe Alignment**:
   - Only trades when all three timeframes show consistent momentum
   - This confluence creates high-probability setups
   - Filters out low-quality signals that only appear on one timeframe

### Signal Rarity

Due to the strict multi-timeframe requirements, signals are **relatively rare**. This is intentional and desirable:
- Higher signal quality
- Reduced overtrading
- Better risk/reward ratios
- Clearer market conditions

## Best Practices

### Trading Setup
- **Always use M1 chart**: The EA analyzes M1, M5, M15 but must be attached to M1
- **Start with demo**: Test for at least 30 days on demo account
- **Use major pairs**: EURUSD, GBPUSD, USDJPY have tighter spreads
- **Low spread times**: Trade during active market hours for better spreads
- **Stable connection**: Use VPS for consistent operation

### Risk Management
- **Start small**: Begin with 0.5% risk per trade
- **One position**: Keep MaxPositions = 1 initially
- **Monitor spread**: Ensure MaxSpreadPips is appropriate for your broker
- **Use stop losses**: Never remove or widen SL on losing trades
- **Track performance**: Review results weekly

### Optimization
- **Don't over-optimize**: Avoid curve-fitting to historical data
- **Test parameter changes**: Always demo test before live implementation
- **Consider market conditions**: Strategy works best in trending markets
- **Review signal quality**: Check if signals align with chart analysis
- **Adjust for broker**: Modify spread/pip settings for your broker's specifications

## Strategy Testing

### Backtesting Setup

1. Press Ctrl+R to open Strategy Tester
2. Select "MultiTimeframeStochasticScalpingEA" from Expert Advisor list
3. Choose symbol (EURUSD recommended)
4. **Select M1 (1-minute) timeframe** (Critical!)
5. Set date range (minimum 3 months for statistical significance)
6. Select "Every tick" model for highest accuracy
7. Configure input parameters
8. Click "Start" to run backtest

### Evaluation Metrics

**Key Performance Indicators:**
- **Win Rate**: 45-60% is typical for this strategy
- **Profit Factor**: > 1.5 desirable
- **Risk/Reward**: Default 1.67:1 (30 pip SL, 50 pip TP)
- **Drawdown**: < 20% acceptable
- **Trade Frequency**: Varies based on market conditions (5-20 trades/day)

### Forward Testing

Before live trading:
1. Run strategy tester to verify logic
2. Test on demo account for 30+ days
3. Monitor performance across different market conditions
4. Verify signal quality matches expectations
5. Check execution quality (slippage, spreads)

## Troubleshooting

### EA Not Trading

**Possible Causes:**
- AutoTrading not enabled → Enable with Alt+A
- Wrong timeframe → Must be on M1 chart
- Spread too high → Check current spread vs MaxSpreadPips
- Outside trading hours → Check UseTimeFilter settings
- No signal alignment → All timeframes must meet conditions

**Solutions:**
- Verify green checkmark in top-right corner
- Confirm chart timeframe is M1
- Wait for active market hours (lower spreads)
- Review Experts tab for specific messages
- Be patient - signals can be infrequent

### No Signals Appearing

**Normal Behavior:**
- Strategy requires precise multi-timeframe alignment
- Signals are intentionally rare for quality
- Market conditions may not meet criteria

**What to Check:**
- Verify all three stochastic indicators are working (check Experts tab)
- Review current stochastic values on M1, M5, M15 charts manually
- Ensure market is not ranging (strategy works best in trends)
- Consider trying different currency pairs
- Wait longer - patience is key

### Orders Rejected

**Common Issues:**
- Insufficient account balance/margin
- Lot size outside broker limits
- Stop loss too tight for broker requirements
- Market closed or no liquidity

**Solutions:**
- Check account balance and free margin
- Verify MinLotSize matches broker minimum
- Increase StopLossPips if broker requires larger stops
- Ensure market is open for trading
- Review error codes in Experts tab

### Signal Logic Questions

**Why so many conditions?**
- Multi-timeframe confirmation reduces false signals
- Crossover verification (checking candles 2-3) confirms genuine momentum shift
- Quality over quantity approach

**Can I reduce requirements?**
- Not recommended - it defeats the strategy's purpose
- Removing conditions will increase false signals
- Test any modifications extensively on demo first

## Important Notes

### What This EA Provides

✅ **Fully automated scalping** based on multi-timeframe stochastic analysis
✅ **High-quality signals** with strict multi-timeframe confirmation
✅ **Crossover detection** with momentum verification on M1
✅ **Risk management** with automatic position sizing and SL/TP
✅ **Detailed logging** of all signal conditions for transparency

### What This EA Does NOT Provide

❌ **Guaranteed profits** - No trading system is perfect
❌ **High-frequency trading** - Signals are selective, not frequent
❌ **News event handling** - Manual intervention needed during high-impact news
❌ **Adaptive parameters** - Uses fixed stochastic settings
❌ **Grid or martingale** - Strictly follows risk management rules

## Risk Warnings

### Critical Disclaimers

⚠️ **HIGH RISK ACTIVITY**
- Forex trading carries substantial risk of loss
- You can lose 100% of your trading capital
- Past performance does not guarantee future results
- This EA is not a "holy grail" - losses WILL occur

⚠️ **SCALPING-SPECIFIC RISKS**
- M1 timeframe can generate many signals
- High spread costs due to frequent trading
- Slippage can significantly impact results
- Broker execution quality is critical

⚠️ **MULTI-TIMEFRAME COMPLEXITY**
- Strategy requires perfect alignment across 3 timeframes
- Signals are rare - don't expect constant trading
- Long periods without trades are normal
- Patience is essential

### Required Actions Before Live Trading

1. ✅ **Test Extensively**: MANDATORY 30+ days demo testing
2. ✅ **Start Conservative**: Begin with 0.5% risk
3. ✅ **Use Major Pairs**: Stick to liquid pairs with low spreads
4. ✅ **Monitor Performance**: Check results daily
5. ✅ **Accept Responsibility**: All trading risks are yours

### Market Conditions

**Best Conditions:**
- Trending markets (directional movement)
- Active trading hours (European/US overlap)
- Normal volatility (not too choppy)
- Low spread environment
- Stable broker execution

**Poor Conditions:**
- Ranging/consolidating markets
- High-impact news releases
- Very high or very low volatility
- Wide spreads (> 3 pips typically)
- Illiquid trading hours

## Advanced Configuration

### Stochastic Parameter Tuning

The default stochastic settings (14, 3, 3) work well for most conditions. However, you can adjust:

**Faster Signals** (More trades, potentially more false signals):
```
Stoch_K_Period: 9
Stoch_D_Period: 3
Stoch_Slowing: 3
```

**Slower Signals** (Fewer trades, potentially higher quality):
```
Stoch_K_Period: 21
Stoch_D_Period: 5
Stoch_Slowing: 5
```

**Warning:** Always test parameter changes extensively on demo before live use!

### Time Filter Configuration

For optimal spread conditions:
```
UseTimeFilter: true
StartHour: 7 (London opening)
EndHour: 16 (US afternoon)
```

This captures the most liquid trading hours with typically tighter spreads.

### Position Management Options

**Single Position (Conservative):**
```
MaxPositions: 1
RiskPercent: 1.0%
```

**Multiple Positions (Aggressive):**
```
MaxPositions: 2
RiskPercent: 0.5% per trade
```

## Support & Resources

### Learning Resources

1. Study stochastic oscillator theory
2. Understand multi-timeframe analysis
3. Learn proper risk management
4. Practice on demo before live trading
5. Keep a trading journal

### Performance Monitoring

Track these metrics:
- Win rate percentage
- Average win vs average loss
- Profit factor
- Maximum drawdown
- Trade frequency
- Spread costs

### Community & Updates

- Share experiences with other traders
- Report bugs or issues
- Suggest improvements
- Test new versions thoroughly

## Conclusion

MultiTimeframeStochasticScalpingEA is a sophisticated trading tool that combines multi-timeframe analysis with strict signal confirmation. By requiring alignment across M1, M5, and M15 timeframes, it filters out low-quality signals and focuses on high-probability trading opportunities.

**Success with this EA requires:**
- Patience (signals are selective)
- Discipline (follow risk management rules)
- Testing (30+ days on demo minimum)
- Understanding (know how the strategy works)
- Monitoring (check performance regularly)

Remember: This EA is a tool, not a guarantee. Successful trading requires proper risk management, realistic expectations, and continuous learning.

---

**Disclaimer:** Trading forex carries a high level of risk and may not be suitable for all investors. The possibility exists that you could sustain a loss in excess of your deposited funds. Before deciding to trade, you should carefully consider your investment objectives, level of experience, and risk appetite. Only trade with money you can afford to lose.
