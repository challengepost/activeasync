class Post < ActiveRecord::Base
  def self.expensive_method; end
  def expensive_method; end

  def change_title(text)
    update_attribute(:title, text)
  end
end
