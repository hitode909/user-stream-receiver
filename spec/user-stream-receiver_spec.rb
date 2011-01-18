require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "UserStreamReceiver" do
  it "exists" do
    UserStreamReceiver.new.should be_kind_of UserStreamReceiver
  end
end
