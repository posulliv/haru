require File.dirname(__FILE__) + '/helper'

class TestBasic < Test::Unit::TestCase

  def setup
    @hail = HailDB.new
    create_data_dir
  end

  should "retrieve HailDB API version" do
    assert_equal 21474836480, @hail.version
  end

  should "start/stop a HailDB instance" do
    ot = HailDB.new
    ot.enable_file_per_table
    ot.set_log_flush_frequency(HailDB::WRITE_AND_FLUSH_ONCE_PER_SECOND)
    ot.set_data_file_path(@data_dir + "/ibdata1:10M:autoextend")
    ot.set_log_file_path(@data_dir)
    ot.startup
    ot.create_database("padraig")
    ot.drop_database("padraig")
    trx = Transaction.new
    trx.commit
    ot.shutdown
    clear_data_dir
  end

end
