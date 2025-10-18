# ScalpingEA - Example Settings Files

## Example 1: Ultra-Conservative (Capital Preservation)
**Best for:** New traders, demo testing, small accounts
**Risk Level:** Very Low
**Expected:** Fewer trades, smaller profits, minimal drawdown

```ini
;--- Trading Parameters ---
FastMA_Period=7
SlowMA_Period=25
RSI_Period=14
RSI_Oversold=25
RSI_Overbought=75

;--- Risk Management ---
RiskPercent=0.25
StopLossPips=25.0
TakeProfitPips=40.0
MaxSpreadPips=1.0
UseTrailingStop=true
TrailingStopPips=15.0
TrailingStepPips=5.0

;--- Position Management ---
MagicNumber=123456
TradeComment=ScalpEA_Conservative
MaxLotSize=1.0
MinLotSize=0.01

;--- Trading Hours ---
UseTimeFilter=true
StartHour=9
EndHour=16
```

**Expected Performance (per month):**
- Trades: 10-20
- Win Rate: 60-70%
- Max Risk: 0.25% per trade
- Target Return: 2-5%

---

## Example 2: Conservative (Safe Growth)
**Best for:** Beginner to intermediate traders
**Risk Level:** Low
**Expected:** Balanced trading, steady growth

```ini
;--- Trading Parameters ---
FastMA_Period=5
SlowMA_Period=20
RSI_Period=14
RSI_Oversold=30
RSI_Overbought=70

;--- Risk Management ---
RiskPercent=0.5
StopLossPips=20.0
TakeProfitPips=30.0
MaxSpreadPips=1.5
UseTrailingStop=true
TrailingStopPips=12.0
TrailingStepPips=5.0

;--- Position Management ---
MagicNumber=123456
TradeComment=ScalpEA_Safe
MaxLotSize=2.0
MinLotSize=0.01

;--- Trading Hours ---
UseTimeFilter=true
StartHour=8
EndHour=20
```

**Expected Performance (per month):**
- Trades: 20-40
- Win Rate: 55-65%
- Max Risk: 0.5% per trade
- Target Return: 3-8%

---

## Example 3: Moderate (Default Settings)
**Best for:** Intermediate traders with some experience
**Risk Level:** Medium
**Expected:** Active trading, good risk-reward balance

```ini
;--- Trading Parameters ---
FastMA_Period=5
SlowMA_Period=20
RSI_Period=14
RSI_Oversold=30
RSI_Overbought=70

;--- Risk Management ---
RiskPercent=1.0
StopLossPips=15.0
TakeProfitPips=25.0
MaxSpreadPips=2.0
UseTrailingStop=true
TrailingStopPips=10.0
TrailingStepPips=5.0

;--- Position Management ---
MagicNumber=123456
TradeComment=ScalpEA
MaxLotSize=10.0
MinLotSize=0.01

;--- Trading Hours ---
UseTimeFilter=true
StartHour=8
EndHour=20
```

**Expected Performance (per month):**
- Trades: 40-80
- Win Rate: 55-60%
- Max Risk: 1.0% per trade
- Target Return: 5-12%

---

## Example 4: Aggressive (Active Trading)
**Best for:** Experienced traders comfortable with higher risk
**Risk Level:** High
**Expected:** Frequent trades, higher volatility

```ini
;--- Trading Parameters ---
FastMA_Period=3
SlowMA_Period=15
RSI_Period=10
RSI_Oversold=35
RSI_Overbought=65

;--- Risk Management ---
RiskPercent=2.0
StopLossPips=12.0
TakeProfitPips=20.0
MaxSpreadPips=2.5
UseTrailingStop=true
TrailingStopPips=8.0
TrailingStepPips=3.0

;--- Position Management ---
MagicNumber=123456
TradeComment=ScalpEA_Aggressive
MaxLotSize=10.0
MinLotSize=0.01

;--- Trading Hours ---
UseTimeFilter=false
StartHour=0
EndHour=23
```

