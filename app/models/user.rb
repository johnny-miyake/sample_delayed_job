class User < ActiveRecord::Base
  attr_accessible :name

  def change_name_after_10_minutes
    sleep 10
    self.update_attribute :name, "user_#{Time.now.to_i}"
  end
end
