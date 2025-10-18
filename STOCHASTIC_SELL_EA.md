# StochasticSellEA - Automated Sell Trading with Stochastic Crossover

## Overview
This Expert Advisor (EA) automatically opens SELL positions based on specific Stochastic Oscillator crossover conditions combined with Moving Average analysis. It is designed for traders who want to automate entry signals based on momentum and trend confirmation.

## Trading Strategy

### Entry Conditions (SELL Signal)
The EA opens a SELL position when ALL of the following conditions are met simultaneously:

1. **Stochastic Oscillator Crossover Above 60**
   - Stochastic (%K=14, %D=19, Slowing=9) crosses over the 60 level
   - This indicates momentum moving from lower to higher territory

2. **Stochastic Main Crosses Below Signal**
   - Previous bar: Main (%K) > Signal (%D)
   - Current bar: Main (%K) < Signal (%D)
   - This indicates a bearish momentum shift

3. **Moving Average Confirmation**
   - MA(33) with shift -9 < MA(19) with shift -9
   - This confirms the overall trend direction

### Strategy Logic
The strategy combines momentum reversal (Stochastic crossing down after reaching overbought territory) with trend confirmation (Moving Averages). The negative shift (-9) on the MAs allows the EA to look ahead, providing earlier signals.

## Features

### Trading Parameters
- **Stochastic %K Period**: 14 (default)
- **Stochastic %D Period**: 19 (default)
- **Stochastic Slowing**: 9 (default)
- **Crossover Level**: 60 (default)
- **Fast MA Period**: 19 (default)
- **Slow MA Period**: 33 (default)
- **MA Shift**: -9 (default - negative shift for forward-looking)

### Risk Management
- **Position Sizing**: Automatically calculates lot size based on risk percentage
- **Stop Loss**: Configurable in pips (default: 50 pips)
- **Take Profit**: Configurable in pips (default: 100 pips)
- **Spread Filter**: Avoids trading during high spread conditions
- **Maximum Positions**: Limits concurrent positions (default: 1)

### Position Management
- **Magic Number**: Unique identifier for EA's trades
- **Trade Comment**: Custom comment added to trades
- **Lot Size Limits**: Configurable minimum and maximum lot sizes

## Installation

1. Open MetaTrader 5
2. Click on `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `StochasticSellEA.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in the Navigator panel
6. The EA should appear under "Expert Advisors" in the Navigator

## Configuration

### Stochastic Parameters
- **Stoch_K_Period** (default: 14): %K period for Stochastic calculation
- **Stoch_D_Period** (default: 19): %D period (signal line)
- **Stoch_Slowing** (default: 9): Slowing factor for smoothing
- **Stoch_Level** (default: 60.0): Level for crossover detection

### Moving Average Parameters
- **MA_Fast_Period** (default: 19): Fast moving average period
- **MA_Slow_Period** (default: 33): Slow moving average period
- **MA_Shift** (default: -9): Shift value (negative = forward-looking)

### Risk Management Parameters
- **RiskPercent** (default: 1.0%): Risk per trade as percentage of account balance
- **StopLossPips** (default: 50.0): Stop loss distance in pips
- **TakeProfitPips** (default: 100.0): Take profit distance in pips
- **MaxSpreadPips** (default: 3.0): Maximum allowed spread in pips

### Position Management Parameters
- **MagicNumber** (default: 789456): Unique identifier for EA's trades
- **TradeComment** (default: "StochSell"): Comment added to trades
- **MaxLotSize** (default: 10.0): Maximum position size
- **MinLotSize** (default: 0.01): Minimum position size
- **MaxPositions** (default: 1): Maximum concurrent open positions

## Usage

### 1. Attach to Chart
- Open a currency pair chart (recommended: EURUSD, GBPUSD, USDJPY)
- Use any timeframe (EA analyzes based on current timeframe)
- Drag and drop the StochasticSellEA from Navigator to the chart

### 2. Configure Settings
- Adjust input parameters based on your trading strategy
- Consider your risk tolerance when setting RiskPercent
- Adjust StopLossPips and TakeProfitPips based on pair volatility

### 3. Enable Auto Trading
- Click the "AutoTrading" button in the toolbar (or press Alt+A)
- Ensure "Allow algorithmic trading" is enabled in Tools → Options → Expert Advisors
- Verify the EA is active (smiley face in top-right corner should be smiling)

### 4. Monitor Performance
- Check the "Experts" tab for EA activity logs
- Review open positions in the "Trade" tab
- Monitor account history in the "History" tab

## Recommended Settings

### Conservative (Lower Risk)
```
RiskPercent: 0.5%
StopLossPips: 60
TakeProfitPips: 120
MaxSpreadPips: 2.5
MaxPositions: 1
```

