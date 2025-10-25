# MetaTrader 5 Expert Advisors Collection

A collection of Expert Advisors (EAs) for MetaTrader 5, including automated trading and signal generation tools.

## Available Expert Advisors

### 1. EurusdPredictorEA - EURUSD Price Movement Predictor ⭐ NEW
A specialized signal-generating EA for EURUSD that predicts price movement using multi-indicator analysis and displays clear UP/DOWN signals on the chart. Perfect for traders who want intelligent signal assistance without automated trading.

### 2. BitcoinTradingEA - Automated Bitcoin Trading Robot
An automated trading EA specifically designed for Bitcoin (BTCUSD) with cryptocurrency-optimized volatility management, dynamic stops, and trend filtering.

### 3. ScalpingEA - Automated Scalping with Risk Management
An automated trading EA that uses scalping strategies with comprehensive risk management.

### 4. MultiTimeframeSignalEA - Buy/Sell Signal Indicator
A signal-generating EA that analyzes multiple timeframes to display buy and sell signals on the chart.

### 5. TrailingManager - Comprehensive Trading & Risk Management
An advanced EA that combines automatic position opening with sophisticated trailing stop, break-even, and trailing take-profit management. Features comprehensive risk controls including daily loss limits, position limits, and intelligent trade entry.

### 6. StochasticSellEA - Automated Sell Trading with Stochastic Crossover
An automated trading EA that opens SELL positions based on Stochastic Oscillator crossover above 60 level, combined with momentum reversal and Moving Average confirmation.

---

## EurusdPredictorEA

### Overview
A specialized signal-generating Expert Advisor designed exclusively for EURUSD currency pair. It analyzes price movements using a sophisticated multi-indicator scoring system and displays clear visual signals (UP/DOWN) to predict future price direction. This is a **signal-only EA** - it provides trading signals but does not execute trades automatically.

### Features

#### Intelligent Price Prediction
- **Multi-Indicator Analysis**: Combines 5 technical analysis methods for comprehensive market view
- **Weighted Scoring System**: Assigns points to different signal strengths (threshold: 5+ points)
- **Real-time Signal Generation**: Analyzes every new bar formation
- **EURUSD Optimized**: Parameters specifically tuned for EURUSD behavior

#### Technical Analysis Components
1. **EMA Crossover** (12/26 periods): Primary trend identification and reversal signals
2. **EMA Trend Analysis**: Confirms overall market direction
3. **RSI Indicator** (14 period): Momentum analysis and overbought/oversold detection
4. **MACD** (12/26/9): Trend strength and momentum shift confirmation
5. **Price vs Signal EMA** (9 period): Price position relative to trend

#### Visual Signal Display
- **UP Signals**: Green arrow (↑) with optional "UP" text when bullish conditions met
- **DOWN Signals**: Red arrow (↓) with optional "DOWN" text when bearish conditions met
- **Customizable Appearance**: Adjustable colors, sizes, and text display
- **Persistent Signals**: Signals remain on chart for historical reference

#### Alert System
- **Audio Alerts**: Sound notification when signal is detected
- **Push Notifications**: Send alerts to MetaTrader mobile app
- **Email Alerts**: Email notifications for important signals
- **Detailed Logging**: Complete signal information with indicator values in Experts tab

### Installation

1. Open MetaTrader 5
2. Click `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `EurusdPredictorEA.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in Navigator
6. The EA appears under "Expert Advisors" in Navigator

### Quick Start Configuration

#### For Day Trading (Recommended)
- **Timeframe**: H1 (1 hour)
- **SignalSize**: 3
- **EnableAudioAlerts**: true
- **RSI_UpLevel**: 55.0
- **RSI_DownLevel**: 45.0

#### For Swing Trading
- **Timeframe**: H4 (4 hours)
- **SignalSize**: 3
- **RSI_UpLevel**: 60.0
- **RSI_DownLevel**: 40.0

#### For Scalping
- **Timeframe**: M15 (15 minutes)
- **SignalSize**: 2
- **RSI_UpLevel**: 52.0
- **RSI_DownLevel**: 48.0

### Usage

1. **Attach to Chart**:
   - Open **EURUSD** chart (EA is designed specifically for EURUSD)
   - Recommended timeframe: **H1** (1 hour) for balanced signals
   - Drag and drop EurusdPredictorEA from Navigator to chart

