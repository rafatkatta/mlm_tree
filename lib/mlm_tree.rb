require 'gem_config'
require "sqlite3"

require 'mlm_tree/version'
require 'application_record'
require 'model_connection.rb'
require 'node_class.rb'

module MlmTree
 include GemConfig::Base

  with_configuration do
    has :prod_key,  classes: String,  default: '0a84e22741bef82d43acd349163de965'
    has :db_config, classes: Hash,  default: {adapter: "sqlite3", pool: 5, timeout: 5000, database: "db/mlm.sqlite3"} 
    has :mlm_level, classes: Integer, default: 5
    has :max_child, classes: Integer, default: 10 # 2 for binary tree
  end

  Node=::Node
   
  def self.add_node(self_id, parent_id = 0, active = 1) 
    if @db_tree.class.nil?
      MlmTree.install
    end
    if parent_id != 0
      if Node.nil? || Node.count == 0 || Node.where(self_id: parent_id).first.nil?
        #create a new root node for parent as parent is root 
        Node.create!({self_id: parent_id , parent_id: 0 , active: 1})
      end
    end
    @node = Node.create!({self_id: self_id, parent_id: parent_id , active: active})
  end

 def self.install
   if self.class.const_defined?('Rails') && self.class.const_get('Rails').instance_of?(::Class)
    MlmTree.configuration.db_config = ActiveRecord::Base.connection_config
   end
   @db_tree = ModelConnection.new
 end 

 def self.db
  @db = ModelConnection.new
 end

 def self.get_tree
  Node.all 
 end

 def self.parents(self_id) 
   nodes = []
   node = Node.where(self_id: self_id).first
   
   while node.parent_id.nil?
     nodes << node
     node = Node.where(seld_id: node.parent_id).first
   end
   return nodes
 end

 def self.parent(self_id)
    node = Node.where(self_id: self_id).first
    Node.where(self_id: node.parent_id).first
 end 

 def self.children(self_id)
   Node.where(parent_id: self_id)
 end

 Node.class_eval {

  def children
    Node.where(parent_id: self_id) 
  end

  def parents
    nodes =[]
    parent_node = self.parent

    while parent_node.nil?
     nodes << parent_node
     parent_node = parent_node.parent     
    end

    return nodes
  end

  def parent
    Node.where(self_id: self.parent_id).first
  end


 }

end
