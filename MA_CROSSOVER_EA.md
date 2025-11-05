# MACrossoverEA - 4 Moving Average Crossover Strategy

## Overview
**MACrossoverEA** is an automated trading Expert Advisor designed for MetaTrader 5 that uses a 4 Moving Average crossover strategy. The EA analyzes the relative positions of MA19, MA38, MA58, and MA209 to generate precise buy and sell signals. It includes advanced risk management with trailing stop and take profit features.

## Trading Strategy

### Core Concept
The EA monitors the relationship between four moving averages to identify strong trend conditions:
- **MA19** (Fast) - Short-term trend indicator
- **MA38** (Medium-Fast) - Medium-term trend indicator  
- **MA58** (Medium-Slow) - Medium-term trend confirmation
- **MA209** (Slow) - Long-term trend filter

### Entry Signals

#### BUY Signal Conditions
The EA opens a **BUY** position when ALL of the following conditions are met:
- **MA19 > MA38** (fast above medium-fast)
- **MA38 > MA58** (medium-fast above medium-slow)
- **MA58 < MA209** (medium-slow below long-term)

**Interpretation**: This indicates an upward trend in the short and medium term, with the market still below the long-term average (potential for continued upside).

#### SELL Signal Conditions
The EA opens a **SELL** position when ALL of the following conditions are met:
- **MA58 > MA38** (medium-slow above medium-fast)
- **MA38 > MA19** (medium-fast above fast)
- **MA19 > MA209** (fast above long-term)

**Interpretation**: This indicates a downward trend developing with all shorter-term MAs descending from the medium-slow MA, while still above the long-term average (potential for continued downside).

### Visual Representation

```
BUY Signal:
MA19 (highest)
  ↑
MA38
  ↑
MA58
  ↓
MA209 (lowest)

SELL Signal:
MA58 (highest)
  ↓
MA38
  ↓
MA19
  ↓
MA209 (lowest)
```

## Features

### Automated Trading
- **Automatic Signal Detection**: Analyzes MA positions on every new bar
- **Real-time Entry Execution**: Opens positions immediately when conditions are met
- **One Position Management**: Limits exposure to one position at a time (configurable)
- **Smart Bar Timing**: Only checks for signals on new bar formation to avoid repainting

### Risk Management
- **Position Sizing**: Automatically calculates lot size based on risk percentage
- **Fixed Stop Loss**: Configurable SL distance in pips (default: 30 pips)
- **Fixed Take Profit**: Configurable TP distance in pips (default: 60 pips = 2:1 R:R)
- **Spread Filter**: Avoids trading during high spread conditions
- **Maximum Position Limit**: Controls total exposure (default: 1 position)

### Trailing Stop Feature
- **Dynamic Stop Loss**: Automatically adjusts SL to lock in profits
- **Trailing Distance**: Maintains specified distance from current price (default: 20 pips)
- **Trailing Step**: Only updates when price moves by step amount (default: 5 pips)
- **Profit Protection**: Only activates trailing when position is profitable
- **Never Loosens**: Trailing stop only moves in favorable direction

### Position Management
- **Magic Number Identification**: Unique identifier for EA's trades (789012)
- **Trade Comments**: Labels all trades with "MACrossEA" for easy tracking
- **Position Monitoring**: Continuously checks and updates trailing stops
- **Clean Entry/Exit**: Proper order placement with SL/TP

## Installation

### Step 1: Install the EA
1. Open MetaTrader 5
2. Click `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `MACrossoverEA.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in Navigator
6. The EA appears under "Expert Advisors" in Navigator

### Step 2: Attach to Chart
1. Open any currency pair chart (recommended: EURUSD, GBPUSD, USDJPY)
2. **IMPORTANT**: Set timeframe to **M1 (1 minute)** as specified in requirements
3. Drag and drop MACrossoverEA from Navigator to the chart
4. The settings dialog will appear

### Step 3: Configure Settings
See "Quick Start Configuration" section below for recommended settings.

### Step 4: Enable Auto Trading
1. Click "AutoTrading" button in toolbar (or press Alt+A)
2. Verify green checkmark appears in top-right corner
3. Check "Experts" tab to see initialization message
4. Ensure "Allow algorithmic trading" is enabled in Tools → Options → Expert Advisors

## Configuration Parameters

