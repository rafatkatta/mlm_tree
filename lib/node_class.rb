require 'application_record'

unless (self.class.const_defined?('Rails') && self.class.const_get('Rails').instance_of?(::Class))

 class Node < ApplicationRecord

 end

end
