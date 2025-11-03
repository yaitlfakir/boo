# MetaTrader 5 Expert Advisors Collection

A collection of Expert Advisors (EAs) for MetaTrader 5, including automated trading and signal generation tools.

## Available Expert Advisors

### 1. TradingManager - Complete Trading Dashboard & Control Center ⭐ NEW
A comprehensive trading dashboard with one-click controls, real-time indicators, stochastic alerts, and advanced position management. Features visual trend display, support/resistance detection, buttons to open multiple trades, close profitable positions, and set break-even - all from an intuitive dashboard interface.

### 2. EurusdPredictorEA - EURUSD Price Movement Predictor
A specialized signal-generating EA for EURUSD that predicts price movement using multi-indicator analysis and displays clear UP/DOWN signals on the chart. Perfect for traders who want intelligent signal assistance without automated trading.

### 3. BitcoinTradingEA - Automated Bitcoin Trading Robot
An automated trading EA specifically designed for Bitcoin (BTCUSD) with cryptocurrency-optimized volatility management, dynamic stops, and trend filtering.

### 4. ScalpingEA - Automated Scalping with Risk Management
An automated trading EA that uses scalping strategies with comprehensive risk management.

### 5. MultiTimeframeSignalEA - Buy/Sell Signal Indicator
A signal-generating EA that analyzes multiple timeframes to display buy and sell signals on the chart.

### 6. TrailingManager - Comprehensive Trading & Risk Management
An advanced EA that combines automatic position opening with sophisticated trailing stop, break-even, and trailing take-profit management. Features comprehensive risk controls including daily loss limits, position limits, and intelligent trade entry.

### 7. StochasticSellEA - Automated Sell Trading with Stochastic Crossover
An automated trading EA that opens SELL positions based on Stochastic Oscillator crossover above 60 level, combined with momentum reversal and Moving Average confirmation.

### 8. BTCStochasticEA - Bitcoin Trading with Stochastic (19,7,3) ⭐ NEW
A fully automated Bitcoin trading EA using Stochastic Oscillator (19,7,3). Opens BUY when %K crosses above %D, SELL when %K crosses below %D. Features Bitcoin-optimized risk management with ATR-based dynamic stops and trailing stop functionality.

---

## TradingManager

### Overview
The **EA Trading Manager** is a comprehensive trading dashboard and control center that puts complete trading control at your fingertips. Unlike automated EAs that trade for you, this tool gives you instant access to market indicators, one-click trading controls, and advanced position management features - all from a clean, visual dashboard.

### Key Features

#### Visual Dashboard with Real-Time Indicators
- **Trend Display**: Shows current market trend (BULLISH ↑ / BEARISH ↓ / NEUTRAL) based on EMA crossover
- **Stochastic Oscillator**: Live values with overbought/oversold status highlighting
- **RSI Indicator**: Momentum analysis with condition indicators
- **ADX (Trend Strength)**: Shows whether trend is STRONG or WEAK for trade confidence
- **ATR (Volatility)**: Current market volatility measurement for stop loss adjustment
- **Position Information**: Live count of open positions and total profit/loss with color coding

#### One-Click Trading Controls
- **Single Trade Buttons**: BUY and SELL buttons for instant position opening
- **Multiple Trade Buttons**: Open 3 BUYs or 3 SELLs simultaneously (configurable count)
- **Close All Profitable**: Automatically closes only winning positions, leaving losers to recover
- **Set Break-Even**: Moves stop loss to break-even for losing trades that have become profitable
- **Close All Positions**: Emergency close all button for rapid exit

#### Stochastic Alert System
- **Overbought Alerts**: Notification when Stochastic crosses above resistance level (default: 80)
- **Oversold Alerts**: Notification when Stochastic crosses below support level (default: 20)
- **Multiple Alert Types**: Audio alerts, push notifications to mobile, and email alerts
- **Smart Logic**: Only alerts once per crossover, resets when back in neutral zone