2. **Configure Settings**:
   - Adjust parameters based on your trading style
   - Default settings work well for most traders
   - Enable desired alert types

3. **Enable Auto Trading**:
   - Click "AutoTrading" button in toolbar (or press Alt+A)
   - Verify green checkmark appears in top-right corner
   - Note: Even though EA doesn't trade, AutoTrading must be enabled

4. **Interpret Signals**:
   - **UP Arrow (Green)**: Indicators suggest upward price movement
   - **DOWN Arrow (Red)**: Indicators suggest downward price movement
   - Check Experts tab for detailed signal information and scores

### How the Prediction Works

The EA uses a sophisticated scoring system:

**Signal Generation Process:**
1. Analyzes 5 different technical indicators
2. Assigns points based on bullish/bearish conditions (max 9 points each direction)
3. Generates signal only when score ≥ 5 AND higher than opposite direction
4. Displays visual arrow and optional text on chart

**Scoring Breakdown:**
- EMA Crossover: 2 points (strong reversal signal)
- EMA Trend: 1 point (current direction)
- RSI Analysis: 2 points (momentum confirmation)
- MACD Analysis: 2 points (trend strength)
- Price Position: 1 point (relative strength)

**Example Strong Signal:**
```
UP Score: 7 points
- Fast EMA crosses above Slow EMA (+2)
- Fast EMA above Slow EMA (+1)
- RSI > 55 and rising (+2)
- MACD above signal (+1)
- Price above Signal EMA (+1)
Result: Strong UP signal displayed
```

### Documentation

See [EURUSD_PREDICTOR_EA.md](EURUSD_PREDICTOR_EA.md) for comprehensive documentation including:
- Detailed parameter explanations
- Configuration profiles (Conservative, Balanced, Aggressive)
- Signal interpretation guide
- Trading strategies and best practices
- Troubleshooting guide
- FAQ section

See [EURUSD_PREDICTOR_QUICKSTART.md](EURUSD_PREDICTOR_QUICKSTART.md) for:
- 5-minute setup guide
- Quick reference for signals
- Common questions
- Basic trading tips

### Important Notes

✅ **This EA**:
- Analyzes EURUSD price movements
- Displays visual UP/DOWN signals
- Provides alerts when signals appear
- Helps you make informed trading decisions

❌ **This EA Does NOT**:
- Execute trades automatically
- Guarantee profits or accuracy
- Work on other currency pairs by default
- Replace proper market analysis
- Eliminate trading risk

### Best Practices

**Signal Interpretation:**
- Wait 1-2 bars after signal for confirmation
- Check higher timeframe for trend alignment
- Use signals in combination with support/resistance levels
- Always use proper risk management (stop loss, position sizing)

**Recommended Approach:**
1. Watch signals for 1 week without trading (observation)
2. Test on demo account for 2-4 weeks
3. Start live trading with minimum lot sizes
4. Gradually increase position size as you gain confidence

### Risk Warnings

⚠️ **CRITICAL DISCLAIMERS**:
- **Not 100% Accurate**: Technical analysis cannot predict the future with certainty
- **Demo Testing Required**: ALWAYS test extensively on demo accounts first
- **Proper Risk Management**: Use stop losses and never risk more than 1-2% per trade
- **Market Unpredictability**: News events and market conditions can override technical signals
- **Not Financial Advice**: This EA is for educational purposes only
- **No Guarantees**: Past signal performance does not guarantee future results

### Strategy Testing

