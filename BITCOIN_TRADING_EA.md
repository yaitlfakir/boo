# Bitcoin Trading EA for MetaTrader 5

## Overview

The **BitcoinTradingEA** is an automated trading Expert Advisor specifically designed for Bitcoin (BTCUSD) trading on MetaTrader 5. Unlike traditional forex EAs, this robot is optimized for cryptocurrency's unique characteristics including high volatility, 24/7 trading, and larger price swings.

## Key Features

### Bitcoin-Optimized Strategy
- **EMA Crossover System**: Uses 12/26/9 EMA periods (MACD-style) for trend identification
- **RSI Confirmation**: RSI indicator with adjusted levels (35/65) for Bitcoin's volatility
- **ATR-Based Dynamic SL/TP**: Automatically adjusts stops based on current market volatility
- **Volatility Filter**: Only trades when ATR is within specified range (100-2000 pips)
- **Trend Strength Filter**: ADX indicator ensures trades only in trending markets

### Advanced Risk Management
- **Dynamic Position Sizing**: Calculates lot size based on account balance and risk percentage
- **Volatility-Adjusted Stops**: Uses ATR multiplier for intelligent stop placement
- **Spread Filter**: Avoids trading during high spread conditions (max 50 pips)
- **Maximum Position Limit**: Controls exposure with position count limits
- **Trailing Stop**: Protects profits as Bitcoin price moves favorably

### Multiple Trading Modes
- **Fixed SL/TP Mode**: Traditional pip-based stops (500/1000 pips default)
- **Dynamic SL/TP Mode**: ATR-based adaptive stops (recommended for Bitcoin)
- **Volatility Filtering**: Only trades in optimal volatility conditions
- **Trend Filtering**: Uses ADX to avoid choppy markets

## Installation

1. Open MetaTrader 5
2. Click `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `BitcoinTradingEA.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in Navigator
6. The EA appears under "Expert Advisors" in Navigator

## Configuration Guide

### Trading Strategy Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| FastEMA_Period | 12 | Fast EMA period (MACD fast line) |
| SlowEMA_Period | 26 | Slow EMA period (MACD slow line) |
| SignalEMA_Period | 9 | Signal EMA period (momentum confirmation) |
| RSI_Period | 14 | RSI calculation period |
| RSI_Oversold | 35 | RSI oversold level (adjusted for BTC) |
| RSI_Overbought | 65 | RSI overbought level (adjusted for BTC) |
| ATR_Period | 14 | ATR period for volatility measurement |
| ATR_Multiplier | 2.0 | Multiplier for ATR-based SL/TP |

### Risk Management Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| RiskPercent | 1.0% | Risk per trade as % of balance |
| StopLossPips | 500.0 | Base stop loss in pips (fixed mode) |
| TakeProfitPips | 1000.0 | Base take profit in pips (fixed mode) |
| UseDynamicSLTP | true | Use ATR-based dynamic stops (recommended) |
| MaxSpreadPips | 50.0 | Maximum allowed spread in pips |
| UseTrailingStop | true | Enable trailing stop feature |
| TrailingStopPips | 300.0 | Trailing stop distance in pips |
| TrailingStepPips | 100.0 | Minimum movement to adjust trailing stop |

### Position Management Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| MagicNumber | 789456 | Unique identifier for EA's trades |
| TradeComment | "BTC-EA" | Comment added to all trades |
| MaxLotSize | 10.0 | Maximum position size |
| MinLotSize | 0.01 | Minimum position size |
| MaxOpenPositions | 1 | Maximum concurrent positions |

### Volatility Filter Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| UseVolatilityFilter | true | Enable volatility filtering |
| MinATR | 100.0 | Minimum ATR in pips to trade |
| MaxATR | 2000.0 | Maximum ATR in pips to trade |

### Trend Strength Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| UseTrendFilter | true | Enable trend strength filtering |
| ADX_Period | 14 | ADX calculation period |
| MinADX | 20.0 | Minimum ADX for trend confirmation |

