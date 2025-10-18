# MetaTrader 5 Expert Advisors Collection

A collection of Expert Advisors (EAs) for MetaTrader 5, including automated trading and signal generation tools.

## Available Expert Advisors

### 1. ScalpingEA - Automated Scalping with Risk Management
An automated trading EA that uses scalping strategies with comprehensive risk management.

### 2. MultiTimeframeSignalEA - Buy/Sell Signal Indicator
A signal-generating EA that analyzes multiple timeframes to display buy and sell signals on the chart.

### 3. TrailingManager - Comprehensive Trading & Risk Management
An advanced EA that combines automatic position opening with sophisticated trailing stop, break-even, and trailing take-profit management. Features comprehensive risk controls including daily loss limits, position limits, and intelligent trade entry.

### 4. StochasticSellEA - Automated Sell Trading with Stochastic Crossover
An automated trading EA that opens SELL positions based on Stochastic Oscillator crossover above 60 level, combined with momentum reversal and Moving Average confirmation.

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