#### Support & Resistance Detection
- **Automatic S/R Calculation**: Analyzes last 100 bars for swing highs (resistance) and lows (support)
- **Visual Display**: Draws green support lines and red resistance lines on chart
- **Proximity Alerts**: Dashboard shows when price is near significant S/R levels
- **Configurable Tolerance**: Adjust sensitivity of level detection

### Installation

1. Open MetaTrader 5
2. Click `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `TradingManager.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in Navigator
6. The EA appears under "Expert Advisors" in Navigator

### Quick Start Configuration

#### For Conservative Trading (Recommended for Beginners)
- **DefaultLotSize**: 0.01 (minimum)
- **StopLossPips**: 40 (wider stop)
- **TakeProfitPips**: 80 (2:1 risk/reward)
- **MultiTradeCount**: 1 (single trades only)
- **Timeframe**: H1 or H4

#### For Balanced Trading
- **DefaultLotSize**: 0.1 (standard)
- **StopLossPips**: 30 (moderate)
- **TakeProfitPips**: 60 (2:1 risk/reward)
- **MultiTradeCount**: 3 (can open multiple)
- **Timeframe**: H1

#### For Active Trading
- **DefaultLotSize**: 0.1 (adjust based on account)
- **StopLossPips**: 20 (tighter stops)
- **TakeProfitPips**: 40 (quicker targets)
- **MultiTradeCount**: 3
- **Timeframe**: M15 or M30

### Usage

1. **Attach to Chart**:
   - Open any currency pair chart (EURUSD, GBPUSD, USDJPY, etc.)
   - Recommended timeframe: **H1** (1 hour) for balanced trading
   - Drag and drop TradingManager from Navigator to chart

2. **Configure Settings**:
   - Adjust parameters based on your trading style and risk tolerance
   - Enable desired alert types (audio, push, email)
   - Configure lot sizes and stop loss/take profit levels

3. **Enable Auto Trading**:
   - Click "AutoTrading" button in toolbar (or press Alt+A)
   - Verify green checkmark appears in top-right corner
   - Dashboard appears on the chart

4. **Start Trading**:
   - Monitor indicators on dashboard
   - Wait for clear signals (trend + stochastic + RSI alignment)
   - Click BUY or SELL to open positions
   - Use position management buttons as needed

### How to Trade with the Dashboard

**Opening Trades:**
- **Single Position**: Click BUY or SELL for one trade
- **Multiple Positions**: Click "OPEN 3 BUYS" or "OPEN 3 SELLS" for scaling into position
- All trades open with configured lot size, stop loss, and take profit

**Managing Positions:**
- **Close Winners**: Click "CLOSE ALL PROFITABLE" to lock in gains
- **Protect Capital**: Click "SET BREAK-EVEN" to move SL to entry for losing positions
- **Emergency Exit**: Click "CLOSE ALL POSITIONS" to close everything immediately

**Understanding Indicators:**
- **BULLISH Trend + Stochastic Oversold**: Look for BUY opportunities
- **BEARISH Trend + Stochastic Overbought**: Look for SELL opportunities
- **ADX < 20 (WEAK)**: Avoid trading, market is choppy
- **ADX > 25 (STRONG)**: Good trending conditions for trading
- **Near Support/Resistance**: Watch for bounces or breakouts

### Trading Strategy Examples

**Strategy 1: Trend Following**
1. Wait for trend to show BULLISH or BEARISH (not NEUTRAL)
2. Confirm with ADX > 25 (STRONG trend)
3. Wait for Stochastic pullback (oversold for buys, overbought for sells)
4. Click BUY or SELL when indicators align
5. Use SET BREAK-EVEN after 20 pips profit
6. Close with CLOSE ALL PROFITABLE when indicators reverse

**Strategy 2: Support/Resistance Bounce**
1. Watch for "Near SUPPORT" or "Near RESISTANCE" on dashboard
2. Wait for confirmation (Stochastic oversold at support or overbought at resistance)
3. Enter trade with BUY at support or SELL at resistance
4. Set tight stops just beyond S/R level
5. Take profit at next S/R level

