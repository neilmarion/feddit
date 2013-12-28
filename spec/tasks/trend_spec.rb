require 'spec_helper'

describe "trend:hot" do
  include_context "rake"

  it "gets all the hot trends" do
    expect {
      subject.invoke
    }.to change(Trend, count).by 1
  end
end