### Moving Average Parameters
| Parameter | Default | Description |
|-----------|---------|-------------|
| **MA19_Period** | 19 | Period for fast MA |
| **MA38_Period** | 38 | Period for medium-fast MA |
| **MA58_Period** | 58 | Period for medium-slow MA |
| **MA209_Period** | 209 | Period for slow/long-term MA |
| **MA_Method** | SMA | MA calculation method (SMA, EMA, SMMA, LWMA) |
| **MA_Price** | CLOSE | Price to use for MA calculation |

### Risk Management
| Parameter | Default | Description |
|-----------|---------|-------------|
| **RiskPercent** | 1.0% | Risk per trade as % of account balance |
| **StopLossPips** | 30.0 | Stop loss distance in pips |
| **TakeProfitPips** | 60.0 | Take profit distance in pips (2:1 R:R) |
| **MaxSpreadPips** | 3.0 | Maximum allowed spread in pips |

### Trailing Stop Settings
| Parameter | Default | Description |
|-----------|---------|-------------|
| **UseTrailingStop** | true | Enable/disable trailing stop feature |
| **TrailingStopPips** | 20.0 | Distance of trailing stop from price |
| **TrailingStepPips** | 5.0 | Minimum price movement to adjust SL |

### Position Management
| Parameter | Default | Description |
|-----------|---------|-------------|
| **MagicNumber** | 789012 | Unique identifier for EA's trades |
| **TradeComment** | MACrossEA | Comment added to all trades |
| **MaxLotSize** | 10.0 | Maximum position size limit |
| **MinLotSize** | 0.01 | Minimum position size limit |
| **MaxOpenPositions** | 1 | Maximum concurrent positions |

### Trading Hours (Optional)
| Parameter | Default | Description |
|-----------|---------|-------------|
| **UseTimeFilter** | false | Enable/disable time-based trading |
| **StartHour** | 0 | Start trading hour (server time) |
| **EndHour** | 23 | End trading hour (server time) |

## Quick Start Configuration

### Conservative (Recommended for Beginners)
**Target**: Low risk, stable performance, designed for M1 timeframe
```
Timeframe: M1 (1 minute)
RiskPercent: 0.5%
StopLossPips: 30
TakeProfitPips: 60
UseTrailingStop: true
TrailingStopPips: 20
MaxOpenPositions: 1
```

### Moderate (Balanced Risk)
**Target**: Balanced risk/reward for M1 timeframe
```
Timeframe: M1 (1 minute)
RiskPercent: 1.0%
StopLossPips: 30
TakeProfitPips: 60
UseTrailingStop: true
TrailingStopPips: 20
MaxOpenPositions: 1
```

### Aggressive (Higher Risk)
**Target**: Higher risk for experienced traders on M1
```
Timeframe: M1 (1 minute)
RiskPercent: 2.0%
StopLossPips: 25
TakeProfitPips: 50
UseTrailingStop: true
TrailingStopPips: 15
MaxOpenPositions: 2
```

## Usage

### Starting the EA
1. Attach EA to M1 chart of your chosen currency pair
2. Configure parameters based on your risk tolerance
3. Enable AutoTrading (Alt+A)
4. Monitor the Experts tab for initialization confirmation
5. Wait for signal conditions to be met

### Monitoring Performance
- **Experts Tab**: Shows EA activity, signals detected, and trade execution logs
- **Trade Tab**: Displays currently open positions with SL/TP levels
- **History Tab**: Shows closed trades with profit/loss results
- **Chart**: You can add MA indicators manually to visualize the signals

### Understanding the Logs
The EA provides detailed logging:
```
BUY Signal detected!
MA Values: MA19=1.1234 | MA38=1.1230 | MA58=1.1225 | MA209=1.1240
✓ Buy order opened successfully
  Lot: 0.10 | Entry: 1.1235 | SL: 1.1205 | TP: 1.1295
```

## How the Strategy Works

### Signal Generation Process
1. **Bar Formation**: EA waits for new bar to form (avoids repainting)
2. **MA Calculation**: Retrieves current values of all 4 MAs
3. **Condition Check**: Evaluates if BUY or SELL conditions are met
4. **Pre-Trade Validation**: Checks spread, trading hours, position limits
5. **Position Opening**: Executes trade with calculated lot size, SL, and TP
6. **Trailing Management**: Continuously updates stop loss as position becomes profitable