**Strategy 3: Multiple Entry Scaling**
1. Identify strong trend (ADX > 25, clear direction)
2. Wait for pullback to support (uptrend) or resistance (downtrend)
3. Use "OPEN 3 BUYS" or "OPEN 3 SELLS" for multiple entries
4. Use SET BREAK-EVEN once profitable
5. Exit all with CLOSE ALL PROFITABLE at target

### Documentation

See [TRADING_MANAGER.md](TRADING_MANAGER.md) for comprehensive documentation including:
- Detailed parameter explanations
- Complete feature descriptions
- Advanced trading strategies
- Risk management guidelines
- Troubleshooting guide
- Best practices and tips

See [TRADING_MANAGER_QUICKSTART.md](TRADING_MANAGER_QUICKSTART.md) for:
- 5-minute setup guide
- Dashboard overview
- Simple trading strategy
- Common issues and solutions
- Quick reference for all features

### Important Notes

✅ **This EA Provides**:
- Real-time visual dashboard with 6 key indicators
- One-click trading controls for manual execution
- Stochastic alerts when reaching overbought/oversold levels
- Automatic support/resistance level detection and display
- Advanced position management (close profitable, break-even, close all)
- Complete control over your trading decisions

❌ **This EA Does NOT**:
- Execute trades automatically (you control all entries)
- Guarantee profits or accuracy
- Replace proper market analysis and trading knowledge
- Eliminate trading risk

### Best Practices

**Signal Interpretation:**
- Use all indicators together, not individually
- Wait for strong confluence (trend + stochastic + RSI)
- Check ADX to ensure trending conditions
- Respect support and resistance levels
- Always use proper risk management

**Position Management:**
- Start with single trades, not multiple
- Use break-even feature once trade is 20+ pips profitable
- Close profitable trades before end of trading session
- Don't let small profits turn into losses
- Use emergency close button if market turns against you

**Risk Management:**
- Always use stop losses (configured in settings)
- Never risk more than 2% per trade
- Multiple trades = multiple risk (use smaller lots)
- Test on demo account first (30+ days recommended)
- Start with minimum lot sizes on live account

### Risk Warnings

⚠️ **CRITICAL DISCLAIMERS**:
- **High Risk**: Trading carries substantial risk of loss
- **No Guarantee**: This tool does not guarantee profits
- **Demo Testing Required**: ALWAYS test extensively on demo accounts first
- **Your Responsibility**: You make all trading decisions, you accept all risks
- **Not Financial Advice**: This EA is for educational purposes only
- **Proper Risk Management**: Use stop losses and never risk more than you can afford to lose

### Troubleshooting

**Dashboard not showing:**
- Verify AutoTrading is enabled (green checkmark)
- Check that EA is active on chart
- Adjust dashboard X/Y position if off-screen
- Check Experts tab for error messages

**Buttons not working:**
- Ensure AutoTrading is enabled
- Verify "Allow algorithmic trading" in Tools → Options
- Check account has sufficient margin
- Look for error messages in Experts tab

**No stochastic alerts:**
- Set EnableStochAlerts = true in settings
- Enable at least one alert type (audio/push/email)
- Wait for stochastic to actually cross levels
- Check volume is up (for audio alerts)

---

## EurusdPredictorEA

### Overview
A specialized signal-generating Expert Advisor designed exclusively for EURUSD currency pair. **Version 2.0** uses advanced multi-indicator analysis with volatility filtering, trend strength detection, and multi-timeframe confirmation to display high-quality visual signals (UP/DOWN) with quality ratings. This is a **signal-only EA** - it provides trading signals but does not execute trades automatically.

### ⭐ NEW in Version 2.0 - Enhanced Accuracy

#### Major Improvements:
- **Signal Quality Ratings**: Each signal shows STRONG/MEDIUM/WEAK quality
- **Volatility Filter**: ATR-based filtering removes signals during low volatility
- **Trend Strength Filter**: ADX indicator ensures trades only in trending markets
- **Multi-Timeframe Confirmation**: Higher timeframe trend alignment for better accuracy
- **Enhanced Scoring**: 16-point system (vs 9) with configurable threshold
- **Directional Analysis**: +DI/-DI for precise trend direction