To evaluate signal quality:
1. Press Ctrl+R to open Strategy Tester
2. Select "EurusdPredictorEA" from Expert Advisor list
3. Choose EURUSD symbol
4. Select timeframe (H1 or H4 recommended)
5. Set date range (minimum 3 months)
6. Click "Start" to run backtest
7. Review signal history in Experts log (signals don't show visually in tester)

### Troubleshooting

**EA not working:**
- Verify chart symbol is EURUSD
- Check that AutoTrading is enabled
- Ensure "Allow algorithmic trading" in Tools → Options → Expert Advisors
- Check Experts tab for error messages

**No signals appearing:**
- Be patient - signals require strong conditions (score ≥ 5)
- Try different timeframes (H1 or H4)
- Market may be in consolidation (no clear direction)
- Check indicator parameters

**Wrong symbol error:**
- EA is designed for EURUSD only
- Attach only to EURUSD charts
- Set `CheckSymbol = false` to disable restriction (not recommended)

---

## BitcoinTradingEA

### Overview
An automated trading Expert Advisor specifically designed for Bitcoin (BTCUSD) trading on MetaTrader 5. Unlike traditional forex EAs, this robot is optimized for cryptocurrency's unique characteristics including high volatility, 24/7 trading, and larger price swings.

### Features

#### Bitcoin-Optimized Trading Strategy
- **EMA Crossover System**: Uses 12/26/9 EMA periods (MACD-style) for trend identification
- **RSI Confirmation**: Adjusted levels (35/65) for Bitcoin's higher volatility
- **ATR-Based Dynamic SL/TP**: Automatically adapts stops to current market volatility
- **Volatility Filter**: Only trades when ATR is within optimal range (100-2000 pips)
- **Trend Strength Filter**: ADX indicator ensures trades only in trending markets

#### Advanced Risk Management
- **Dynamic Position Sizing**: Calculates lot size based on account balance and risk percentage
- **Volatility-Adjusted Stops**: Uses ATR multiplier for intelligent stop placement
- **Spread Filter**: Avoids trading during high spread conditions (max 50 pips)
- **Maximum Position Limit**: Controls exposure with position count limits
- **Trailing Stop**: Protects profits as Bitcoin price moves favorably (300 pips trail distance)

#### Key Differences from Forex EAs
- **Larger Stop Losses**: 500-1000 pips vs 15-50 in forex
- **Dynamic Stops**: ATR-based sizing adapts to Bitcoin's volatility
- **Higher Spread Tolerance**: 50 pips vs 2-3 in forex
- **24/7 Trading**: No time filter by default (can be enabled)
- **Volatility Management**: Comprehensive ATR-based filters

### Installation

1. Open MetaTrader 5
2. Click `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `BitcoinTradingEA.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in Navigator
6. The EA appears under "Expert Advisors" in Navigator

### Quick Start Configuration

#### Conservative (Recommended for Beginners)
- **RiskPercent**: 0.5%
- **UseDynamicSLTP**: true
- **ATR_Multiplier**: 2.5
- **MaxOpenPositions**: 1
- **Timeframe**: H4 (4 hours)

#### Moderate (Balanced Risk)
- **RiskPercent**: 1.0%
- **UseDynamicSLTP**: true
- **ATR_Multiplier**: 2.0
- **MaxOpenPositions**: 1
- **Timeframe**: H1 (1 hour)

#### Aggressive (High Risk - Experienced Traders Only)
- **RiskPercent**: 2.0%
- **UseDynamicSLTP**: true
- **ATR_Multiplier**: 1.5
- **MaxOpenPositions**: 2
- **Timeframe**: H1 (1 hour)

### Usage

1. **Attach to Chart**:
   - Open BTCUSD chart (ensure your broker offers Bitcoin)
   - Recommended timeframes: **H1** (1 hour) or **H4** (4 hours)
   - Drag and drop BitcoinTradingEA from Navigator to chart

2. **Configure Settings**:
   - Adjust parameters based on your risk tolerance
   - Enable UseDynamicSLTP for automatic volatility adjustment
   - Start with conservative settings (0.5% risk)

3. **Enable Auto Trading**:
   - Click "AutoTrading" button in toolbar (or press Alt+A)
   - Verify green checkmark appears in top-right corner
   - Ensure "Allow algorithmic trading" is enabled in Tools → Options → Expert Advisors

4. **Monitor Performance**:
   - Check "Experts" tab for EA activity and signals
   - Review open positions in "Trade" tab
   - Monitor closed trades in "History" tab

### Strategy Testing

To backtest the EA on Bitcoin:
1. Press Ctrl+R to open Strategy Tester
2. Select "BitcoinTradingEA" from Expert Advisor list
3. Choose BTCUSD symbol
4. Select H1 or H4 timeframe
5. Set date range (minimum 6 months for statistical significance)
6. Select "Every tick" model for accuracy
7. Configure input parameters
8. Click "Start" to run backtest

### Documentation

See [BITCOIN_TRADING_EA.md](BITCOIN_TRADING_EA.md) for comprehensive documentation including:
- Detailed parameter explanations
- Trading strategy breakdown
- Advanced configuration options
- Troubleshooting guide
- Performance optimization tips
- Bitcoin-specific considerations

### Risk Warnings for Bitcoin Trading

⚠️ **CRITICAL DISCLAIMERS**:
- **High Volatility**: Bitcoin can move 5-10% or more in a single day
- **24/7 Market**: Prices change constantly, even on weekends
- **High Risk**: You can lose 100% of your trading capital
- **Demo Testing Required**: ALWAYS test extensively on demo accounts first
- **Start Small**: Begin with 0.5% risk and minimum position sizes
- **Not Financial Advice**: This EA is for educational purposes only

**Bitcoin-Specific Risks**:
- Extreme volatility during news events
- Large weekend gaps despite 24/7 trading
- High spreads during low liquidity periods
- Slippage during rapid price movements
- Regulatory news can cause sudden crashes

### Best Practices

✅ **DO**:
- Test on demo account for at least 30 days
- Start with 0.5% risk per trade
- Monitor EA performance daily
- Use H1 or H4 timeframes
- Ensure stable internet and VPS hosting
- Keep MetaTrader 5 running continuously

❌ **DON'T**:
- Use real money without extensive testing
- Risk more than 1-2% per trade initially
- Use maximum leverage
- Ignore error messages in Experts tab
- Expect consistent profits immediately
- Trade with insufficient account balance

---

## ScalpingEA

### Features

#### Trading Strategy
- **Dual Moving Average Crossover**: Uses Fast EMA (5) and Slow EMA (20) for trend identification
- **RSI Confirmation**: RSI indicator to confirm oversold/overbought conditions
- **Scalping Approach**: Quick entry and exit for small, consistent profits
- **One Position at a Time**: Reduces risk by limiting exposure

### Risk Management
- **Position Sizing**: Automatically calculates lot size based on risk percentage
- **Stop Loss & Take Profit**: Fixed pip-based risk/reward levels
- **Trailing Stop**: Protects profits by moving stop loss in favorable direction
- **Spread Filter**: Avoids trading during high spread conditions
- **Time Filter**: Restricts trading to optimal hours

### Installation

1. Open MetaTrader 5
2. Click on `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `ScalpingEA.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in the Navigator panel
6. The EA should appear under "Expert Advisors" in the Navigator

### Configuration

#### Trading Parameters
- **FastMA_Period** (default: 5): Period for fast moving average
- **SlowMA_Period** (default: 20): Period for slow moving average
- **RSI_Period** (default: 14): RSI calculation period
- **RSI_Oversold** (default: 30): RSI level for oversold condition
- **RSI_Overbought** (default: 70): RSI level for overbought condition

#### Risk Management
- **RiskPercent** (default: 1.0%): Risk per trade as percentage of account balance
- **StopLossPips** (default: 15.0): Stop loss distance in pips
- **TakeProfitPips** (default: 25.0): Take profit distance in pips
- **MaxSpreadPips** (default: 2.0): Maximum allowed spread in pips
- **UseTrailingStop** (default: true): Enable/disable trailing stop
- **TrailingStopPips** (default: 10.0): Distance of trailing stop from current price
- **TrailingStepPips** (default: 5.0): Minimum price movement to adjust trailing stop

#### Position Management
- **MagicNumber** (default: 123456): Unique identifier for EA's trades
- **TradeComment** (default: "ScalpEA"): Comment added to trades
- **MaxLotSize** (default: 10.0): Maximum position size
- **MinLotSize** (default: 0.01): Minimum position size

#### Trading Hours
- **UseTimeFilter** (default: true): Enable/disable time-based trading
- **StartHour** (default: 8): Start trading hour (server time)
- **EndHour** (default: 20): End trading hour (server time)

### Usage

1. **Attach to Chart**:
   - Open a currency pair chart (recommended: EURUSD, GBPUSD, USDJPY)
   - Use M5 or M15 timeframe for scalping
   - Drag and drop the ScalpingEA from Navigator to the chart

2. **Configure Settings**:
   - Adjust input parameters based on your risk tolerance
   - Lower timeframes (M1, M5) are more aggressive
   - Higher risk percentage = larger positions

3. **Enable Auto Trading**:
   - Click the "AutoTrading" button in the toolbar (or press Alt+A)
   - Ensure "Allow algorithmic trading" is enabled in Tools → Options → Expert Advisors

4. **Monitor Performance**:
   - Check the "Experts" tab for EA activity logs
   - Review open positions in the "Trade" tab
   - Monitor account history in the "History" tab

### Risk Warnings

⚠️ **Important Disclaimers**:
- Trading forex carries a high level of risk and may not be suitable for all investors
- Never risk more than you can afford to lose
- Past performance is not indicative of future results
- Always test the EA on a demo account before using real money
- Use the Strategy Tester in MetaTrader 5 to backtest the strategy
- The EA is provided as-is without any guarantees

### Recommended Settings

#### Conservative (Low Risk)
- RiskPercent: 0.5%
- StopLossPips: 20
- TakeProfitPips: 30
- MaxSpreadPips: 1.5

#### Moderate (Medium Risk)
- RiskPercent: 1.0%
- StopLossPips: 15
- TakeProfitPips: 25
- MaxSpreadPips: 2.0

#### Aggressive (High Risk)
- RiskPercent: 2.0%
- StopLossPips: 10
- TakeProfitPips: 20
- MaxSpreadPips: 2.5

### Strategy Testing

To backtest the EA:
1. Press Ctrl+R to open Strategy Tester
2. Select "ScalpingEA" from the Expert Advisor list
3. Choose symbol (e.g., EURUSD)
4. Select timeframe (M5 or M15 recommended)
5. Set date range for testing
6. Configure input parameters
7. Click "Start" to run the backtest
8. Review results in the "Results" and "Graph" tabs

### Troubleshooting

**EA not trading:**
- Check that AutoTrading is enabled
- Verify spread is within MaxSpreadPips limit
- Ensure current time is within trading hours (if time filter is enabled)
- Check Expert tab for error messages

**Invalid lot size errors:**
- Verify broker's minimum and maximum lot sizes
- Adjust MinLotSize and MaxLotSize parameters
- Reduce RiskPercent if calculated lots exceed limits

**Order errors:**
- Check account balance is sufficient
- Verify symbol is available for trading
- Ensure broker allows Expert Advisors

---

## MultiTimeframeSignalEA

### Overview
This EA analyzes multiple timeframes (1-minute, 5-minute, and 15-minute) to generate buy and sell signals on the chart using Stochastic Oscillator and Moving Average analysis.

### Features
- Multi-timeframe analysis (M1, M5, M15)
- Stochastic oscillator with customized parameters per timeframe
- Moving average crossover analysis
- Visual signal display with colored arrows
- Alert system (audio, push notifications, email)

### Signal Conditions

**SELL Signal:**
- 1min: MA(3) crosses above MA(9), Stochastic (%K=19, %D=7) signal > 80, Main < Signal
- 5min: Stochastic (%K=19, %D=3) Main < Signal
- 15min: Stochastic (%K=19, %D=3) Main < Signal

**BUY Signal:**
- 1min: MA(3) crosses below MA(9), Stochastic (%K=19, %D=7) signal < 30, Main > Signal
- 5min: Stochastic (%K=19, %D=3) Main > Signal
- 15min: Stochastic (%K=19, %D=3) Main > Signal

### Installation
Same as ScalpingEA - copy to MQL5/Experts/ folder and refresh Navigator.

### Documentation
See [MULTITIMEFRAME_SIGNAL_EA.md](MULTITIMEFRAME_SIGNAL_EA.md) for detailed documentation.

---

## TrailingManager

### Overview
An advanced EA that automatically opens and manages positions with comprehensive risk management. It combines automatic trading based on EMA crossover and RSI signals with sophisticated trailing stop, break-even, and trailing take-profit management.

### Key Features

#### Automatic Trading
- EMA Crossover Strategy with RSI confirmation
- Smart entry logic with multiple filter conditions
- Automatic position opening based on market conditions

#### Risk Management
- Position sizing based on risk percentage
- Maximum concurrent positions limit (default: 3)
- Daily loss limit protection (stops trading if limit reached)
- Spread filter to avoid high-cost entries
- Trading hours restriction

#### Position Management
- Initial SL/TP placement
- Break-even functionality
- Trailing stop to lock in profits
- Trailing take-profit to maximize gains
- Broker compliance (respects stop levels and freeze levels)

### Configuration Highlights

#### Trading Parameters
- **InpAutoTrade** (default: true): Enable/disable automatic position opening
- **InpFastEMA_Period** (default: 5): Fast moving average period
- **InpSlowEMA_Period** (default: 20): Slow moving average period
- **InpRSI_Period** (default: 14): RSI indicator period

#### Risk Settings
- **InpRiskPercent** (default: 1.0%): Risk per trade
- **InpMaxOpenPositions** (default: 3): Maximum simultaneous positions
- **InpMaxDailyLossPercent** (default: 5.0%): Daily loss limit
- **InpMaxSpreadPips** (default: 2.0): Maximum allowed spread

#### Position Management
- **InpInitialSL_Points** (default: 150): Initial stop loss in points
- **InpInitialTP_Points** (default: 250): Initial take profit in points
- **InpBE_Trigger_Points** (default: 500): Break-even trigger level
- **InpTS_Distance_Points** (default: 150): Trailing stop distance

### Installation
Same as ScalpingEA - copy to MQL5/Experts/ folder and refresh Navigator.

### Documentation
See [TRAILING_MANAGER.md](TRAILING_MANAGER.md) for comprehensive documentation.

---

## StochasticSellEA

### Overview
An automated trading EA that opens SELL positions based on precise Stochastic Oscillator crossover conditions combined with Moving Average confirmation. This EA is designed for traders looking to automate sell signals based on momentum reversal after overbought conditions.

### Trading Strategy

The EA opens SELL positions when ALL of the following conditions are met:

1. **Stochastic Crossover**: Stochastic (%K=14, %D=19, Slowing=9) crosses over the 60 level
2. **Momentum Reversal**: Main line (%K) crosses below Signal line (%D) - indicating bearish momentum shift
3. **Trend Confirmation**: MA(33) with shift -9 < MA(19) with shift -9

### Key Features

#### Precise Entry Logic
- Stochastic Oscillator with customizable parameters (%K=14, %D=19, Slowing=9)
- Crossover detection at specific level (default: 60)
- Main/Signal line crossover confirmation
- Moving Average trend filter with negative shift for forward-looking analysis

#### Risk Management
- Position sizing based on risk percentage
- Configurable stop loss and take profit in pips
- Spread filter to avoid high-cost entries
- Maximum positions limit
- Automatic lot size calculation

#### Position Management
- Only SELL positions (directional strategy)
- Single or multiple position management
- Detailed logging of signal conditions
- Trade tracking with magic number

### Configuration Highlights

#### Stochastic Parameters
- **Stoch_K_Period** (default: 14): %K period
- **Stoch_D_Period** (default: 19): %D signal line period
- **Stoch_Slowing** (default: 9): Slowing factor
- **Stoch_Level** (default: 60.0): Crossover detection level

#### Moving Average Parameters
- **MA_Fast_Period** (default: 19): Fast MA period
- **MA_Slow_Period** (default: 33): Slow MA period
- **MA_Shift** (default: -9): Shift for forward-looking analysis

#### Risk Settings
- **RiskPercent** (default: 1.0%): Risk per trade
- **StopLossPips** (default: 50.0): Stop loss distance
- **TakeProfitPips** (default: 100.0): Take profit distance
- **MaxSpreadPips** (default: 3.0): Maximum allowed spread
- **MaxPositions** (default: 1): Maximum concurrent positions

### Installation
Same as ScalpingEA - copy to MQL5/Experts/ folder and refresh Navigator.

### Documentation
See [STOCHASTIC_SELL_EA.md](STOCHASTIC_SELL_EA.md) for comprehensive documentation.

### Usage Notes
- This EA is **directional** - it only opens SELL positions
- Signals may be rare as all three conditions must align
- The negative MA shift provides forward-looking trend analysis
- Best suited for ranging or topping markets
- Always backtest on historical data before live trading
- Consider market conditions when using a sell-only strategy

---

## Support & Contributions

This is an open-source project. Feel free to:
- Report issues
- Suggest improvements
- Submit pull requests
- Share your optimization results

## License

These Expert Advisors are provided for educational and research purposes.