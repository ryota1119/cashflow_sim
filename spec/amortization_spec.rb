# frozen_string_literal: true

require "cashflow_sim"

RSpec.describe CashflowSim::Amortization do
  context "年次・固定金利（元利均等）" do
    it "最終年の残高がほぼ0になる" do
      am = described_class.new(
        principal: 1_000_000, # 100万円
        years: 5,
        rate_schedule: 1.5,   # 年利1.5%
        frequency: :yearly
      )
      last = am.schedule.last
      expect(last.balance).to be_between(0.0, 1.0).inclusive
    end
  end

  context "月次・配列で与えた変動金利" do
    it "配列外の年は最終年の金利を継続しつつ、完済できる" do
      rates = [0.7, 1.0, 1.5] # 年1〜3年目。その後は1.5%を継続
      am = described_class.new(
        principal: 2_000_000, # 200万円
        years: 3,
        rate_schedule: rates,
        frequency: :monthly
      )
      rows = am.schedule
      expect(rows.size).to be >= 36
      expect(rows.last.balance).to be_between(0.0, 1.0).inclusive
    end
  end

  context "金利0%の特別扱い" do
    it "支払額が一定で、最後に完済する" do
      am = described_class.new(
        principal: 600_000, # 60万円
        years: 3,
        rate_schedule: 0.0,
        frequency: :yearly
      )
      rows = am.schedule
      payments = rows.map(&:payment).uniq
      expect(payments.length).to eq 1
      expect(rows.last.balance).to eq 0.0
    end
  end
end
