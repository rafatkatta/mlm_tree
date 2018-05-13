require 'active_record'

 class ModelConnection
    def initialize
     @connection = ActiveRecord::Base.establish_connection(MlmTree.configuration.db_config)
     if !ActiveRecord::Base.connection.table_exists? 'Nodes'
       if self.class.const_defined?('Rails') && self.class.const_get('Rails').instance_of?(::Class)
         Rails::Generators.invoke("model",["Nodes","parent_id:integer","self_id:integer","active:boolean"])
         Rails::Generators::Actions.rails_command("db:migrate")
       end
       ActiveRecord::Schema.define do
         create_table :Nodes, force: true do |t|
             t.integer :parent_id
             t.integer :self_id
             t.boolean :active, default: true
             t.timestamps
         end
         add_index :Nodes, :parent_id
       end
     end
    end

 end

