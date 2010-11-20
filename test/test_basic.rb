require File.dirname(__FILE__) + '/helper'

class TestBasic < Test::Unit::TestCase

  def setup
    @hail = HailDB.new
  end

  should "retrieve HailDB API version" do
    assert_equal 21474836480, @hail.version
  end

  should "start/stop a HailDB instance" do
    ot = HailDB.new
    ot.startup
    ot.create_database("padraig")
    ot.drop_database("padraig")
    trx = Transaction.new
    trx.commit
    ot.shutdown
  end

end