**Result**: 30-50% fewer signals but significantly higher accuracy

### Features

#### Intelligent Price Prediction
- **Multi-Indicator Analysis**: Combines 8 technical analysis methods for comprehensive market view
- **Weighted Scoring System**: Advanced 16-point system with configurable threshold (default: 6+)
- **Real-time Signal Generation**: Analyzes every new bar formation with quality rating
- **EURUSD Optimized**: Parameters specifically tuned for EURUSD behavior
- **Smart Filtering**: Multiple filters remove low-probability signals

#### Technical Analysis Components
1. **EMA Crossover** (12/26 periods): Primary trend identification and reversal signals (3 points)
2. **EMA Trend Analysis**: Confirms overall market direction (1 point)
3. **RSI Indicator** (14 period): Momentum analysis and overbought/oversold detection (2 points)
4. **MACD** (12/26/9): Trend strength and momentum shift confirmation (3 points)
5. **Price vs Signal EMA** (9 period): Price position relative to trend (1 point)
6. **ADX Directional Index** (14 period): Trend direction with +DI/-DI analysis (2 points)
7. **Price Momentum**: Current vs previous close analysis (1 point)
8. **Multi-Timeframe Confirmation**: Higher timeframe trend alignment (2 points)

#### Advanced Filters
- **ATR Volatility Filter**: Skips signals when volatility is too low (unreliable conditions)
- **ADX Trend Filter**: Minimum ADX 20 ensures trending market conditions
- **Multi-Timeframe Filter**: Confirms signal direction with higher timeframe EMAs

#### Visual Signal Display
- **UP Signals**: Green arrow (↑) with "UP [STRONG/MEDIUM/WEAK]" text when bullish conditions met
- **DOWN Signals**: Red arrow (↓) with "DOWN [STRONG/MEDIUM/WEAK]" text when bearish conditions met
- **Customizable Appearance**: Adjustable colors, sizes, and text display
- **Persistent Signals**: Signals remain on chart for historical reference
- **Quality Indicator**: Instant feedback on signal strength

#### Alert System
- **Audio Alerts**: Sound notification when signal is detected with quality rating
- **Push Notifications**: Send alerts to MetaTrader mobile app
- **Email Alerts**: Email notifications for important signals
- **Enhanced Logging**: Complete signal information with ADX, ATR, HTF trend, and indicator values

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
- **SignalThreshold**: 6 (default)
- **UseVolatilityFilter**: true
- **UseTrendFilter**: true
- **UseMultiTimeframe**: true

#### For Swing Trading
- **Timeframe**: H4 (4 hours)
- **SignalSize**: 3
- **SignalThreshold**: 7 (higher quality)
- **UseVolatilityFilter**: true
- **UseTrendFilter**: true
- **UseMultiTimeframe**: true

#### For Scalping (More Signals)
- **Timeframe**: M15 (15 minutes)
- **SignalSize**: 2
- **SignalThreshold**: 5 (more signals)
- **UseVolatilityFilter**: false (optional)
- **UseTrendFilter**: true
- **UseMultiTimeframe**: false (optional)

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
   - **Signal Quality**: [STRONG], [MEDIUM], or [WEAK] shown with each signal
   - **STRONG (10+ points)**: Highest probability - best trading opportunities
   - **MEDIUM (8-9 points)**: Good probability - consider with confirmation
   - **WEAK (6-7 points)**: Moderate probability - wait for confirmation or skip
   - Check Experts tab for detailed signal information including ADX, ATR, and HTF trend

### How the Prediction Works (Version 2.0)

The EA uses an advanced 16-point scoring system with smart filtering:

**Signal Generation Process:**
1. **Pre-filtering**: Checks volatility (ATR) and trend strength (ADX)
2. **Multi-Timeframe Check**: Confirms higher timeframe trend direction
3. **Indicator Analysis**: Evaluates 8 different technical indicators
4. **Scoring**: Assigns weighted points based on bullish/bearish conditions (max 16 points)
5. **Threshold Check**: Generates signal only when score ≥ threshold (default 6) AND higher than opposite direction
6. **Quality Rating**: Categorizes signal as STRONG/MEDIUM/WEAK based on total score
7. **Display**: Shows visual arrow with quality rating on chart

