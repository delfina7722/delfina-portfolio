# FIN 494 Class 05 Submission Report

## 1. Return calculation and correction

For BND on August 27, 2026, the previous supplied adjusted close was 49.75 and the current adjusted close was 50.25. My independent calculation is:

\[
\text{price ratio}=\frac{50.25}{49.75}=1.0100502513
\]

\[
\text{simple return}=\frac{50.25}{49.75}-1=0.0100502513
\]

Therefore, the decimal simple return is approximately **0.01005**, or **1.005%**. This agrees with the return produced by the repaired calculation.

The original code calculated only `adjusted_close / previous_close`, which produces a gross return ratio rather than a simple return. For example, ALP's move from 100 to 102 produced 1.02 instead of 0.02. I corrected the expression in `analysis/returns_analysis.R` to:

```r
prices$daily_return <- prices$adjusted_close / prices$previous_close - 1
```

The first observation for each ticker remains `NA` because no earlier supplied price exists for that ticker. This is different from a zero return, which represents an observed period with no price change.

## 2. Verification and version-control evidence

I ran the supplied check script after the correction. The result was **12 passed and 0 failed**. The checks confirmed that all 15 rows were preserved, ticker/date keys remained unique, each ticker began with an `NA` return, the three specified one-day returns were correct, company labels joined correctly, input order did not affect the result, ALP's compounded period return was 6%, and invalid duplicate or unmatched keys were rejected.

The local Git history contains the baseline commit `485cc44` (`Record supplied R returns starter`) and the repair commit `c7ac6da` (`Fix daily return calculation`). The repair commit changes one line in one file, adding the required subtraction of one. At the time this report was prepared, the working tree was clean before adding this report.

## 3. Research population and variables

The assigned population is all monthly CIZ records on **December 31, 2025** for active, regular-way, U.S.-incorporated ordinary corporate common equity securities whose primary listing is on the NYSE, NYSE American, or Nasdaq, before applying the classroom capitalization screen.

The unit of observation is one security-month. The observation key is `(permno, mthcaldt)`, where `permno` identifies the security and `mthcaldt` is the month-end observation date. A security identifier is not the same as a company identifier because one company may have multiple securities. The source capitalization field is `mthcap`, documented here in USD thousands, and the normalized field is `market_cap_m = mthcap / 1000`, measured in USD millions.

The population filters are:

- `sharetype = 'NS'`
- `securitytype = 'EQTY'`
- `securitysubtype = 'COM'`
- `usincflg = 'Y'`
- `issuertype IN ('ACOR', 'CORP')`
- `primaryexch IN ('N', 'A', 'Q')`
- `conditionaltype = 'RW'`
- `tradingstatusflg = 'A'`

The query is restricted to one month-end and contains no arbitrary row limit, ticker list, join, historical panel, or capitalization filter. Thus, the initial universe is defined before the separate classroom size screen.

## 4. Retrieval route and validation

I used the **synthetic fallback route**, not a live WRDS retrieval. Live execution remained disabled because the configuration has `documentation_confirmed = FALSE`, and individual WRDS entitlement and instructor preflight were not established. Consequently, the following results are invented teaching data and must not be interpreted as empirical findings about the market or WRDS coverage.

The synthetic retrieval produced 8 rows representing 8 unique securities. The independent expected and fetched row counts both equaled 8. Validation passed for the requested date, valid security identifiers, unique `(permno, mthcaldt)` keys, population eligibility, nonnegative capitalization, and the conversion from USD thousands to USD millions. One security had missing capitalization and one had an observed capitalization of zero. The missing value remained missing rather than being replaced with zero.

## 5. Capitalization screen and interpretation

Before screening, I expected the security count to decrease because securities below $1 billion and securities with missing capitalization cannot pass the rule. I also expected the median observed capitalization to increase because the rule removes the lower end of this synthetic capitalization distribution, although that direction is not guaranteed for every possible dataset.

The classroom rule retained securities with **security capitalization greater than or equal to USD 1,000 million**. Results were:

| Population | Security count | Observed-cap denominator | Median capitalization (USD millions) |
|---|---:|---:|---:|
| Before screen | 8 | 7 | 999 |
| After screen | 3 | 3 | 1,500 |

The screen removed 5 of 8 securities and reduced the observed-cap denominator from 7 to 3. The median difference, defined as after-screen minus before-screen, was:

\[
1{,}500-999=501\text{ USD million}
\]

Missing capitalization remained visible in the initial population but could not demonstrate that the security passed the rule. The observed zero was included in the initial median calculation and failed the positive threshold. The change in the median reflects a change in which securities are described; it is not a return, an investment-performance result, proof of investability, or evidence that the screen is optimal.

## 6. Limitations and AI assistance

The price and company CSV files are classroom fixtures with incomplete provenance, so I do not infer a vendor methodology, currency, dividend treatment, or historical availability from their labels. Likewise, the synthetic WRDS-style universe cannot establish live access, completeness, survivorship-free performance, or any real-market conclusion. A current cross-section is not a historical backtest.

AI assistance was used to help develop and organize the work and to draft this report from the repository evidence. The financial correction was independently checked using the price-ratio formula, the supplied automated tests were executed, the Git diff and commit history were inspected, and the synthetic retrieval and screen were rerun. No credentials or licensed WRDS observations were provided to the AI or included in the repository.
