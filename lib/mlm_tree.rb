require "mlm_tree/version"
require 'gem_config'
require "sqlite3"


module MlmTree
 include GemConfig::Base

 with_configuration do
    has :api_key, classes: String, default: '0a84e22741bef82d43acd349163de965'
    has :db, classes:  String, default: 'mlm.sqlite3'
    has :format, values: [:json, :xml], default: :json
    has :level, classes: Integer, default: 5
    has :line, classes: Integer, default: 10
  end
   
 def self.member(self_id, parent_id = nil, active = 1)
   if @db_tree.class.nil?
   # Database for Tree not exist will be created now
    MlmTree.install
   else
   # Database for Tree exist create a new member
    Member.new self_id, parent_id , active
   end
 end

 def self.install
   @db_tree = DbTree.new
 end 

 def self.db
  @db = DbAdapter.new
  @db.database
 end

 class DbAdapter
    def initialize
      db_file = MlmTree.configuration.db

       if !File.exist?(db_file)
        test_file  = File.open(db_file,"w+")
        test_file.close
      end
     @db = SQLite3::Database.new db_file
    end
    
    def database
      @db
    end
 end

 class DbTree
    def initialize
      @db = MlmTree.db
      
      @table = @db.execute <<-SQL
           CREATE TABLE IF NOT EXISTS mlm_tree (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             parent_id INTEGER,
             self_id INTEGER,
             active Boolean DEFAULT 1
            );
         SQL
    end
    
    def self.delete
      @db = MlmTree.db
      @db.execute "delete from mlm_tree"	
    end
 
 end

 class Member

   def initialize(self_id, parent_id = nil, active = 1)
     @db = MlmTree.db
     @id = self_id
     @parent = parent_id
     @active = active
     @db.execute "insert into mlm_tree (parent_id, self_id, active ) values ( ?, ?, ? )", [parent_id, self_id, active] 
   end
   
   def upline
#     puts "#{configuration.api_key}"
#     puts @db.class 
   end

   def downline
   end

   def children
     @db.execute "select * from mlm_tree where parent_id = ?", @id
   end

   def parents
     parent = @db.execute "select * from mlm_tree where self_id = ? ", parent
   end

   def parent
     @parent
   end

   def tree_root
   end
   
   def neighbor
   end
 
 end

end
