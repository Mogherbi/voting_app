class Event < ActiveRecord::Base

	extend FriendlyId
	friendly_id :passphrase

	validates :name, :date, :start_time, :end_time, presence: true
	validates :passphrase, uniqueness: true

	before_validation(on: :create) do
		self.passphrase = SecureRandom.hex(3)
	end

	belongs_to :user

end
