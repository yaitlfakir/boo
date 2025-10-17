# ScalpingEA Technical Documentation

## Overview
This MetaTrader 5 Expert Advisor implements an automated scalping strategy with comprehensive risk management mechanisms to minimize trading risk while pursuing small, consistent profits.

## Scalping Strategy Components

### 1. Technical Indicators
**Dual EMA System:**
- Fast EMA (5 periods): Captures short-term price movements
- Slow EMA (20 periods): Identifies the broader trend direction
- Crossover signals: Entry when fast crosses slow, confirming trend direction

**RSI Oscillator (14 periods):**
- Oversold level (30): Confirms buy signals when RSI is low
- Overbought level (70): Confirms sell signals when RSI is high
- Prevents trading in extreme conditions

### 2. Entry Signals
**Buy Signal Requirements:**
- Fast MA crosses above Slow MA
- RSI is near oversold (< 40)
- Spread is within acceptable limits
- Within trading hours (if time filter enabled)
- No existing open positions

**Sell Signal Requirements:**
- Fast MA crosses below Slow MA
- RSI is near overbought (> 60)
- Spread is within acceptable limits
- Within trading hours (if time filter enabled)
- No existing open positions

## Risk Minimization Features

### 1. Position Sizing
**Dynamic Lot Calculation:**
```
Risk Amount = Account Balance × Risk Percentage / 100
Stop Loss Distance = |Entry Price - Stop Loss| in points
Lot Size = Risk Amount / (Stop Loss Distance × Tick Value)
```

**Benefits:**
- Consistent risk per trade regardless of stop loss distance
- Automatically adjusts to account size
- Prevents over-leveraging

**Safeguards:**
- Normalized to broker's lot step
- Capped at maximum lot size (default: 10.0)
- Floored at minimum lot size (default: 0.01)
- Respects broker's volume limits

### 2. Stop Loss Management
**Fixed Stop Loss:**
- Set at configurable distance (default: 15 pips)
- Applied to every trade without exception
- Calculated precisely based on symbol's point value

**Trailing Stop:**
- Activates after position moves into profit
- Follows price at fixed distance (default: 10 pips)
- Moves only in favorable direction
- Requires minimum step movement (default: 5 pips)
- Locks in profits while allowing further gains

### 3. Take Profit Strategy
**Fixed Take Profit:**
- Set at configurable distance (default: 25 pips)
- Risk-reward ratio of 1:1.67 (15 SL : 25 TP)
- Ensures systematic profit-taking
- Prevents holding losing positions

### 4. Spread Filtering
**Purpose:**
- Avoids trading during high spread conditions
- Maximum spread limit (default: 2 pips)
- Prevents entry costs from eroding profits

**Implementation:**
```
Spread (pips) = (Ask - Bid) / (10 × Point)
Trade only if: Spread ≤ MaxSpreadPips
```

### 5. Position Limits
**One Position at a Time:**
- Prevents multiple simultaneous exposures
- Reduces correlation risk
- Simplifies risk management
- Limits maximum loss per symbol

### 6. Time-Based Filtering
**Trading Hours Control:**
- Configurable start/end hours (default: 8:00-20:00)
- Avoids low-liquidity periods
- Prevents overnight exposure
- Adapts to market sessions

**Benefits:**
- Trades during most liquid hours
- Reduces slippage risk
- Avoids news event volatility (if configured)

## Code Architecture

### Initialization (OnInit)
1. Sets up trade object with magic number
2. Creates indicator handles (Fast MA, Slow MA, RSI)
3. Validates indicator creation
4. Configures array series direction

### Per-Tick Processing (OnTick)
1. **New Bar Check**: Prevents multiple signals per bar
2. **Time Filter**: Validates trading hours
3. **Spread Check**: Ensures acceptable spread
4. **Indicator Update**: Copies latest indicator values
5. **Trailing Stop**: Updates existing positions
6. **Position Check**: Allows only one position
7. **Signal Generation**: Analyzes indicators for entry
8. **Trade Execution**: Opens position if signal valid

### Error Handling
- Validates indicator handles on initialization
- Checks lot size validity before trading
- Verifies order execution success
- Logs all trading activities
- Normalizes all price values to symbol digits

## Risk Parameters Explained