### Example Trade Scenario (BUY)

**Market Condition**:
- MA19 = 1.1050 (highest)
- MA38 = 1.1045
- MA58 = 1.1040
- MA209 = 1.1055 (MA58 < MA209 ✓)

**Signal**: BUY conditions met (MA19 > MA38 > MA58 < MA209)

**Trade Execution**:
- Entry: 1.1050 (current Ask price)
- Stop Loss: 1.1020 (30 pips below entry)
- Take Profit: 1.1110 (60 pips above entry)
- Lot Size: 0.10 (calculated based on 1% risk)

**Trade Management**:
- Price moves to 1.1070 (20 pips profit)
- Trailing stop activates
- New SL: 1.1050 (20 pips trailing distance)
- Price continues to 1.1090
- New SL: 1.1070 (trailing stop follows)
- Price hits TP at 1.1110
- Trade closes with +60 pips profit

### Example Trade Scenario (SELL)

**Market Condition**:
- MA58 = 1.1050 (highest)
- MA38 = 1.1045
- MA19 = 1.1040
- MA209 = 1.1030 (MA19 > MA209 ✓)

**Signal**: SELL conditions met (MA58 > MA38 > MA19 > MA209)

**Trade Execution**:
- Entry: 1.1040 (current Bid price)
- Stop Loss: 1.1070 (30 pips above entry)
- Take Profit: 1.0980 (60 pips below entry)
- Lot Size: 0.10 (calculated based on 1% risk)

**Trade Management**:
- Price moves to 1.1020 (20 pips profit)
- Trailing stop activates
- New SL: 1.1040 (20 pips trailing distance)
- Price continues to 1.0990
- New SL: 1.1010 (trailing stop follows)
- Price hits TP at 1.0980
- Trade closes with +60 pips profit

## Strategy Testing

### Backtesting in Strategy Tester
1. Press **Ctrl+R** to open Strategy Tester
2. Select "MACrossoverEA" from Expert Advisor list
3. Choose your symbol (e.g., EURUSD)
4. **Important**: Select **M1 (1-minute)** timeframe
5. Set date range (minimum 3 months recommended)
6. Select "Every tick" model for highest accuracy
7. Configure input parameters
8. Click "Start" to run backtest

### Optimization (Optional)
You can optimize parameters to find best settings for your symbol:
- MA periods (test different period combinations)
- StopLossPips and TakeProfitPips (optimize risk/reward)
- TrailingStopPips (optimize profit locking)
- RiskPercent (test different risk levels)

**Note**: Always validate optimized parameters on out-of-sample data to avoid curve fitting.

### Forward Testing
Before using real money:
1. Test on demo account for minimum 30 days
2. Use M1 timeframe as specified
3. Monitor signal frequency and win rate
4. Verify trailing stop functionality
5. Evaluate overall performance metrics
6. Start with conservative settings

## Best Practices

### Risk Management
✅ **DO**:
- Start with 0.5-1% risk per trade
- Use the M1 timeframe as specified in requirements
- Test extensively on demo account (30+ days minimum)
- Monitor EA performance regularly
- Keep MetaTrader running continuously (or use VPS)
- Ensure stable internet connection

❌ **DON'T**:
- Risk more than 2% per trade
- Use on untested symbols without demo testing
- Change timeframe without thorough testing
- Ignore error messages in Experts tab
- Overtrade by allowing too many concurrent positions
- Disable stop losses

### Trading Environment
- **Recommended Timeframe**: M1 (1 minute) as per specifications
- **Recommended Symbols**: Major forex pairs (EURUSD, GBPUSD, USDJPY)
- **Recommended Broker**: Low spread, fast execution
- **VPS Recommended**: For 24/7 operation without interruptions

### Monitoring
- Check Experts tab daily for EA activity
- Review open positions and their progress
- Monitor trailing stop adjustments
- Track win rate and profit factor
- Be aware of unusual market conditions (news events)

### Optimization Tips
- **MA Periods**: Can be adjusted for different market conditions
  - Shorter periods = More signals, more false signals
  - Longer periods = Fewer signals, more reliable signals
- **Stop Loss**: Balance between avoiding premature stops and protecting capital
- **Take Profit**: Consider market volatility and average moves
- **Trailing Stop**: Should allow profits to run while protecting gains

