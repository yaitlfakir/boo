# Multi-Timeframe Signal EA Documentation

## Overview
This Expert Advisor (EA) analyzes multiple timeframes (1-minute, 5-minute, and 15-minute) to generate buy and sell signals on the chart. The signals are displayed as arrows when specific conditions are met across all timeframes.

## Signal Conditions

### SELL Signal Requirements
A SELL signal is displayed when ALL of the following conditions are true:

**1-Minute Timeframe:**
- Moving Average 3 crosses above Moving Average 9 (MA3 was below MA9 in previous candle, now above)
- Stochastic Oscillator (%K=19, %D=7, slowing=1) signal line value is above 80
- Stochastic Main line is less than Signal line

**5-Minute Timeframe:**
- Stochastic Oscillator (%K=19, %D=3, slowing=1) Main line is less than Signal line

**15-Minute Timeframe:**
- Stochastic Oscillator (%K=19, %D=3, slowing=1) Main line is less than Signal line

### BUY Signal Requirements
A BUY signal is displayed when ALL of the following conditions are true:

**1-Minute Timeframe:**
- Moving Average 3 crosses below Moving Average 9 (MA3 was above MA9 in previous candle, now below)
- Stochastic Oscillator (%K=19, %D=7, slowing=1) signal line value is below 30
- Stochastic Main line is greater than Signal line

**5-Minute Timeframe:**
- Stochastic Oscillator (%K=19, %D=3, slowing=1) Main line is greater than Signal line

**15-Minute Timeframe:**
- Stochastic Oscillator (%K=19, %D=3, slowing=1) Main line is greater than Signal line

## Features

### Visual Signals
- **Buy Arrow**: Green (lime) arrow appears below the candle when buy conditions are met
- **Sell Arrow**: Red arrow appears above the candle when sell conditions are met
- Arrow colors and sizes are customizable

### Alert System
- **Audio Alerts**: Sound notification when signal is detected (enabled by default)
- **Visual Alerts**: Push notification to MetaTrader mobile app (enabled by default)
- **Email Alerts**: Email notification when signal is detected (disabled by default)

## Installation

1. Open MetaTrader 5
2. Click on `File` → `Open Data Folder`
3. Navigate to `MQL5/Experts/`
4. Copy `MultiTimeframeSignalEA.mq5` to this folder
5. Restart MetaTrader 5 or click `Refresh` in the Navigator panel
6. The EA should appear under "Expert Advisors" in the Navigator

## Usage

1. **Attach to Chart**:
   - Open any currency pair chart
   - Drag and drop the MultiTimeframeSignalEA from Navigator to the chart
   - The chart timeframe can be any (the EA analyzes M1, M5, and M15 independently)

2. **Configure Settings**:
   - Adjust arrow colors and size if desired
   - Enable/disable alert types based on your preference

3. **Enable Auto Trading**:
   - Click the "AutoTrading" button in the toolbar (or press Alt+A)
   - Ensure "Allow algorithmic trading" is enabled in Tools → Options → Expert Advisors

4. **Monitor Signals**:
   - Watch for arrows appearing on the chart
   - Listen for audio alerts when signals are generated
   - Check the "Experts" tab for EA activity logs

## Input Parameters

### Signal Display Settings
- **BuyArrowColor** (default: Lime): Color of buy signal arrows
- **SellArrowColor** (default: Red): Color of sell signal arrows
- **ArrowSize** (default: 2): Size of arrows on chart (1-5)

### Alert Settings
- **EnableAlerts** (default: true): Enable/disable audio alerts
- **EnableVisualAlerts** (default: true): Enable/disable push notifications
- **EnableEmailAlerts** (default: false): Enable/disable email alerts

## Technical Details

### Indicators Used

**1-Minute Timeframe:**
- Stochastic Oscillator: %K period = 19, %D period = 7, Slowing = 1
- Simple Moving Average: Period 3
- Simple Moving Average: Period 9

**5-Minute Timeframe:**
- Stochastic Oscillator: %K period = 19, %D period = 3, Slowing = 1

**15-Minute Timeframe:**
- Stochastic Oscillator: %K period = 19, %D period = 3, Slowing = 1

### Signal Generation Logic
- Signals are checked on every new bar formation
- All conditions must be met simultaneously across all timeframes
- SELL signals require MA crossover upward on M1 with stochastic signal > 80
- BUY signals require MA crossover downward on M1 with stochastic signal < 30
- Only one alert is sent per signal occurrence
- Arrows are drawn directly on the chart at the signal bar

## Important Notes

### Performance Considerations
- The EA analyzes data from three different timeframes
- Signals may be rare due to the multiple conditions required
- Works best in trending markets

### Risk Warnings
⚠️ **Important Disclaimers**:
- This EA only provides signals; it does NOT execute trades automatically
- Signals are based on technical analysis and should not be the sole basis for trading decisions
- Always verify signals with your own analysis before entering trades
- Trading forex carries a high level of risk
- Past performance is not indicative of future results
- Always test on a demo account before considering live trading

## Troubleshooting

**No signals appearing:**
- Check that all three timeframes have sufficient data loaded
- Verify that AutoTrading is enabled
- The conditions may simply not be met (signals can be rare)
- Check the Experts tab for any error messages

**Arrows not visible:**
- Try increasing the ArrowSize parameter
- Verify arrow colors are visible against your chart background
- Check that chart objects are not hidden (Ctrl+B to toggle)

**No alerts being triggered:**
- Verify alert settings are enabled
- Check that sound is not muted in MetaTrader
- For email alerts, ensure SMTP settings are configured in Tools → Options → Email

## Version History

### Version 1.00 (Current)
- Initial release
- Multi-timeframe analysis (M1, M5, M15)
- Stochastic oscillator with different parameters per timeframe
- Moving average crossover analysis
- Visual signal display with arrows
- Comprehensive alert system (audio, push, email)
- Customizable display settings

## Support

For issues, questions, or suggestions, please refer to the repository documentation or contact the developer.
