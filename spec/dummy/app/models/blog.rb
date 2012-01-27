class Blog < ActiveRecord::Base
  after_create  :expensive_create_method, :async => true
  after_update  :expensive_update_method, :async => true
  after_save    :expensive_save_method,   :async => true

  def self.run_expensive_method; end
  def expensive_save_method; self.class.run_expensive_method; end
  def expensive_create_method; self.class.run_expensive_method; end
  def expensive_update_method; self.class.run_expensive_method; end
end
