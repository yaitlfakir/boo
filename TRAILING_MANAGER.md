# TrailingManager EA - Comprehensive Trading & Risk Management

## Overview
TrailingManager is an advanced Expert Advisor for MetaTrader 5 that combines automatic position opening with sophisticated trailing stop, break-even, and trailing take-profit management. It provides comprehensive risk management features to protect your trading capital.

## Key Features

### Automatic Trading
- **EMA Crossover Strategy**: Uses Fast EMA (default: 5) and Slow EMA (default: 20) for trend identification
- **RSI Confirmation**: Confirms entry signals with RSI indicator to avoid false breakouts
- **Smart Entry Logic**: Only enters when market conditions align across multiple indicators

### Risk Management
- **Position Sizing**: Automatically calculates lot size based on risk percentage and stop loss
- **Maximum Positions**: Limits the number of concurrent open positions (default: 3)
- **Daily Loss Limit**: Automatically stops trading if daily loss threshold is exceeded (default: 5%)
- **Spread Filter**: Prevents trading during high spread conditions (default: 2 pips)
- **Trading Hours**: Restricts trading to specified hours to avoid low liquidity periods

### Position Management
- **Initial SL/TP Placement**: Automatically sets stop loss and take profit when opening positions
- **Break-Even**: Automatically moves stop loss to entry price + offset when profit target is reached
- **Trailing Stop**: Follows price movement to lock in profits while allowing position to run
- **Trailing Take-Profit**: Keeps take profit target ahead of price as it moves favorably
- **Broker Compliance**: Respects broker's minimum stop levels and freeze levels

## Installation

1. Open MetaTrader 5
2. Click on `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `TrailingManager.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in the Navigator panel
6. The EA should appear under "Expert Advisors" in the Navigator

## Configuration

### Position Management
- **InpMagicNumber** (default: 0): Unique identifier for EA's trades (0 = manage all positions)
- **InpOnlyThisSymbol** (default: true): Only manage positions on the current chart symbol

### Auto Trading Parameters
- **InpAutoTrade** (default: true): Enable/disable automatic position opening
- **InpFastEMA_Period** (default: 5): Period for fast exponential moving average
- **InpSlowEMA_Period** (default: 20): Period for slow exponential moving average
- **InpRSI_Period** (default: 14): RSI calculation period
- **InpRSI_Oversold** (default: 30): RSI level for oversold condition (buy signal)
- **InpRSI_Overbought** (default: 70): RSI level for overbought condition (sell signal)

### Risk Management
- **InpRiskPercent** (default: 1.0%): Risk per trade as percentage of account balance
- **InpMaxOpenPositions** (default: 3): Maximum number of simultaneous open positions
- **InpMaxDailyLossPercent** (default: 5.0%): Maximum daily loss before stopping trading
- **InpMaxSpreadPips** (default: 2.0): Maximum allowed spread in pips

### Trading Hours
- **InpUseTimeFilter** (default: true): Enable/disable time-based trading restriction
- **InpStartHour** (default: 8): Start trading hour (server time)
- **InpEndHour** (default: 20): End trading hour (server time)

### Initial SL/TP Placement
- **InpInitialSL_Points** (default: 150): Initial stop loss distance in points
- **InpInitialTP_Points** (default: 250): Initial take profit distance in points

### Break-Even Settings
- **InpUseBreakEven** (default: true): Enable break-even functionality
- **InpBE_Trigger_Points** (default: 500): Profit level to trigger break-even (in points)
- **InpBE_Offset_Points** (default: 20): Offset beyond entry price when moving to break-even

### Trailing Stop Settings
- **InpUseTrailingStop** (default: true): Enable trailing stop functionality
- **InpTS_Trigger_Points** (default: 600): Profit level to activate trailing stop
- **InpTS_Distance_Points** (default: 150): Distance from current price for trailing stop
- **InpTS_Step_Points** (default: 20): Minimum price movement before updating stop

### Trailing Take-Profit Settings
- **InpUseTrailingTP** (default: true): Enable trailing take-profit functionality
- **InpTTP_Distance_Points** (default: 2000): Distance ahead of price for take profit
- **InpTTP_Step_Points** (default: 20): Minimum movement before updating take profit

### Misc Settings
- **InpModifyThrottleMs** (default: 100): Minimum milliseconds between position modifications
- **InpLogActions** (default: true): Enable logging to the Experts tab

## Usage

### Basic Setup
1. Attach the EA to a chart (recommended: EURUSD, GBPUSD, USDJPY on M5 or M15)
2. Configure your risk parameters based on your risk tolerance
3. Enable "AutoTrading" in MetaTrader 5 (Alt+A or toolbar button)
4. Monitor the Experts tab for EA activity

### Trading Strategy

**BUY Signal Generated When:**
- Fast EMA crosses above Slow EMA (bullish crossover)
- RSI is below oversold level + 10 (confirming upward potential)
- Spread is acceptable
- Within trading hours (if time filter is enabled)
- Maximum positions not reached
- Daily loss limit not exceeded

**SELL Signal Generated When:**
- Fast EMA crosses below Slow EMA (bearish crossover)
- RSI is above overbought level - 10 (confirming downward potential)
- Spread is acceptable
- Within trading hours (if time filter is enabled)
- Maximum positions not reached
- Daily loss limit not exceeded

