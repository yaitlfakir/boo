# ScalpingEA Trading Workflow

## EA Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    EA INITIALIZATION                         │
│  • Create indicator handles (Fast MA, Slow MA, RSI)         │
│  • Set trade parameters (Magic Number, Filling Type)        │
│  • Configure array directions                               │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                   ON EVERY TICK                              │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
                   ┌──────────────┐
                   │  New Bar?    │────── NO ──────► EXIT
                   └──────┬───────┘
                          │ YES
                          ▼
                   ┌──────────────┐
                   │ Within       │────── NO ──────► EXIT
                   │ Trading      │
                   │ Hours?       │
                   └──────┬───────┘
                          │ YES
                          ▼
                   ┌──────────────┐
                   │ Spread       │────── NO ──────► EXIT
                   │ Acceptable?  │
                   └──────┬───────┘
                          │ YES
                          ▼
                   ┌──────────────┐
                   │ Copy         │
                   │ Indicator    │
                   │ Values       │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │ Update       │
                   │ Trailing     │
                   │ Stops        │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │ Has Open     │────── YES ─────► EXIT
                   │ Position?    │             (Only 1 position)
                   └──────┬───────┘
                          │ NO
                          ▼
                   ┌──────────────┐
                   │ Get Trading  │
                   │ Signal       │
                   └──────┬───────┘
                          │
            ┌─────────────┼─────────────┐
            │             │             │
            ▼             ▼             ▼
     ┌──────────┐  ┌──────────┐  ┌──────────┐
     │ BUY      │  │ NO       │  │ SELL     │
     │ Signal   │  │ Signal   │  │ Signal   │
     │ (+1)     │  │ (0)      │  │ (-1)     │
     └────┬─────┘  └────┬─────┘  └────┬─────┘
          │             │             │
          │             ▼             │
          │          EXIT             │
          │                           │
          ▼                           ▼
┌─────────────────┐         ┌─────────────────┐
│  OPEN BUY       │         │  OPEN SELL      │
│  ORDER          │         │  ORDER          │
└────────┬────────┘         └────────┬────────┘
         │                           │
         └───────────┬───────────────┘
                     │
                     ▼
              ┌─────────────┐
              │ Calculate   │
              │ Lot Size    │
              │ (Risk Based)│
              └──────┬──────┘
                     │
                     ▼
              ┌─────────────┐
              │ Calculate   │
              │ SL & TP     │
              └──────┬──────┘
                     │
                     ▼
              ┌─────────────┐
              │ Validate    │
              │ Lot Size    │
              └──────┬──────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
   ┌─────────┐              ┌─────────┐
   │ VALID   │              │ INVALID │
   └────┬────┘              └────┬────┘
        │                         │
        ▼                         ▼
   ┌─────────┐              ┌─────────┐
   │ Execute │              │  LOG    │
   │ Trade   │              │ ERROR   │
   └────┬────┘              └─────────┘
        │
        ▼
   ┌─────────┐
   │ SUCCESS?│
   └────┬────┘
        │
   ┌────┴────┐
   │         │
   ▼         ▼
┌─────┐  ┌─────┐
│ LOG │  │ LOG │
│ OK  │  │ERROR│
└─────┘  └─────┘
```

## Buy Signal Logic

```
┌─────────────────────────────────────┐
│     INDICATOR ANALYSIS              │
├─────────────────────────────────────┤
│ • Fast MA[1] > Slow MA[1]           │ ◄── Current crossover
│ • Fast MA[2] ≤ Slow MA[2]           │ ◄── Previous relationship
│ • RSI[1] < RSI_Oversold + 10        │ ◄── Near oversold (< 40)
└─────────────┬───────────────────────┘
              │ ALL TRUE
              ▼
        ┌───────────┐
        │ BUY SIGNAL│
        └───────────┘
```

## Sell Signal Logic

```
┌─────────────────────────────────────┐
│     INDICATOR ANALYSIS              │
├─────────────────────────────────────┤
│ • Fast MA[1] < Slow MA[1]           │ ◄── Current crossover
│ • Fast MA[2] ≥ Slow MA[2]           │ ◄── Previous relationship
│ • RSI[1] > RSI_Overbought - 10      │ ◄── Near overbought (> 60)
└─────────────┬───────────────────────┘
              │ ALL TRUE
              ▼
        ┌───────────┐
        │SELL SIGNAL│
        └───────────┘
