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

    should "retrieve API version" do
      assert_equal 21474836480, @hail.version
    end

    should "create a database" do
      @hail.create_database("padraig")
    end

    should "drop a database" do
      @hail.drop_database("padraig")
    end

    should "create a table" do
      @hail.create_database("padraig")
      t = Table.new("padraig", "t1")
      t.add_column("c1", PureHailDB::ColumnType[:IB_INT], PureHailDB::ColumnAttr[:IB_COL_UNSIGNED], 4)
      t.add_index
      t.add_index_column("c1")
      tx = Transaction.new
      tx.exclusive_schema_lock
      tx.create_table(t)
      tx.commit
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
