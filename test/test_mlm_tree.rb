require 'minitest/autorun'
require 'mlm_tree'

class MlmTreeTest < Minitest::Test

  def setup
    @mlm_tree = MlmTree
    @mlm_tree_member = nil
    @mlm_tree_db = nil
  end

  def teardown
    @mlm_tree::DbTree.delete	
  end

  def test_mlm_tree_object
     assert !@mlm_tree.class.nil?
  end
  
 def test_mlm_tree_instaled
     @mlm_tree_db = @mlm_tree.install
     assert !@mlm_tree_db.class.nil?
 end

  def test_mlm_tree_member
      @mlm_tree_db = @mlm_tree.install
      @mlm_member = @mlm_tree.member(1,1)
      assert !@mlm_member.class.nil?
  end

  def test_config
     assert !@mlm_tree.configuration.class.nil?
  end 
  
  def test_mlm_tree_member_childern
      @mlm_tree_db = @mlm_tree.install
      @mlm_member = @mlm_tree.member(1,1)
      p @mlm_member.children	
  end  

end
