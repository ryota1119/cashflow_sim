# frozen_string_literal: true

require "cashflow_sim"

RSpec.describe CashflowSim do
  it "has a version number" do
    expect(CashflowSim::VERSION).not_to be_nil
  end
end