### Moderate (Medium Risk)
```
RiskPercent: 1.0%
StopLossPips: 50
TakeProfitPips: 100
MaxSpreadPips: 3.0
MaxPositions: 1
```

### Aggressive (Higher Risk)
```
RiskPercent: 2.0%
StopLossPips: 40
TakeProfitPips: 80
MaxSpreadPips: 3.5
MaxPositions: 2
```

## Testing the EA

### Strategy Tester
To backtest the EA:
1. Press Ctrl+R to open Strategy Tester
2. Select "StochasticSellEA" from the Expert Advisor list
3. Choose symbol (e.g., EURUSD)
4. Select timeframe (H1 or H4 recommended for this strategy)
5. Set date range for testing (at least 1 year recommended)
6. Configure input parameters
7. Click "Start" to run the backtest
8. Review results in the "Results" and "Graph" tabs

### Optimization
To optimize parameters:
1. Open Strategy Tester
2. Select "StochasticSellEA"
3. Click "Settings" tab
4. Check parameters to optimize (e.g., Stoch_K_Period, MA_Fast_Period)
5. Set min/max values and step for each parameter
6. Click "Start" to run optimization
7. Review results sorted by profit factor, drawdown, etc.

## Understanding the Signals

### Signal Detection Log
When a SELL signal is detected, the EA logs detailed information:
```
SELL SIGNAL DETECTED:
  - Stochastic crossed over 60 level
  - Stochastic Main crossed below Signal (Main: 58.5 Signal: 62.3)
  - MA(33) = 1.0950 < MA(19) = 1.0965
```

This helps you understand why each position was opened.

### Trade Execution Log
When a position is opened:
```
Sell order opened successfully.
  Lot Size: 0.10
  Entry Price: 1.0975
  Stop Loss: 1.1025
  Take Profit: 1.0875
```

## Troubleshooting

### EA Not Opening Positions
**Check:**
- AutoTrading is enabled (Alt+A)
- Spread is within MaxSpreadPips limit
- No existing positions if MaxPositions = 1
- Expert tab for signal detection logs
- All three conditions are met (very specific, signals may be rare)

### Invalid Lot Size Errors
**Solutions:**
- Verify broker's minimum and maximum lot sizes
- Adjust MinLotSize and MaxLotSize parameters
- Reduce RiskPercent if calculated lots exceed limits
- Ensure account balance is sufficient

### Order Send Errors
**Check:**
- Account balance is sufficient
- Symbol is available for trading
- Broker allows Expert Advisors
- Connection to server is stable
- Stop levels comply with broker requirements

### No Signals for Extended Period
**This is Normal:**
- The EA has very specific entry conditions
- All three conditions must align simultaneously
- Signals may be rare but high-quality
- Consider testing on multiple currency pairs
- Review backtesting results to understand signal frequency

## Risk Warnings

⚠️ **Important Disclaimers**:
- Trading forex carries a high level of risk and may not be suitable for all investors
- Never risk more than you can afford to lose
- Past performance is not indicative of future results
- Always test the EA on a demo account before using real money
- Use the Strategy Tester in MetaTrader 5 to backtest the strategy
- This EA only opens SELL positions - consider market conditions
- The negative MA shift is forward-looking and may cause false signals
- The EA is provided as-is without any guarantees

## Technical Details

### Indicator Specifications
- **Stochastic Oscillator**: 
  - Calculation method: Simple Moving Average (SMA)
  - Price field: Low/High
  - %K period: 14
  - %D period: 19
  - Slowing: 9

- **Moving Averages**:
  - MA Type: Simple Moving Average (SMA)
  - Applied to: Close price
  - MA Fast: 19 periods with -9 shift
  - MA Slow: 33 periods with -9 shift

### Signal Logic
The EA checks conditions on each new bar formation:
1. Copies last 3 bars of Stochastic data
2. Copies last 2 bars of MA data
3. Verifies stochastic crossed over level 60
4. Checks for Main/Signal crossover (bearish)
5. Compares MA values with shift
6. Opens SELL if all conditions true and positions available

### Position Sizing Formula
```
Risk Amount = Account Balance × (Risk Percent / 100)
Stop Loss Points = |Entry Price - Stop Loss| / Point
Lot Size = Risk Amount / (Stop Loss Points × Tick Value / Tick Size)
```

The lot size is then normalized to broker's lot step and limited by min/max values.

## Support & Contributions

This is an open-source project. Feel free to:
- Report issues
- Suggest improvements
- Submit pull requests
- Share your optimization results

## License

This Expert Advisor is provided for educational and research purposes.
