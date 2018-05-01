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
   
 def self.member
   if @db_tree.class.nil?
#    p "DbTree not exist will becreated now"
    MlmTree.install
   else
#    p "DbTree exist"
    Member.new
   end
 end

 def self.install
   @db_tree = DbTree.new
 end 

 class DbTree
    def initialize
      db_file = "#{configuration.db}"

       if !File.exist?(db_file)
        test_file  = File.open(db_file,"w+")
        test_file.close
      end

      @db = SQLite3::Database.new db_file
      @table = @db.execute <<-SQL
            CREATE TABLE IF NOT EXISTS mlm_tree (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            parent INTEGER,
            self_id INTEGER,
            active Boolean
           );
         SQL
    end

   def configuration
     MlmTree.configuration
   end

 end

 class Member
  
   def upline
#     puts "#{configuration.api_key}"
#     puts @db.class 
   end

   def downline
   end

   def children
   end

   def parents
   end

   def parent
   end

   def tree_root
   end
   
   def neighbor
   end
 
 end

end
