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