## Troubleshooting

### EA Not Trading
**Possible Causes**:
- AutoTrading not enabled → Click AutoTrading button (Alt+A)
- Wrong timeframe → Ensure chart is set to M1
- Spread too high → Check MaxSpreadPips setting
- Position limit reached → Check MaxOpenPositions setting
- MA conditions not met → Wait for proper signal conditions
- Time filter active → Check UseTimeFilter and trading hours

**Solutions**:
1. Check Experts tab for error messages
2. Verify AutoTrading is enabled (green checkmark)
3. Confirm chart timeframe is M1
4. Check current spread vs MaxSpreadPips limit
5. Verify MA indicator values meet signal conditions

### No Signals Appearing
**Possible Causes**:
- MA conditions rarely align → This is a specific strategy requiring precise conditions
- Wrong timeframe → Must use M1 as specified
- Market in consolidation → No clear trend for signals
- High spread → Spread filter preventing trades

**Solutions**:
1. Be patient - the strategy requires specific MA alignments
2. Verify timeframe is M1
3. Check current MA values manually
4. Consider slightly adjusting MA periods if no signals after testing
5. Review historical data to see signal frequency

### Invalid Lot Size Errors
**Possible Causes**:
- Calculated lot exceeds broker limits
- Account balance too low for risk percentage
- RiskPercent too high

**Solutions**:
1. Reduce RiskPercent (try 0.5%)
2. Check broker's minimum/maximum lot sizes
3. Ensure sufficient account balance
4. Adjust MinLotSize/MaxLotSize parameters

### Trailing Stop Not Working
**Possible Causes**:
- UseTrailingStop is disabled
- Position not profitable enough
- TrailingStepPips not reached
- Broker restrictions on SL modifications

**Solutions**:
1. Verify UseTrailingStop = true
2. Wait for position to reach trailing activation
3. Check Experts tab for trailing modification messages
4. Reduce TrailingStepPips if needed
5. Verify broker allows SL modifications

### Orders Rejected
**Possible Causes**:
- Insufficient margin
- Invalid stop loss distance
- Broker trading restrictions
- Market closed

**Solutions**:
1. Check account balance and margin
2. Verify StopLossPips meets broker requirements
3. Check if symbol is available for trading
4. Ensure market is open
5. Review Experts tab for specific error codes

## Risk Warnings

### ⚠️ CRITICAL DISCLAIMERS

**High Risk Activity**:
- Forex trading carries substantial risk of loss
- You can lose more than your initial investment
- Never trade with money you cannot afford to lose
- Past performance does not guarantee future results

**EA Specific Risks**:
- This EA does not guarantee profits
- Signal frequency may vary based on market conditions
- MA crossover strategies can generate false signals in ranging markets
- Trailing stop does not eliminate risk of loss
- Market gaps and slippage can occur

**Required Actions**:
1. ✅ Test on demo account for minimum 30 days
2. ✅ Start with minimum lot sizes and conservative risk (0.5%)
3. ✅ Use proper risk management at all times
4. ✅ Monitor EA performance regularly
5. ✅ Understand the strategy before deploying with real money

**Not Financial Advice**:
- This EA is for educational and research purposes
- No guarantee of accuracy or profitability
- Always use your own judgment and risk assessment
- Consider consulting a financial advisor

## Support & Contributions

### Getting Help
- Review this documentation thoroughly
- Check Experts tab for error messages
- Test on demo account first
- Review troubleshooting section

### Contributing
This is an open-source project. Feel free to:
- Report issues or bugs
- Suggest improvements
- Share optimization results
- Submit pull requests

## Version History

### Version 1.00 (Initial Release)
- 4 Moving Average crossover strategy (MA19, MA38, MA58, MA209)
- BUY signal: MA19 > MA38 > MA58 < MA209
- SELL signal: MA58 > MA38 > MA19 > MA209
- Trailing stop functionality
- Take profit functionality
- Risk-based position sizing
- Spread filter
- Time filter (optional)
- Designed for M1 (1-minute) timeframe
- Complete risk management system

## License

This Expert Advisor is provided for educational and research purposes. Use at your own risk.

---

**Developed for MetaTrader 5**  
**Recommended Timeframe: M1 (1 minute)**  
**Strategy: 4 MA Crossover with Trailing Stop & Take Profit**