**Expected Performance (per month):**
- Trades: 80-150
- Win Rate: 50-55%
- Max Risk: 2.0% per trade
- Target Return: 10-20% (or larger drawdowns)

---

## Example 5: Night Scalper (London/NY Session)
**Best for:** Trading major news and high liquidity periods
**Risk Level:** Medium
**Expected:** Focused on high-volume sessions

```ini
;--- Trading Parameters ---
FastMA_Period=5
SlowMA_Period=20
RSI_Period=14
RSI_Oversold=30
RSI_Overbought=70

;--- Risk Management ---
RiskPercent=1.0
StopLossPips=15.0
TakeProfitPips=25.0
MaxSpreadPips=1.5
UseTrailingStop=true
TrailingStopPips=10.0
TrailingStepPips=5.0

;--- Position Management ---
MagicNumber=123456
TradeComment=ScalpEA_Sessions
MaxLotSize=5.0
MinLotSize=0.01

;--- Trading Hours (GMT/UTC) ---
UseTimeFilter=true
StartHour=7        ; London open
EndHour=16         ; NY mid-day
```

**Expected Performance (per month):**
- Trades: 30-60
- Win Rate: 55-60%
- Max Risk: 1.0% per trade
- Target Return: 5-10%

---

## Example 6: Asian Session (Low Volatility)
**Best for:** Quiet market conditions, range trading
**Risk Level:** Low-Medium
**Expected:** Fewer but higher quality trades

```ini
;--- Trading Parameters ---
FastMA_Period=8
SlowMA_Period=25
RSI_Period=14
RSI_Oversold=30
RSI_Overbought=70

;--- Risk Management ---
RiskPercent=0.75
StopLossPips=18.0
TakeProfitPips=27.0
MaxSpreadPips=1.2
UseTrailingStop=true
TrailingStopPips=12.0
TrailingStepPips=4.0

;--- Position Management ---
MagicNumber=123456
TradeComment=ScalpEA_Asian
MaxLotSize=3.0
MinLotSize=0.01

;--- Trading Hours (GMT/UTC) ---
UseTimeFilter=true
StartHour=0        ; Tokyo open
EndHour=6          ; Before London
```

**Expected Performance (per month):**
- Trades: 15-30
- Win Rate: 60-65%
- Max Risk: 0.75% per trade
- Target Return: 3-7%

---

## Symbol-Specific Recommendations

### EURUSD (Most Popular)
```
Settings: Moderate (Example 3)
Timeframe: M5 or M15
Spread Target: < 0.5 pips
Best Sessions: London, NY Overlap (12:00-16:00 GMT)
```

### GBPUSD (Higher Volatility)
```
Settings: Conservative (Example 2)
FastMA_Period: 7
StopLossPips: 20.0
TakeProfitPips: 30.0
Timeframe: M15
Spread Target: < 1.0 pips
```

### USDJPY (Smooth Movements)
```
Settings: Moderate (Example 3)
FastMA_Period: 5
StopLossPips: 15.0
TakeProfitPips: 25.0
Timeframe: M5
Spread Target: < 0.8 pips
```

### AUDUSD (Asian/Pacific)
```
Settings: Asian Session (Example 6)
Trading Hours: 0:00-8:00 GMT
Timeframe: M15
MaxSpreadPips: 1.5
```

### GOLD/XAUUSD (High Volatility)
```
Settings: Conservative adapted for gold
StopLossPips: 50.0 (gold has larger pip values)
TakeProfitPips: 80.0
MaxSpreadPips: 5.0
RiskPercent: 0.5
Timeframe: M15 or M30
```

---

## Testing Configuration
**For Strategy Tester backtesting:**

