require 'minitest/autorun'
require 'mlm_tree'



class MlmTreeTest < Minitest::Test

  def setup
    @mlm_tree = MlmTree
    @mlm_tree_Node = nil
    @mlm_tree_db = nil
  end

  def teardown
     @mlm_tree.install
    if @mlm_tree::Node.count > 0
      @mlm_tree::Node.delete_all
    end
  end

  def test_config
     assert !@mlm_tree.configuration.class.nil?
  end
   
  def test_teerdown_method
    if @mlm_tree::Node.count > 0
     @mlm_tree::Node.delete_all
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

  def test_mlm_tree_Node_as_root
      @mlm_tree_db = @mlm_tree.install
      @mlm_node = @mlm_tree.add_node(1,0)

      assert !@mlm_node.class.nil?
      assert @mlm_node.self_id == 1
      assert @mlm_node.parent_id == 0
  end
  
  def test_mlm_tree_Node_root_exist
      @mlm_tree_db = @mlm_tree.install
      @mlm_tree.add_node(1,0)
      @mlm_node = @mlm_tree.add_node(1,1)
      assert !@mlm_node.class.nil?
      assert_equal @mlm_node.self_id, 1
      assert_equal @mlm_node.parent_id, 1
  end

  def test_private_method_build_test_tree
      @mlm_tree_db = @mlm_tree.install
      build_test_tree
      @tree = @mlm_tree.get_tree
      assert !@tree.first.class.nil?
      assert_equal @tree.first.parent_id, 0
  end
  
  def test_mlm_tree_Node_childern
      @mlm_tree.install
      @tree = @mlm_tree.get_tree
      assert @tree.count == 0
      build_test_tree
      @tree = @mlm_tree.get_tree
      assert @tree.count > 0
      @mlm_tree.add_node(2,21,0)
      @mlm_tree.add_node(2,22,0)
      @mlm_tree.add_node(2,25,0)
      @mlm_nodes = MlmTree::Node.where(self_id: 2)
      @mlm_first_Node =  @mlm_nodes.first
      assert @mlm_first_Node.children.count > 0	
  end  

  def test_mlm_tree_Node_active_childern
      @mlm_tree.install
      build_test_tree
      @mlm_tree.add_node(3,21,0)
      @mlm_tree.add_node(3,22,0)
      @mlm_tree.add_node(3,25,0)
      @mlm_nodes = MlmTree::Node.where(self_id: 3)
      assert !@mlm_nodes.nil?
  end

  def test_mlm_parent_Node
      @mlm_tree_db = @mlm_tree.install
      @mlm_node = @mlm_tree.add_node(2,5,0)   
      assert !@mlm_node.parent.class.nil?
  end

  def test_mlm_parents_Node
      @mlm_tree.install
      @mlm_tree.add_node(5,0)
      @mlm_tree.add_node(8,5)
      @mlm_tree.add_node(4,8)
      @mlm_tree.add_node(6,4)
      @mlm_tree.add_node(10,6)
      @mlm_node = @mlm_tree.add_node(44,10)
      assert !@mlm_node.parents.class.nil?
      assert_equal @mlm_node.parents.count, 5
  end

  def test_mlm_upline_Node
      @mlm_tree.install
      @mlm_tree.add_node(5,0)
      @mlm_tree.add_node(8,5)
      @mlm_tree.add_node(4,8)
      @mlm_tree.add_node(6,4)
      @mlm_tree.add_node(10,6)
      @mlm_node = @mlm_tree.add_node(44,10)
      assert_equal @mlm_node.upline.count, 5
  end

  def test_mlm_downline_Node
      @mlm_tree.install
      @mlm_node = @mlm_tree.add_node(5,0)
      @mlm_tree.add_node(16,5)
      @mlm_tree.add_node(23,16)
      @mlm_tree.add_node(8,5)
      @mlm_tree.add_node(4,8)
      @mlm_tree.add_node(12,8)
      @mlm_tree.add_node(14,8)
      @mlm_tree.add_node(28,8)
      @mlm_tree.add_node(6,4)
      @mlm_tree.add_node(34,4)
      @mlm_tree.add_node(10,6)
      @mlm_tree.add_node(24,6)
      @mlm_tree.add_node(54,6)
      @mlm_tree.add_node(64,6)
      @mlm_tree.add_node(74,6)
      @mlm_tree.add_node(44,10)
      assert_equal @mlm_node.downline.count, 16
  end

  def test_mlm_upline_tree
      @mlm_tree.install
      @mlm_tree.add_node(5,0)
      @mlm_tree.add_node(8,5)
      @mlm_tree.add_node(4,8)
      @mlm_tree.add_node(6,4)
      @mlm_tree.add_node(10,6)
      @mlm_tree.add_node(44,10)
      assert_equal @mlm_tree.upline(44).count, 5
  end

  def test_mlm_downline_tree
      @mlm_tree.install
      @mlm_node = @mlm_tree.add_node(5,0)
      @mlm_tree.add_node(16,5)
      @mlm_tree.add_node(23,16)
      @mlm_tree.add_node(8,5)
      @mlm_tree.add_node(4,8)
      @mlm_tree.add_node(12,8)
      @mlm_tree.add_node(14,8)
      @mlm_tree.add_node(28,8)
      @mlm_tree.add_node(6,4)
      @mlm_tree.add_node(34,4)
      @mlm_tree.add_node(10,6)
      @mlm_tree.add_node(24,6)
      assert_equal @mlm_tree.downline(5).count, 12
  end


 private
  def build_test_tree
     for i in 0..3
       for j in 1..20
         @mlm_tree.add_node(j,i)
       end
     end
  end 
 
end
