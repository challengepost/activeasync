class Blog < ActiveRecord::Base
  after_create  :expensive_create_method, :async => true
  after_update  :expensive_update_method, :async => true
  after_save    :expensive_save_method,   :async => true

  after_save { cheap_save_from_block }
  after_save ->{ cheap_save_from_lambda }
  after_save :cheap_save_from_method_name

  # "normal" synchronous callbacks

  def self.run_expensive_method; end
  def expensive_save_method; self.class.run_expensive_method; end
  def expensive_create_method; self.class.run_expensive_method; end
  def expensive_update_method; self.class.run_expensive_method; end

  def cheap_save_from_block; end
  def cheap_save_from_lambda; end
  def cheap_save_from_method_name; end
end