### Trading Hours Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| UseTimeFilter | false | Enable time-based trading restrictions |
| StartHour | 0 | Start trading hour (0-23) |
| EndHour | 23 | End trading hour (0-23) |

## Trading Strategy Explained

### Entry Signals

**BUY Signal (Long Position)**:
1. Fast EMA (12) crosses **above** Slow EMA (26)
2. Fast EMA is **above** Signal EMA (9) - momentum confirmation
3. RSI is **below** 65 (not overbought)
4. ATR is within acceptable range (100-2000 pips)
5. ADX is **above** 20 (trending market)
6. Spread is **below** 50 pips

**SELL Signal (Short Position)**:
1. Fast EMA (12) crosses **below** Slow EMA (26)
2. Fast EMA is **below** Signal EMA (9) - momentum confirmation
3. RSI is **above** 35 (not oversold)
4. ATR is within acceptable range (100-2000 pips)
5. ADX is **above** 20 (trending market)
6. Spread is **below** 50 pips

### Stop Loss & Take Profit

**Dynamic Mode (Recommended for Bitcoin)**:
- Stop Loss = Entry Price ± (ATR × 2.0)
- Take Profit = Entry Price ± (ATR × 4.0)
- Automatically adjusts to market volatility
- Wider stops during high volatility
- Tighter stops during low volatility

**Fixed Mode**:
- Stop Loss = 500 pips from entry
- Take Profit = 1000 pips from entry
- Consistent across all market conditions

### Trailing Stop

When enabled, the EA moves your stop loss to protect profits:
- **Activation**: After price moves 300 pips in profit
- **Distance**: Trails 300 pips behind current price
- **Step**: Updates every 100 pip movement
- **Direction**: Only moves in favorable direction, never against you

## Usage Instructions

### Step 1: Setup Symbol
1. Open BTCUSD chart in MetaTrader 5
2. Recommended timeframes: **H1** (1 hour) or **H4** (4 hours)
3. Ensure your broker offers BTCUSD or BTC/USD trading

### Step 2: Attach EA
1. Locate "BitcoinTradingEA" in Navigator under Expert Advisors
2. Drag and drop onto BTCUSD chart
3. Configure parameters in the settings dialog
4. Click "OK" to activate

### Step 3: Enable Auto Trading
1. Click "AutoTrading" button in toolbar (or press Alt+A)
2. Verify green checkmark appears in top-right corner of chart
3. Ensure "Allow algorithmic trading" is enabled:
   - Tools → Options → Expert Advisors tab
   - Check "Allow algorithmic trading"

### Step 4: Monitor Performance
1. **Experts Tab**: View EA activity logs and trade decisions
2. **Trade Tab**: Monitor open positions in real-time
3. **History Tab**: Review closed trades and performance
4. **Chart**: Watch for entry/exit signals

## Recommended Settings

### Conservative (Low Risk)
Best for beginners and smaller accounts:
```
RiskPercent: 0.5%
UseDynamicSLTP: true
ATR_Multiplier: 2.5
MaxOpenPositions: 1
UseVolatilityFilter: true
UseTrendFilter: true
```

### Moderate (Balanced Risk)
Default settings - good balance:
```
RiskPercent: 1.0%
UseDynamicSLTP: true
ATR_Multiplier: 2.0
MaxOpenPositions: 1
UseVolatilityFilter: true
UseTrendFilter: true
```

### Aggressive (High Risk)
For experienced traders with higher risk tolerance:
```
RiskPercent: 2.0%
UseDynamicSLTP: true
ATR_Multiplier: 1.5
MaxOpenPositions: 2
UseVolatilityFilter: false
UseTrendFilter: false
```

## Backtesting Guide

### Strategy Tester Setup

1. **Open Strategy Tester**: Press Ctrl+R or View → Strategy Tester
2. **Select EA**: Choose "BitcoinTradingEA" from dropdown
3. **Choose Symbol**: Select BTCUSD or BTC/USD
4. **Select Timeframe**: H1 or H4 recommended
5. **Set Period**: 
   - Short-term: 3-6 months
   - Long-term: 1-2 years (better statistical significance)
