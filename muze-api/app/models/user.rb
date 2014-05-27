class User < ActiveRecord::Base
	validates :udid, uniqueness: { case_sensitive: false }
end
