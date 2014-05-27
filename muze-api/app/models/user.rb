class User < ActiveRecord::Base
	validates :uuid, uniqueness: { case_sensitive: false }
end
