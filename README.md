# MetaTrader 5 Expert Advisors Collection

A collection of Expert Advisors (EAs) for MetaTrader 5, including automated trading and signal generation tools.

## Available Expert Advisors

### 1. ScalpingEA - Automated Scalping with Risk Management
An automated trading EA that uses scalping strategies with comprehensive risk management.

### 2. MultiTimeframeSignalEA - Buy/Sell Signal Indicator
A signal-generating EA that analyzes multiple timeframes to display buy and sell signals on the chart.

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

## Support & Contributions

This is an open-source project. Feel free to:
- Report issues
- Suggest improvements
- Submit pull requests
- Share your optimization results

## License

These Expert Advisors are provided for educational and research purposes.