```

## Position Sizing Calculation

```
┌──────────────────────────────────────────────────────┐
│              CALCULATE LOT SIZE                       │
└────────────────────┬─────────────────────────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │ Get Account Balance    │
        └────────┬───────────────┘
                 │
                 ▼
        ┌────────────────────────┐
        │ Risk Amount =          │
        │ Balance × Risk% / 100  │
        └────────┬───────────────┘
                 │
                 ▼
        ┌────────────────────────┐
        │ SL Distance (points) = │
        │ |Entry - StopLoss|/pt  │
        └────────┬───────────────┘
                 │
                 ▼
        ┌────────────────────────┐
        │ Lot Size =             │
        │ Risk$ / (SL_pts ×      │
        │ TickValue/TickSize)    │
        └────────┬───────────────┘
                 │
                 ▼
        ┌────────────────────────┐
        │ Normalize to Lot Step  │
        │ (Floor to step size)   │
        └────────┬───────────────┘
                 │
                 ▼
        ┌────────────────────────┐
        │ Apply Min/Max Limits:  │
        │ • Broker Min/Max       │
        │ • EA Min/Max           │
        └────────┬───────────────┘
                 │
                 ▼
        ┌────────────────────────┐
        │ Return Normalized Lot  │
        └────────────────────────┘
```

## Trailing Stop Logic

```
For Each Open Position:
    │
    ▼
┌─────────────────────┐
│ Position Type?      │
└──────┬─────┬────────┘
       │     │
  BUY  │     │  SELL
       │     │
       ▼     ▼
┌──────────┐ ┌──────────┐
│ New SL = │ │ New SL = │
│ Bid -    │ │ Ask +    │
│ Trail    │ │ Trail    │
└────┬─────┘ └────┬─────┘
     │            │
     ▼            ▼
┌─────────────────────────┐
│ Check Conditions:       │
│ • New SL better than    │
│   current by TrailStep  │
│ • New SL better than    │
│   open price (in profit)│
└────────┬────────────────┘
         │ ALL TRUE
         ▼
┌─────────────────────────┐
│ Modify Position SL      │
└─────────────────────────┘
```

## Risk Filters Applied

```
BEFORE EVERY TRADE:
├─ [1] Time Filter
│   └─ Current hour within StartHour to EndHour
│
├─ [2] Spread Filter
│   └─ (Ask - Bid) / (10 × Point) ≤ MaxSpreadPips
│
├─ [3] Position Limit
│   └─ PositionsTotal() = 0
│
├─ [4] Indicator Validation
│   └─ All indicator buffers copied successfully
│
└─ [5] Lot Size Validation
    ├─ Within broker limits
    ├─ Within EA limits (MinLot to MaxLot)
    └─ Properly normalized to lot step
```

## Risk Management Summary

```
┌─────────────────────────────────────────────────────┐
│           RISK MINIMIZATION FEATURES                │
├─────────────────────────────────────────────────────┤
│                                                     │
│  1. POSITION SIZING                                 │
│     • Dynamic calculation based on balance & risk%  │
│     • Limits exposure per trade                    │
│                                                     │
│  2. STOP LOSS                                       │
│     • Mandatory on every trade                     │
│     • Fixed distance in pips                       │
│     • Never modified wider                         │
│                                                     │
│  3. TAKE PROFIT                                     │
│     • Defined at entry                             │
│     • Ensures positive risk/reward                 │
│                                                     │
│  4. TRAILING STOP                                   │
│     • Protects running profits                     │
│     • Moves only in favorable direction            │
│     • Optional (can be disabled)                   │
│                                                     │
│  5. SPREAD CONTROL                                  │
│     • Prevents high-cost entries                   │
│     • Configurable maximum                         │
│                                                     │
│  6. TIME FILTERING                                  │
│     • Trades only during liquid hours              │
│     • Avoids overnight risk                        │
│                                                     │
│  7. POSITION LIMITS                                 │
│     • One position maximum                         │
│     • Prevents over-exposure                       │
│     • Simplifies management                        │
│                                                     │
│  8. ERROR HANDLING                                  │
│     • Validates all parameters                     │
│     • Checks execution success                     │
│     • Logs all activities                          │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Expected Behavior

### Normal Operation
```
08:00 - EA starts monitoring
08:15 - Spread check: 0.8 pips ✓
08:15 - Fast MA crosses above Slow MA
08:15 - RSI at 32 (oversold) ✓
08:15 - BUY signal generated
08:15 - Calculate lot: 0.15 (1% risk on $1000 account)
08:15 - SL: 1.08450, TP: 1.08700
08:15 - Order executed successfully
08:30 - Price moves to 1.08550
08:30 - Trailing stop activates
08:30 - New SL: 1.08450 → 1.08500
09:15 - TP hit at 1.08700
09:15 - Position closed with profit: $25
```

### Rejected Trade Example
```
12:00 - Fast MA crosses below Slow MA
12:00 - RSI at 71 (overbought) ✓
12:00 - SELL signal generated
12:00 - Spread check: 3.5 pips ✗ (exceeds 2.0 limit)
12:00 - Trade rejected: "Spread too high: 3.5 pips"
12:00 - Wait for next opportunity
```

### Position Limit Example
```
14:00 - Existing BUY position open
14:05 - New SELL signal detected
14:05 - Position check: 1 position exists ✗
14:05 - Trade rejected: Already have open position
14:05 - Continue monitoring existing position
14:20 - Existing position hits TP
14:20 - Position count: 0
14:25 - New signal can now be processed
```
