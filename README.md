## Installation

Add this line to your application's Gemfile:

```ruby
gem "cashflow_sim"
```

And then execute:

```bash
bundle install
```

Or install it yourself:

```bash
gem install cashflow_sim
```

## CLI

```bash
# 固定金利（年次）
cashflow_sim --principal 1000000 --years 5 --rate 1.5 --yearly

# 線形に変動（1年目0.7%→30年目2.0%へ、以降据え置き）
cashflow_sim --principal 45000000 --years 40 --start-rate 0.7 --end-rate 2.0 --end-year 30 --format csv > schedule.csv

# ヘルプ
cashflow_sim --help
```

## Library (Ruby)

```ruby
require "cashflow_sim"

am = CashflowSim::Amortization.new(
  principal: 1_000_000,
  years: 5,
  rate_schedule: 1.5,
  frequency: :yearly
)
rows = am.schedule
```