6. **Select Model**: 
   - "Every tick" (most accurate but slower)
   - "1 minute OHLC" (faster, good balance)
7. **Configure Inputs**: Set your desired parameters
8. **Start Test**: Click "Start" button

### Analyzing Results

**Key Metrics to Review**:
- **Total Net Profit**: Overall profitability
- **Profit Factor**: Should be > 1.5 (higher is better)
- **Win Rate**: Aim for > 40% for trend-following strategies
- **Max Drawdown**: Should be < 30% of account
- **Sharpe Ratio**: Risk-adjusted returns (> 1.0 is good)
- **Recovery Factor**: Net Profit / Max Drawdown (> 3.0 is excellent)

**Red Flags**:
- Win rate < 30%
- Profit factor < 1.2
- Max drawdown > 50%
- Long periods without trades
- Too many small losses

## Bitcoin-Specific Considerations

### Why Bitcoin is Different

1. **24/7 Trading**: No market close, continuous price action
2. **High Volatility**: Larger price swings than forex (500+ pip moves common)
3. **Weekend Gaps**: Can experience gaps even though market is open
4. **News Sensitivity**: Highly reactive to regulatory and adoption news
5. **Correlation**: Often moves independently of traditional markets

### Optimization for Bitcoin

The EA addresses these differences:

- **Larger Stop Losses**: 500 pips vs 15-50 in forex
- **Dynamic Stops**: ATR-based sizing adapts to volatility
- **Volatility Filtering**: Avoids trading in extreme conditions
- **No Time Filter Default**: Works 24/7 (can enable if desired)
- **Higher Spread Tolerance**: 50 pips vs 2-3 in forex
- **Adjusted RSI Levels**: 35/65 vs 30/70 for crypto volatility

## Risk Warnings

⚠️ **CRITICAL DISCLAIMERS**:

1. **High Risk**: Bitcoin trading is extremely volatile and risky
2. **Capital Loss**: You can lose 100% of your trading capital
3. **No Guarantees**: Past performance does not predict future results
4. **Demo First**: ALWAYS test extensively on demo accounts
5. **Start Small**: Begin with minimum risk settings (0.5%)
6. **Monitor Closely**: Check EA performance daily
7. **Market Conditions**: Strategy may not work in all market regimes
8. **Broker Dependency**: Results vary by broker execution quality
9. **Slippage**: Bitcoin markets can experience significant slippage
10. **Not Financial Advice**: This EA is for educational purposes only

### Best Practices

✅ **DO**:
- Test on demo account for at least 30 days
- Start with conservative risk settings
- Monitor EA performance daily
- Keep MetaTrader 5 running continuously
- Ensure stable internet connection
- Use reputable broker with good Bitcoin spreads
- Review and adjust parameters monthly
- Keep trading journal

❌ **DON'T**:
- Use real money without extensive testing
- Risk more than 1-2% per trade initially
- Run multiple EAs with same magic number
- Ignore error messages in Experts tab
- Trade with insufficient account balance
- Use maximum leverage
- Expect consistent profits immediately
- Set unrealistic profit expectations

## Troubleshooting

### EA Not Trading

