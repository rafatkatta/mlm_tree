require 'minitest/autorun'
require 'mlm_tree'



class MlmTreeTest < Minitest::Test

  def setup
    @mlm_tree = MlmTree
    @mlm_tree_member = nil
    @mlm_tree_db = nil
  end

  def teardown
     @mlm_tree.install
    if @mlm_tree::Member.count > 0
      @mlm_tree::Member.delete_all
    end
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
 
  def test_teerdown_method
    if @mlm_tree::Member.count > 0
     @mlm_tree::Member.delete_all
    end
    assert @mlm_tree.get_tree.length == 0
  end
 
  def test_mlm_tree_object
     assert !@mlm_tree.class.nil?
  end
  
  def test_mlm_tree_instaled
     @mlm_tree_db = @mlm_tree.install
     assert !@mlm_tree_db.class.nil?
  end

  def test_mlm_tree_member_as_root
      @mlm_tree_db = @mlm_tree.install
      @mlm_member = @mlm_tree.member(1,0)

      assert !@mlm_member.class.nil?
      assert @mlm_member.self_id == 1
      assert @mlm_member.parent_id == 0
  end
  
  def test_mlm_tree_member_root_exist
      @mlm_tree_db = @mlm_tree.install
      @mlm_tree.member(1,0)
      @mlm_member = @mlm_tree.member(1,1)
      assert !@mlm_member.class.nil?
      assert @mlm_member.self_id == 1
      assert @mlm_member.parent_id == 1
  end

  def test_config
     assert !@mlm_tree.configuration.class.nil?
  end 

  def test_private_method_build_test_tree
      @mlm_tree_db = @mlm_tree.install
      build_test_tree
      @tree = @mlm_tree.get_tree
      assert !@tree.first.class.nil?
      assert @tree.first.parent_id == 0
  end
  
  def test_mlm_tree_member_childern
      @mlm_tree.install
      @tree = @mlm_tree.get_tree
      assert @tree.count == 0
      build_test_tree
      @tree = @mlm_tree.get_tree
      assert @tree.count > 0
      @mlm_tree.member(2,21,0)
      @mlm_tree.member(2,22,0)
      @mlm_tree.member(2,25,0)
      @mlm_members = MlmTree::Member.where(self_id: 2)
      @mlm_first_member =  @mlm_members.first
      assert @mlm_first_member.children.count > 0	
  end  

  def test_mlm_tree_member_active_childern
      @mlm_tree.install
      build_test_tree
      @mlm_tree.member(3,21,0)
      @mlm_tree.member(3,22,0)
      @mlm_tree.member(3,25,0)
      @mlm_members = MlmTree::Member.where(self_id: 3)
      assert !@mlm_members.nil?
  end

  def test_mlm_parent_member
      @mlm_tree_db = @mlm_tree.install
      @mlm_member = @mlm_tree.member(2,5,0)   
      assert !@mlm_member.parent.class.nil?
  end

  def test_mlm_parents_member
      @mlm_tree_db = @mlm_tree.install
      @mlm_member = @mlm_tree.member(2,5,0)
      assert !@mlm_member.parents.class.nil?
  end
  
 private
  def build_test_tree
     for i in 0..20
       @mlm_tree.member(i+1,i)
       @mlm_tree.member(i+1,1)
       @mlm_tree.member(i+1,2)
       @mlm_tree.member(i+1,3)
     end
  end  
end