```ini
;--- Testing Settings ---
Period: 2024.01.01 - 2024.06.30 (6 months minimum)
Model: Every tick based on real ticks
Deposit: 10000 USD
Leverage: 1:100
Symbol: EURUSD
Timeframe: M5

;--- EA Settings ---
Use: Moderate (Example 3) settings
RiskPercent: 1.0
StopLossPips: 15.0
TakeProfitPips: 25.0
```

**Metrics to Monitor:**
- Total Net Profit
- Profit Factor (target: > 1.5)
- Expected Payoff (target: > 0)
- Absolute Drawdown (target: < 10%)
- Maximal Drawdown (target: < 20%)
- Win Rate (target: > 55%)
- Total Trades (target: > 50 for 6 months)

---

## Optimization Ranges
**If you want to optimize the EA, use these ranges:**

```
FastMA_Period: 3 to 10, step 1
SlowMA_Period: 15 to 30, step 5
RSI_Period: 10 to 20, step 2
RSI_Oversold: 20 to 35, step 5
RSI_Overbought: 65 to 80, step 5
StopLossPips: 10 to 30, step 5
TakeProfitPips: 15 to 40, step 5
TrailingStopPips: 5 to 20, step 5
```

**Warning:** Be careful of over-optimization! Always validate optimized parameters with forward testing.

---

## How to Apply These Settings

### Method 1: Manual Input
1. Attach EA to chart
2. In the "Inputs" tab, enter values from chosen example
3. Click OK

### Method 2: Save as Preset
1. Configure EA with desired settings
2. Click "Save" button in inputs dialog
3. Name your preset (e.g., "Conservative")
4. Load preset next time by clicking "Load"

### Method 3: .set File
1. Copy settings from example
2. Save as `ScalpingEA_[Name].set` in `MQL5/Presets/`
3. Load from dropdown in EA inputs dialog

---

## StochasticSellEA - Example Settings

### Example 1: Conservative Sell Strategy
**Best for:** Testing the strategy, risk-averse traders
**Risk Level:** Low
**Expected:** Rare but high-quality sell signals

```ini
;--- Stochastic Parameters ---
Stoch_K_Period=14
Stoch_D_Period=19
Stoch_Slowing=9
Stoch_Level=70.0       ; Stricter overbought (was 60)

;--- Moving Average Parameters ---
MA_Fast_Period=19
MA_Slow_Period=33
MA_Shift=-9

;--- Risk Management ---
RiskPercent=0.5
StopLossPips=60.0
TakeProfitPips=120.0
MaxSpreadPips=2.5

;--- Position Management ---
MagicNumber=789456
TradeComment=StochSell_Conservative
MaxLotSize=5.0
MinLotSize=0.01
MaxPositions=1
```

**Expected Performance:**
- Signals: Very rare (stricter conditions)
- Win Rate: 55-65%
- Risk per trade: 0.5%
- Best Timeframe: H1 or H4

---

### Example 2: Moderate Sell Strategy (Default)
**Best for:** Standard use, balanced approach
**Risk Level:** Medium
**Expected:** Balanced signal frequency and quality

```ini
;--- Stochastic Parameters ---
Stoch_K_Period=14
Stoch_D_Period=19
Stoch_Slowing=9
Stoch_Level=60.0

;--- Moving Average Parameters ---
MA_Fast_Period=19
MA_Slow_Period=33
MA_Shift=-9

;--- Risk Management ---
RiskPercent=1.0
StopLossPips=50.0
TakeProfitPips=100.0
MaxSpreadPips=3.0

;--- Position Management ---
MagicNumber=789456
TradeComment=StochSell
MaxLotSize=10.0
MinLotSize=0.01
MaxPositions=1
```

**Expected Performance:**
- Signals: Rare but regular
- Win Rate: 50-60%
- Risk per trade: 1.0%
- Best Timeframe: H1

---

### Example 3: Aggressive Sell Strategy
**Best for:** Experienced traders, more active trading
**Risk Level:** High
**Expected:** More frequent signals, higher risk

