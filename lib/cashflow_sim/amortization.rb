# frozen_string_literal: true

module CashflowSim
  # 返済スケジュールを生成するクラス
  # - principal:     元本
  # - years:         返済年数
  # - rate_schedule: 年ごとの「年利（%）」を返す Proc / 配列 / 数値
  # - frequency:     :monthly or :yearly
  class Amortization
    Period = Struct.new(:year, :month, :rate, :payment, :interest, :principal_paid, :balance, keyword_init: true)

    def initialize(principal:, years:, rate_schedule:, frequency: :monthly)
      @principal = principal.to_f
      @years     = years.to_i
      @rate_fn   = to_rate_fn(rate_schedule)
      @freq      = frequency
    end

    def schedule
      periods = []
      balance = @principal
      total   = (@freq == :monthly ? (@years * 12) : @years)

      (1..total).each do |i|
        y = year_of(i)
        m = month_of(i)
        annual_percent = @rate_fn.call(y)
        r = period_rate(annual_percent)

        # 残期間（いまの期も含める）
        n_left = total - i + 1
        # 残期間が0にならないようガード
        n_left = 1 if n_left < 1

        pmt = annuity_payment(balance, r, n_left)

        interest       = balance * r
        principal_paid = [pmt - interest, balance].min
        balance        = (balance - principal_paid).clamp(0.0, Float::INFINITY)

        periods << Period.new(
          year: y,
          month: m,
          rate: r.round(8),
          payment: pmt.round(2),
          interest: interest.round(2),
          principal_paid: principal_paid.round(2),
          balance: balance.round(2)
        )

        break if balance <= 0.0
      end

      periods
    end

    private

    def to_rate_fn(obj)
      case obj
      when Proc
        obj
      when Array
        # yが配列長を超えたら最終年の利率を継続
        ->(y) { obj[[y - 1, obj.length - 1].min] }
      when Numeric
        ->(_y) { obj }
      else
        raise ArgumentError, "rate_schedule must be Proc, Array, or Numeric"
      end
    end

    def year_of(i)
      @freq == :monthly ? ((i - 1) / 12 + 1) : i
    end

    def month_of(i)
      @freq == :monthly ? (((i - 1) % 12) + 1) : 1
    end

    def period_rate(annual_percent)
      annual = annual_percent.to_f / 100.0
      @freq == :monthly ? (annual / 12.0) : annual
    end

    # 元利均等の期間支払額（r==0 にも対応）
    def annuity_payment(balance, r, n)
      return balance / n if r.zero?

      balance * r / (1 - (1 + r)**(-n))
    end
  end
end