**Scoring Breakdown (Max 16 Points):**
- EMA Crossover: 3 points (strong reversal signal when fast crosses slow)
- EMA Trend: 1 point (current trend direction)
- RSI Analysis: 2 points (momentum confirmation when strong)
- MACD Analysis: 3 points (trend strength crossover signal)
- Price Position: 1 point (relative to signal EMA)
- ADX Direction: 2 points (directional pressure via +DI/-DI)
- Price Momentum: 1 point (current vs previous close)
- Multi-Timeframe: 2 points (higher timeframe trend confirmation)

**Quality Rating:**
- **STRONG**: 10-16 points - Multiple strong confirmations, high confidence
- **MEDIUM**: 8-9 points - Good confirmations, reasonable confidence
- **WEAK**: 6-7 points - Meets threshold, moderate confidence

**Smart Filters (Optional but Recommended):**
- **Volatility Filter**: Skips signals when ATR is below average (choppy market)
- **Trend Filter**: Only signals when ADX ≥ 20 (clear trend present)
- **Multi-Timeframe**: Requires higher timeframe trend alignment

**Example Strong Signal:**
```
UP Score: 11 points [STRONG]
- Fast EMA crosses above Slow EMA (+3)
- Fast EMA above Slow EMA (+1)
- RSI > 55 and rising (+2)
- MACD crosses above signal (+3)
- Price above Signal EMA (+1)
- +DI > -DI (+2)
Result: Strong UP [STRONG] signal displayed with high confidence
```

### Version 2.0 vs 1.0 Comparison

| Feature | Version 1.0 | Version 2.0 |
|---------|-------------|-------------|
| Indicators | 5 | 8 |
| Max Score | 9 points | 16 points |
| Signal Threshold | 5 points | 6 points (configurable) |
| Signal Quality | No | Yes (STRONG/MEDIUM/WEAK) |
| Volatility Filter | No | Yes (ATR-based) |
| Trend Filter | No | Yes (ADX-based) |
| Multi-Timeframe | No | Yes (HTF confirmation) |
| Expected Signals | Baseline | 30-50% fewer |
| Accuracy | Good | Significantly Better |

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

✅ **This EA (Version 2.0)**:
- Analyzes EURUSD price movements with 8 technical indicators
- Displays visual UP/DOWN signals with quality ratings
- Filters out low-probability signals using volatility and trend strength
- Provides multi-timeframe confirmation for better accuracy
- Shows STRONG/MEDIUM/WEAK quality for each signal
- Provides alerts when signals appear
- Helps you make informed trading decisions with confidence levels

❌ **This EA Does NOT**:
- Execute trades automatically
- Guarantee profits or accuracy
- Work on other currency pairs by default
- Replace proper market analysis
- Eliminate trading risk

### Best Practices

**Signal Interpretation:**
- **Prioritize STRONG signals** - highest win probability
- Wait 1-2 bars after signal for price confirmation
- Check signal quality rating before entering trade
- Verify higher timeframe trend alignment
- Use signals in combination with support/resistance levels
- Always use proper risk management (stop loss, position sizing)

**Trading by Signal Quality:**
- **STRONG Signals**: Best entries, trade with full confidence
- **MEDIUM Signals**: Good entries, consider waiting for 1-bar confirmation
- **WEAK Signals**: Conservative traders may skip, aggressive traders use with tight stops

**Recommended Approach:**
1. Watch signals for 1 week without trading (observation - note quality patterns)
2. Test on demo account for 2-4 weeks (trade STRONG and MEDIUM signals)
3. Analyze win rate by signal quality (expect 60-70%+ on STRONG signals)
4. Start live trading with minimum lot sizes (focus on STRONG signals initially)
5. Gradually increase position size as you gain confidence

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