require File.dirname(__FILE__) + '/helper'

class TestBasic < Test::Unit::TestCase

  def setup
    create_data_dir
  end

  should "create a table" do
    hail = HailDB.new
    hail.create_database("padraig")
    hail.set_data_file_path(@data_dir + "/ibdata1:10M:autoextend")
    hail.set_data_home_dir(@data_dir)
    hail.set_log_file_path(@data_dir)
    hail.startup
    t = Table.new("padraig", "t1")
    #t.add_column("c1", Haru::INT, Haru::UNSIGNED, 4)
    t.add_column("c1", Haru::VARCHAR, Haru::NONE, 32)
    t.add_index
    t.add_index_column("c1")
    tx = Transaction.new
    tx.exclusive_schema_lock
    tx.create_table(t)
    tx.commit
    tx = Transaction.new
    state = tx.state
    assert_equal Haru::ACTIVE, state
    c = tx.open_table(t)
    c.lock()
    for x in 1..1000 do
      #c.insert_row({"c1" => x})
      c.insert_row({"c1" => "blah"})
    end
    c.first_row()
    key = "c1"
    for x in 1..10 do
      r = c.read_row()
      puts "c1 : #{r[key]}"
      c.next_row()
    end
    c.close()
    tx.exclusive_schema_lock
    tx.drop_table(t)
    tx.commit
    hail.drop_database("padraig")
    hail.shutdown
  end

  def teardown
    clear_data_dir
  end

end