### Conservative Settings (0.5% Risk)
```
RiskPercent = 0.5%
StopLossPips = 20
TakeProfitPips = 30
MaxSpreadPips = 1.5
```
**Maximum Loss per Trade:**
- $1000 account: $5 per trade
- $10000 account: $50 per trade

### Moderate Settings (1.0% Risk)
```
RiskPercent = 1.0%
StopLossPips = 15
TakeProfitPips = 25
MaxSpreadPips = 2.0
```
**Maximum Loss per Trade:**
- $1000 account: $10 per trade
- $10000 account: $100 per trade

### Aggressive Settings (2.0% Risk)
```
RiskPercent = 2.0%
StopLossPips = 10
TakeProfitPips = 20
MaxSpreadPips = 2.5
```
**Maximum Loss per Trade:**
- $1000 account: $20 per trade
- $10000 account: $200 per trade

## Performance Considerations

### Optimal Timeframes
- **M5 (5 minutes)**: Balanced scalping approach
- **M15 (15 minutes)**: More reliable signals, fewer trades
- **M1 (1 minute)**: Very aggressive, requires low spreads

### Recommended Symbols
- **EURUSD**: Low spread, high liquidity
- **GBPUSD**: Good volatility for scalping
- **USDJPY**: Stable spread, clear trends
- **AUDUSD**: Moderate volatility

### Broker Requirements
- **Spread**: Preferably < 1 pip for major pairs
- **Execution**: ECN or STP for best fills
- **Slippage**: Minimal during high liquidity hours
- **Commission**: Low or zero for scalping viability

## Testing Recommendations

### Strategy Tester Settings
1. **Period**: At least 3-6 months of data
2. **Mode**: Every tick based on real ticks
3. **Optimization**: Genetic algorithm for parameters
4. **Metrics to monitor:**
   - Profit factor (target: > 1.5)
   - Sharpe ratio (target: > 1.0)
   - Maximum drawdown (target: < 20%)
   - Win rate (target: > 55%)
   - Average trade duration

### Forward Testing
- Start with demo account
- Use conservative settings initially
- Monitor for at least 50 trades
- Compare results with backtest
- Gradually increase risk if consistent

## Maintenance and Monitoring

### Daily Checks
- Verify EA is running (check Experts tab)
- Review overnight positions (if any)
- Check for error messages
- Monitor account balance changes

### Weekly Analysis
- Calculate win rate and profit factor
- Review largest losing trades
- Analyze optimal trading hours
- Adjust parameters if needed

### Monthly Optimization
- Backtest recent period
- Compare with live results
- Update parameters based on market conditions
- Review correlation with other strategies

## Limitations and Risks

### Known Limitations
1. **Broker Dependency**: Performance varies by broker
2. **Spread Sensitivity**: High spreads reduce profitability
3. **Market Conditions**: Works best in trending markets
4. **Slippage**: Can impact actual vs. expected fills
5. **News Events**: May trigger false signals

### Risk Factors
- **Market Risk**: Unexpected price movements
- **Execution Risk**: Order rejection or slippage
- **Technology Risk**: Connection loss or platform issues
- **Parameter Risk**: Over-optimization to historical data
- **Liquidity Risk**: Low volume periods

## Compliance and Disclaimer

**Important Notes:**
- This EA is provided for educational purposes
- No guarantee of profitability
- Past performance ≠ future results
- User assumes all trading risks
- Always test thoroughly before live trading
- Comply with local regulations regarding automated trading

**Recommended Practices:**
- Never risk more than you can afford to lose
- Start with minimum lot sizes
- Use demo account for at least 30 days
- Monitor EA performance regularly
- Have a stop-trading plan for consecutive losses
- Maintain adequate account balance for margin requirements

## Version History

### Version 1.00 (Current)
- Initial release
- Dual EMA crossover strategy
- RSI confirmation
- Dynamic position sizing
- Trailing stop functionality
- Time and spread filtering
- One position limit
- Comprehensive risk management

## Future Enhancements (Potential)

### Planned Features
- Multiple timeframe analysis
- News calendar integration
- Breakeven stop loss activation
- Partial position closing
- ATR-based dynamic stops
- Correlation filters
- Session-based parameter adjustment
- Telegram/email notifications

### Advanced Risk Features
- Maximum daily loss limit
- Maximum consecutive loss protection
- Drawdown-based position size reduction
- Volatility-adjusted stop loss
- Multi-currency portfolio risk management
