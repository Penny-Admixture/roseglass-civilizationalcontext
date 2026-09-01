# Trippy Parametric Barcode Worksheet (Excel)

This worksheet generates **40 variable-width “barcode” strips** in **4 tranches** (10 each), with coordinated palettes and a button to regenerate a new set distributed around the color wheel.

## 1) Sheet layout

Create two sheets:

- `Control`
- `Bars`

### Control sheet inputs

| Cell | Meaning | Example |
|---|---|---|
| B2 | Master Seed | `=RANDBETWEEN(1,1000000)` |
| B3 | Bars Per Tranche | `10` |
| B4 | Tranches | `4` |
| B5 | Segments per Bar | `72` |
| B6 | Min Width | `0.5` |
| B7 | Max Width | `4.5` |
| B8 | Frequency 1 | `0.13` |
| B9 | Frequency 2 | `0.41` |
| B10 | Warp Strength | `0.7` |
| B11 | Noise Strength | `0.25` |
| B12 | Theme | `periwinkle_gold` |

### Theme table (Control!E2:I7)

Add this table:

| Theme | Hue A | Hue B | Sat | Light |
|---|---:|---:|---:|---:|
| periwinkle_gold | 235 | 45 | 0.72 | 0.58 |
| purple_orange | 275 | 28 | 0.78 | 0.52 |
| forest_lavender_silver | 130 | 285 | 0.52 | 0.46 |

> Hue degrees are 0–360.

## 2) Bars sheet structure

In `Bars`, set headers in row 1:

- A1 `BarID`
- B1 `Tranche`
- C1 `Segment`
- D1 `x`
- E1 `WidthRaw`
- F1 `WidthNorm`
- G1 `Hue`
- H1 `Sat`
- I1 `Light`
- J1 `Hex`

You will have rows for all points:

- total rows = `BarsPerTranche * Tranches * SegmentsPerBar`
- with defaults: `10 * 4 * 72 = 2880`

## 3) Core formulas (fill down)

Assume first data row is row 2.

### IDs and indexes

`A2` (BarID 1..40):

```excel
=INT((ROW()-2)/Control!$B$5)+1
```

`B2` (Tranche 1..4):

```excel
=INT((A2-1)/Control!$B$3)+1
```

`C2` (Segment 1..72 per bar):

```excel
=MOD(ROW()-2,Control!$B$5)+1
```

`D2` (normalized position x in [0,1]):

```excel
=(C2-1)/(Control!$B$5-1)
```

### Parametric variable width (trippy barcode look)

`E2`:

```excel
=LET(
seed,Control!$B$2,
f1,Control!$B$8,
f2,Control!$B$9,
warp,Control!$B$10,
noise,Control!$B$11,
bar,A2,
seg,C2,
x,D2,
base,
  0.55
  +0.30*SIN(2*PI()*(f1*seg + 0.017*bar + seed*0.000013))
  +0.20*SIN(2*PI()*(f2*seg^1.07 + 0.021*bar + seed*0.000021))
  +0.12*COS(2*PI()*(x*8 + bar*0.07)),
chaos,
  noise*SIN(2*PI()*(seg*0.618 + bar*1.73 + seed*0.0001)),
bend,
  warp*SIN(2*PI()*(x^1.35*3 + bar*0.11)),
MAX(0.02, base + chaos + bend)
)
```

`F2` (map raw width into min/max):

```excel
=LET(
mn,Control!$B$6,
mx,Control!$B$7,
r,E2,
mn + (mx-mn)*r
)
```

## 4) Color generation (cohesive by tranche + wheel distribution)

Pick theme row dynamically from `Control!B12`.

`G2` (Hue):

```excel
=LET(
th,Control!$B$12,
tbl,Control!$E$2:$I$4,
ix,XMATCH(th,INDEX(tbl,,1)),
hA,INDEX(tbl,ix,2),
hB,INDEX(tbl,ix,3),
tr,B2,
bar,A2,
seg,C2,
blend,0.5+0.5*SIN(2*PI()*(seg/Control!$B$5 + tr*0.13 + bar*0.01)),
base,(1-blend)*hA + blend*hB,
spread,(tr-1)*22,
MOD(base + spread,360)
)
```

`H2` (Sat):

```excel
=LET(
th,Control!$B$12,
tbl,Control!$E$2:$I$4,
ix,XMATCH(th,INDEX(tbl,,1)),
s0,INDEX(tbl,ix,4),
MAX(0,MIN(1,s0 + 0.08*SIN(2*PI()*(C2/17 + A2/29))))
)
```

`I2` (Light):

```excel
=LET(
th,Control!$B$12,
tbl,Control!$E$2:$I$4,
ix,XMATCH(th,INDEX(tbl,,1)),
l0,INDEX(tbl,ix,5),
MAX(0,MIN(1,l0 + 0.10*COS(2*PI()*(C2/19 + B2/7))))
)
```

`J2` (optional text key):

```excel
="H"&ROUND(G2,0)&"-S"&ROUND(100*H2,0)&"-L"&ROUND(100*I2,0)
```