**Check:**
1. AutoTrading is enabled (Alt+A)
2. Spread is within MaxSpreadPips limit (check Market Watch)
3. ATR is within MinATR/MaxATR range (add ATR indicator to check)
4. ADX is above MinADX if trend filter enabled (add ADX indicator)
5. No existing positions if MaxOpenPositions = 1
6. Sufficient account balance for minimum lot size
7. Symbol is correct (BTCUSD or broker's BTC symbol)

**Expert Tab Messages:**
- Review Experts tab for detailed error messages
- Common issues: insufficient funds, invalid stops, market closed

### Invalid Stop Loss/Take Profit

**Causes:**
- Stops too close to current price
- Broker's minimum stop level not met
- Invalid price calculation

**Solutions:**
1. Increase StopLossPips if using fixed mode
2. Check broker's SYMBOL_TRADE_STOPS_LEVEL
3. Verify UseDynamicSLTP is enabled for auto-adjustment

### Lot Size Errors

**Error: "Invalid volume"**
- Calculated lot size outside broker limits
- Reduce RiskPercent
- Check broker's minimum/maximum lot sizes

**Error: "Not enough money"**
- Account balance too low for calculated position
- Reduce RiskPercent
- Increase account balance

### No Indicator Data

**Error: "Error initializing indicators"**
- BTCUSD chart not opened
- Insufficient historical data
- Restart MetaTrader 5

## Performance Optimization

### Timeframe Selection

**H1 (1 Hour)**:
- More signals, more trades
- Higher trading frequency
- Better for active management
- More sensitive to noise

**H4 (4 Hours)**:
- Fewer but higher quality signals
- Lower trading frequency
- Better for swing trading
- More stable trends

**Daily (D1)**:
- Very few signals
- Long-term trend following
- Lowest trading frequency
- Best for set-and-forget approach

### Parameter Tuning

**For Trending Markets**:
- Increase ATR_Multiplier to 2.5-3.0
- Decrease MinADX to 15
- Use H4 or Daily timeframe

**For Ranging Markets**:
- Decrease ATR_Multiplier to 1.5-2.0
- Increase MinADX to 25
- Use H1 timeframe
- Enable volatility filter strictly

**For High Volatility**:
- Increase MaxATR to 3000+
- Use wider trailing stops (500+ pips)
- Reduce position size (0.5% risk)

**For Low Volatility**:
- Decrease MinATR to 50
- Use tighter stops
- Can increase risk slightly (1.5%)

## Advanced Features

### Multi-Symbol Support

While optimized for Bitcoin, the EA can trade other cryptocurrencies:
- ETHUSD (Ethereum)
- LTCUSD (Litecoin)
- XRPUSD (Ripple)

**Adjustments Needed**:
- Different volatility ranges (adjust MinATR/MaxATR)
- Different spread tolerances
- Different lot sizes based on asset price

### Integration with Other EAs

Can run alongside other EAs if:
- Different MagicNumbers used
- Different symbols traded
- Sufficient account balance for all
- MetaTrader 5 has enough resources

## Support & Updates

### Getting Help

1. Check Experts tab for detailed logs
2. Review this documentation thoroughly
3. Test in Strategy Tester to reproduce issues
4. Verify broker supports Bitcoin trading

### Suggested Enhancements

Future versions could include:
- Multi-timeframe confirmation
- Volume-based filters
- Correlation with traditional markets
- News event filtering
- Partial position closing
- Grid/martingale options (not recommended)

## License & Disclaimer

This Expert Advisor is provided for **educational and research purposes only**.

**No Warranty**: The EA is provided "as-is" without any guarantees of profitability or fitness for a particular purpose.

**Trading Risk**: Trading cryptocurrencies involves substantial risk of loss. Only trade with capital you can afford to lose completely.

**Not Financial Advice**: This EA does not constitute financial, investment, or trading advice. Consult with a qualified financial advisor before trading.

## Technical Specifications

- **Language**: MQL5
- **Platform**: MetaTrader 5 build 3300+
- **Indicators Used**: EMA, RSI, ATR, ADX
- **Trade Library**: CTrade class
- **Minimum Account**: $100-500 recommended
- **Required Symbols**: BTCUSD or broker equivalent
- **Timeframes**: H1, H4, D1 recommended
- **Lot Step**: Depends on broker (typically 0.01)

## Version History

**Version 1.00** - Initial Release
- EMA crossover strategy with RSI confirmation
- ATR-based dynamic stop loss and take profit
- Volatility filtering with ATR
- Trend strength filtering with ADX
- Trailing stop functionality
- Multiple risk management options
- Bitcoin-optimized parameters

---

**Happy Trading! Remember: Always test on demo first, start with small position sizes, and never risk more than you can afford to lose.**