```ini
;--- Stochastic Parameters ---
Stoch_K_Period=10      ; Faster stochastic
Stoch_D_Period=15      ; Faster signal
Stoch_Slowing=7
Stoch_Level=50.0       ; Less strict (was 60)

;--- Moving Average Parameters ---
MA_Fast_Period=15      ; Faster MAs
MA_Slow_Period=28
MA_Shift=-7            ; Less forward-looking

;--- Risk Management ---
RiskPercent=2.0
StopLossPips=40.0
TakeProfitPips=80.0
MaxSpreadPips=3.5

;--- Position Management ---
MagicNumber=789456
TradeComment=StochSell_Aggressive
MaxLotSize=10.0
MinLotSize=0.01
MaxPositions=2         ; Allow 2 positions
```

**Expected Performance:**
- Signals: More frequent
- Win Rate: 45-55%
- Risk per trade: 2.0%
- Best Timeframe: M30 or H1

---

### Example 4: Scalping Sell (Lower Timeframes)
**Best for:** Active traders, quick trades
**Risk Level:** Medium-High
**Expected:** Frequent signals on lower timeframes

```ini
;--- Stochastic Parameters ---
Stoch_K_Period=8       ; Very fast
Stoch_D_Period=12
Stoch_Slowing=5
Stoch_Level=55.0

;--- Moving Average Parameters ---
MA_Fast_Period=13
MA_Slow_Period=21
MA_Shift=-5

;--- Risk Management ---
RiskPercent=1.0
StopLossPips=25.0      ; Tighter stops for scalping
TakeProfitPips=50.0
MaxSpreadPips=2.0      ; Stricter spread for scalping

;--- Position Management ---
MagicNumber=789456
TradeComment=StochSell_Scalp
MaxLotSize=5.0
MinLotSize=0.01
MaxPositions=1
```

**Expected Performance:**
- Signals: More frequent
- Win Rate: 50-58%
- Risk per trade: 1.0%
- Best Timeframe: M15 or M30

---

### Example 5: Swing Sell (Higher Timeframes)
**Best for:** Swing traders, patient approach
**Risk Level:** Low-Medium
**Expected:** Rare signals, larger profits

```ini
;--- Stochastic Parameters ---
Stoch_K_Period=21      ; Slower, smoother
Stoch_D_Period=25
Stoch_Slowing=12
Stoch_Level=65.0

;--- Moving Average Parameters ---
MA_Fast_Period=25
MA_Slow_Period=50
MA_Shift=-12           ; More forward-looking

;--- Risk Management ---
RiskPercent=0.75
StopLossPips=100.0     ; Wider stops for swing trading
TakeProfitPips=200.0
MaxSpreadPips=4.0

;--- Position Management ---
MagicNumber=789456
TradeComment=StochSell_Swing
MaxLotSize=10.0
MinLotSize=0.01
MaxPositions=1
```

**Expected Performance:**
- Signals: Rare
- Win Rate: 55-65%
- Risk per trade: 0.75%
- Best Timeframe: H4 or D1

---

## Symbol-Specific Recommendations for StochasticSellEA

### EURUSD (Most Popular)
```
Settings: Moderate (Example 2)
Timeframe: H1
Stoch_Level: 60.0
StopLossPips: 50.0
TakeProfitPips: 100.0
Spread Target: < 1.0 pips
```

### GBPUSD (High Volatility)
```
Settings: Conservative (Example 1)
Timeframe: H1 or H4
StopLossPips: 70.0
TakeProfitPips: 140.0
MaxSpreadPips: 3.0
Spread Target: < 2.0 pips
```

### USDJPY (Smooth Trends)
```
Settings: Moderate (Example 2)
Timeframe: H1
Stoch_Level: 65.0 (stricter)
StopLossPips: 50.0
TakeProfitPips: 100.0
```

### GOLD/XAUUSD (High Volatility)
```
Settings: Swing Sell (Example 5)
Timeframe: H4
StopLossPips: 150.0 (gold has larger movements)
TakeProfitPips: 300.0
MaxSpreadPips: 8.0
RiskPercent: 0.5 (lower due to volatility)
```