## 5) Turn widths into actual “bars”

Use columns `L:CV` as visual segment columns (72 columns).

1. Set all these columns to a very small default width (e.g., 0.4).
2. For each bar (40 rows), use VBA to set each column width from `F` values for that bar’s 72 segments.
3. Fill cells with color from HSL conversion.

Because Excel formulas alone cannot directly set column widths or HSL fills, use a macro.

## 6) VBA macro (button-driven regeneration)

Press `Alt+F11` → insert module → paste:

```vb
Option Explicit

Private Function HSLToRGBHex(ByVal H As Double, ByVal S As Double, ByVal L As Double) As Long
    Dim C As Double, X As Double, m As Double
    Dim r1 As Double, g1 As Double, b1 As Double
    Dim Hp As Double
    Hp = H / 60#
    C = (1 - Abs(2 * L - 1)) * S
    X = C * (1 - Abs((Hp Mod 2) - 1))

    r1 = 0: g1 = 0: b1 = 0
    If Hp < 1 Then r1 = C: g1 = X
    If Hp >= 1 And Hp < 2 Then r1 = X: g1 = C
    If Hp >= 2 And Hp < 3 Then g1 = C: b1 = X
    If Hp >= 3 And Hp < 4 Then g1 = X: b1 = C
    If Hp >= 4 And Hp < 5 Then r1 = X: b1 = C
    If Hp >= 5 And Hp < 6 Then r1 = C: b1 = X

    m = L - C / 2
    HSLToRGBHex = RGB((r1 + m) * 255, (g1 + m) * 255, (b1 + m) * 255)
End Function

Public Sub GenerateTrippyBarcodes()
    Dim wsC As Worksheet, wsB As Worksheet
    Dim barsPerTranche As Long, tranches As Long, segs As Long
    Dim totalBars As Long, bar As Long, seg As Long
    Dim baseRow As Long, dataStart As Long, r As Long
    Dim vWidth As Double, vHue As Double, vSat As Double, vLight As Double
    Dim colStart As Long

    Set wsC = ThisWorkbook.Worksheets("Control")
    Set wsB = ThisWorkbook.Worksheets("Bars")

    barsPerTranche = wsC.Range("B3").Value
    tranches = wsC.Range("B4").Value
    segs = wsC.Range("B5").Value
    totalBars = barsPerTranche * tranches

    wsC.Range("B2").Value = WorksheetFunction.RandBetween(1, 1000000)
    Application.CalculateFull

    dataStart = 2
    baseRow = 2
    colStart = 12 ' L

    wsB.Range(wsB.Cells(baseRow, colStart), wsB.Cells(baseRow + totalBars + 3, colStart + segs + 3)).ClearFormats
    wsB.Range(wsB.Cells(baseRow, colStart), wsB.Cells(baseRow + totalBars + 3, colStart + segs + 3)).ClearContents

    For bar = 1 To totalBars
        wsB.Cells(baseRow + bar - 1, 1).Value = "BAR-" & Format(bar, "00")

        For seg = 1 To segs
            r = dataStart + (bar - 1) * segs + (seg - 1)

            vWidth = wsB.Cells(r, 6).Value  ' F width
            vHue = wsB.Cells(r, 7).Value    ' G hue
            vSat = wsB.Cells(r, 8).Value    ' H sat
            vLight = wsB.Cells(r, 9).Value  ' I light

            wsB.Columns(colStart + seg - 1).ColumnWidth = vWidth
            wsB.Cells(baseRow + bar - 1, colStart + seg - 1).Interior.Color = HSLToRGBHex(vHue, vSat, vLight)
        Next seg

        wsB.Rows(baseRow + bar - 1).RowHeight = 16
    Next bar
End Sub
```

### Add button

- Developer tab → Insert → Button.
- Assign macro: `GenerateTrippyBarcodes`.
- Label: `NEW 4x10 SET`.

Each click gives:

- new seed
- new 40-bar generation
- tranche-cohesive palette drift
- hue spread around the wheel (by tranche offsets)

## 7) Suggested color “families” (complementing tranches)

Use one theme per generation, or randomize theme in VBA.

- **Periwinkle + Gold**: `Hue A 235`, `Hue B 45`
- **Purple + Orange**: `Hue A 275`, `Hue B 28`
- **Forest + Lavender + Silver vibe**: base `130/285` with lower sat and light modulations

To push “incrutable/post-modern” feeling:

- increase `B10 Warp Strength` to `0.9`
- set `B11 Noise` between `0.20` and `0.35`
- try `B8/B9` irrational-ish pairs like `0.113` and `0.377`

## 8) Optional: randomize theme on each button hit

Inside `GenerateTrippyBarcodes`, before recalc:

```vb
Dim themes As Variant, tix As Long
themes = Array("periwinkle_gold", "purple_orange", "forest_lavender_silver")
tix = WorksheetFunction.RandBetween(0, UBound(themes))
wsC.Range("B12").Value = themes(tix)
```

---

If you want, next step I can also give you a **no-VBA version** (shape-grid with conditional formatting) or a **Google Sheets Apps Script version** of the same system.
