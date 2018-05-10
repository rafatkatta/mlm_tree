require "mlm_tree/version"
require 'gem_config'
require "sqlite3"
require 'active_record'
require 'application_record'


module MlmTree
 include GemConfig::Base

  with_configuration do
    has :prod_key,  classes: String,  default: '0a84e22741bef82d43acd349163de965'
    has :db_config, classes: Hash,  default: {adapter: "sqlite3", pool: 5, timeout: 5000, database: "db/mlm.sqlite3"} 
    has :mlm_level, classes: Integer, default: 5
    has :max_child, classes: Integer, default: 10 # 2 for binary tree
  end
   
  def self.member(self_id, parent_id = 0, active = 1) 
   if @db_tree.class.nil?
   # Database for Tree not exist will be created now
   #p "Tree will be created"
    MlmTree.install
   else
   # Database for Tree exist create a new member
     #p "em: 1 check parent_ID = #{parent_id} is not 0 #{!parent_id == 0} or count #{Member.tree_root.count}"
     if parent_id == 0 || Member.tree_root.count == 0
       #p "#{Member.tree_root}"
       #p "em: 3 create root tree "
       Member.create_root(self_id)
     else
         #p "em: 2 create member" 
         Member.create!({self_id: self_id, parent_id: parent_id , active: active})
     end
   end
 end

 def self.install
   if self.class.const_defined?('Rails') && self.class.const_get('Rails').instance_of?(::Class)
    MlmTree.configuration.db_config = ActiveRecord::Base.connection_config
   end
   @db_tree = DbTree.new
 end 

 def self.db
  @db = ModelConnection.new
  @db.database
 end

 def self.get_tree
  Member.all 
 end
 
 class ModelConnection
    def initialize
     @connection = ActiveRecord::Base.establish_connection(MlmTree.configuration.db_config)   
     if !ActiveRecord::Base.connection.table_exists? 'members'
       if self.class.const_defined?('Rails') && self.class.const_get('Rails').instance_of?(::Class)
         Rails::Generators.invoke("model",["members","parent_id:integer","self_id:integer","active:boolean"])
	 Rails::Generators::Actions.rails_command("db:migrate")
       end
       ActiveRecord::Schema.define do
	 create_table :members, force: true do |t|
             t.integer :parent_id
             t.integer :self_id 
             t.boolean :active, default: true
             t.timestamps
         end
         add_index :members, :parent_id  	
       end
     end
    end
    
    def database
      @connection
    end
 end

 class DbTree
    def initialize
      @db = MlmTree.db
    end
    
    def self.delete
      @db = MlmTree.db
      @db.execute "delete from mlm_tree"	
    end
 
 end

 class Member < ApplicationRecord    
   
   def self.create_root(self_id)
     Member.create!({self_id: self_id, parent_id: 0, active: true})
   end

   def upline
     puts "#{configuration.api_key}"
     puts @db.class 
   end

   def downline
   end

   def children
      Member.where(parent_id: self_id)
   end

   def active_children
     Member.where(parent_id: self_id, active: true)
   end

   def parents
     up = []
     if parent.nil?
      return  up
     else
      up << parents
     end     
   end

   def parent
     unless parent_id == 0
       Member.find(parent_id)
     else
       nil
     end
   end

   def self.tree_root
     Member.where(parent_id: 0) || Member.first
   end
   
   def neighbor
     Member.where(parent_id: parent_id)
   end
 
 end


end