### AUDUSD (Clear Trends)
```
Settings: Moderate to Aggressive
Timeframe: H1
Stoch_Level: 60.0
MA periods: Default (19, 33)
```

---

## Testing Configuration for StochasticSellEA

**For Strategy Tester backtesting:**

```ini
;--- Testing Settings ---
Period: 2024.01.01 - 2024.12.31 (1 year minimum)
Model: Every tick based on real ticks
Deposit: 10000 USD
Leverage: 1:100
Symbol: EURUSD
Timeframe: H1

;--- EA Settings ---
Use: Moderate (Example 2) settings
RiskPercent: 1.0
StopLossPips: 50.0
TakeProfitPips: 100.0
Stoch_Level: 60.0
```

**Metrics to Monitor:**
- Total Trades (expect fewer than other EAs - this is normal)
- Win Rate (target: > 50%)
- Profit Factor (target: > 1.3)
- Average Profit per Trade
- Maximum Consecutive Losses
- Recovery Factor (Net Profit / Max Drawdown)

**Important:** This EA only opens SELL positions, so:
- Avoid testing in strong uptrends
- Best results in ranging or bearish markets
- Consider overall market direction when activating

---

## Optimization Ranges for StochasticSellEA

**If you want to optimize the EA, use these ranges:**

```
Stoch_K_Period: 8 to 21, step 2
Stoch_D_Period: 12 to 25, step 2
Stoch_Slowing: 5 to 12, step 1
Stoch_Level: 50 to 70, step 5
MA_Fast_Period: 13 to 25, step 2
MA_Slow_Period: 21 to 50, step 3
MA_Shift: -12 to -5, step 1
StopLossPips: 30 to 80, step 10
TakeProfitPips: 60 to 160, step 20
```

**Optimization Tips:**
1. Optimize Stochastic parameters first
2. Then optimize MA parameters
3. Finally optimize risk parameters (SL/TP)
4. Use "Complex Criterion" = Balance + Profit Factor
5. Always forward test optimized results!

---

## Special Considerations for StochasticSellEA

### Market Direction Awareness
⚠️ **This EA only opens SELL positions:**
- Not suitable for strong bull markets
- Best in bearish or ranging conditions
- Consider fundamental market direction
- May want to disable during major bullish news

### Signal Frequency
📊 **Signals will be rare:**
- Three strict conditions must align
- This is by design for quality over quantity
- Don't expect daily signals
- Some weeks may have zero signals
- This is NORMAL and expected

### Negative MA Shift Explained
🔄 **The -9 shift is forward-looking:**
- Uses "future" MA values (shifted left on chart)
- Provides earlier signals
- Can cause false signals in choppy markets
- Test thoroughly to understand behavior
- Consider reducing shift for more conservative approach

### Best Use Cases
✅ **This EA works best when:**
- Market is in a topping pattern
- Previous uptrend showing weakness
- Range-bound market with resistance rejections
- Risk-off sentiment in markets

❌ **Avoid using when:**
- Strong uptrend established
- Major bullish fundamentals
- Low volatility periods
- Immediately after bullish breakouts

---

## Important Reminders

⚠️ **Before Using Any Settings:**
1. Test on demo account first
2. Backtest for at least 3-6 months
3. Verify spread conditions with your broker
4. Adjust timeframe based on your style
5. Monitor first 20-30 trades closely
6. Never risk more than you can afford to lose

💡 **Tips:**
- Start with Conservative settings
- Gradually increase risk as you gain confidence
- Keep detailed logs of performance
- Adjust parameters based on your results
- Different symbols may need different settings
- Market conditions change - review monthly

📊 **Record Keeping:**
- Note which settings you use
- Track win rate and profit factor
- Record any manual interventions
- Document market conditions
- Save backtest reports for comparison
