require 'minitest/autorun'
require 'mlm_tree'


class ModelConnectionTest < Minitest::Test

  def test_activerecord_connection
    connection = ActiveRecord::Base.establish_connection(MlmTree.configuration.db_config)
    assert !connection.nil?
  end

  def test_activerecord_connection
    connection = ActiveRecord::Base.establish_connection(MlmTree.configuration.db_config)
    assert !connection.nil?
  end

  def test_check_rails_exists
    if self.class.const_defined?('Rails') && self.class.const_get('Rails').instance_of?(::Class)
      p 'Rails based App.'
      assert true
    else
      p 'None Rails based App.'
      assert true
    end
  end

  def test_check_ActiveRecord_exists
    assert self.class.const_defined?('ActiveRecord') && self.class.const_get('ActiveRecord').instance_of?(::Module)
  end

  def test_check_ApplicationRecord_exists
   assert self.class.const_get('ApplicationRecord').instance_of?(::Class)
  end

  def test_model_connaction_class
    @model_connection = ModelConnection.new
    assert !@model_connection.class.nil?
  end

end
