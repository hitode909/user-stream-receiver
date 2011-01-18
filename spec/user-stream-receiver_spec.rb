require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "UserStreamReceiver" do
  it "exists" do
    UserStreamReceiver.new.should be_kind_of UserStreamReceiver
  end

  it "has pit_file" do
    UserStreamReceiver.new.pit_file.should == 'user-stream-receiver'
    UserStreamReceiver.new('pit-file-path').pit_file.should == 'pit-file-path'
  end

end