### Position Management Workflow

1. **Entry**: Position opens with initial SL and TP based on configured points
2. **Break-Even**: When profit reaches trigger level, SL moves to entry + offset
3. **Trailing Stop**: After reaching higher profit, SL trails behind price at specified distance
4. **Trailing TP**: TP continuously adjusts to stay ahead of price movement
5. **Exit**: Position closes when price hits SL or TP, or manually closed by trader

## Risk Management Features

### Daily Loss Protection
The EA tracks your account balance from the start of each trading day. If losses reach the configured percentage:
- No new positions will be opened
- Existing positions continue to be managed
- Trading resumes the next day

### Position Sizing
Lot size is automatically calculated using the formula:
```
Lot Size = (Account Balance × Risk%) / (Stop Loss Distance × Tick Value)
```
This ensures consistent risk per trade regardless of account size or stop loss distance.

### Maximum Positions
Limits concurrent exposure by restricting the number of open positions. This prevents overexposure during volatile periods.

## Recommended Settings

### Conservative (Low Risk)
```
InpRiskPercent = 0.5%
InpMaxOpenPositions = 2
InpMaxDailyLossPercent = 3.0%
InpInitialSL_Points = 200
InpInitialTP_Points = 300
InpBE_Trigger_Points = 300
```

### Moderate (Medium Risk)
```
InpRiskPercent = 1.0%
InpMaxOpenPositions = 3
InpMaxDailyLossPercent = 5.0%
InpInitialSL_Points = 150
InpInitialTP_Points = 250
InpBE_Trigger_Points = 500
```

### Aggressive (High Risk)
```
InpRiskPercent = 2.0%
InpMaxOpenPositions = 5
InpMaxDailyLossPercent = 8.0%
InpInitialSL_Points = 100
InpInitialTP_Points = 200
InpBE_Trigger_Points = 700
```

## Strategy Testing

To backtest the EA:
1. Press Ctrl+R to open Strategy Tester
2. Select "TrailingManager" from the Expert Advisor list
3. Choose symbol (e.g., EURUSD)
4. Select timeframe (M5 or M15 recommended)
5. Set date range for testing
6. Configure input parameters
7. Click "Start" to run the backtest
8. Review results in the "Results" and "Graph" tabs

## Troubleshooting

### EA Not Opening Positions
- Check that AutoTrading is enabled
- Verify `InpAutoTrade` is set to `true`
- Check spread is within `InpMaxSpreadPips` limit
- Ensure within trading hours (if time filter is enabled)
- Verify daily loss limit not exceeded
- Check that max positions limit not reached
- Review Experts tab for error messages

### Positions Not Being Modified
- Check `InpModifyThrottleMs` - may need to wait between modifications
- Verify broker allows position modification
- Ensure broker's stop levels are respected
- Check that break-even/trailing conditions are met

### Invalid Lot Size Errors
- Verify broker's minimum and maximum lot sizes
- Adjust `InpRiskPercent` if calculated lots exceed limits
- Check account balance is sufficient
- Review lot step settings for the symbol

### Daily Loss Limit Triggered
- Check account history to verify daily losses
- Wait until next trading day for EA to resume
- Consider adjusting `InpMaxDailyLossPercent` if too restrictive
- Review your trading strategy if losses are consistent

## How It Works

### Position Opening Logic
1. Wait for new bar formation
2. Calculate EMA and RSI values
3. Check for crossover conditions
4. Verify RSI confirmation
5. Check risk management criteria (spread, time, limits)
6. Calculate appropriate lot size
7. Open position with SL and TP

### Position Management Logic
1. Monitor all open positions every tick
2. Check if SL/TP needs initial placement
3. Evaluate break-even conditions
4. Update trailing stop if criteria met
5. Adjust trailing take-profit if needed
6. Respect broker constraints (stop levels, freeze levels)
7. Apply modification throttle to avoid over-trading

## Risk Warnings

⚠️ **Important Disclaimers:**
- Trading forex carries substantial risk and may not be suitable for all investors
- Never risk more than you can afford to lose
- Past performance is not indicative of future results
- Always test the EA thoroughly on a demo account before using real money
- Use the Strategy Tester to validate the strategy on historical data
- The EA is provided as-is without any guarantees or warranties
- Market conditions can change rapidly; monitor your positions regularly
- Slippage and execution delays may affect actual results
- Broker spreads and commissions will impact profitability

## Advanced Tips

1. **Optimization**: Use Strategy Tester's optimization feature to find best parameters for your symbol and timeframe
2. **Multiple Symbols**: Run the EA on different charts for diversification
3. **Correlation**: Avoid running on highly correlated pairs to prevent overexposure
4. **News Events**: Consider disabling EA during major economic announcements
5. **VPS Usage**: Consider using a VPS for 24/7 operation and consistent execution
6. **Regular Review**: Periodically review and adjust settings based on market conditions
7. **Combine Strategies**: Can work alongside other non-correlated strategies for portfolio diversification

## Support

This is an open-source project. Feel free to:
- Report issues on the repository
- Suggest improvements
- Share your optimization results
- Submit pull requests for enhancements

## License

This Expert Advisor is provided for educational and research purposes. Use at your own risk.
