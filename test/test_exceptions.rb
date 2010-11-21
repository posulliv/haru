require File.dirname(__FILE__) + '/helper'

class TestBasic < Test::Unit::TestCase

  def setup
    create_data_dir
  end

  context "HailDB" do
    setup do
      @hail = HailDB.new
      @hail.set_data_file_path(@data_dir + "/ibdata1:10M:autoextend")
      @hail.set_log_file_path(@data_dir)
      @hail.startup
    end

    should "throw an exception" do
      @hail.drop_database("padraig")
    end

    teardown do
      @hail.shutdown
    end

  end

  def teardown
    clear_data_dir
  end

end
