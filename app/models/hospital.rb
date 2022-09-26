class Hospital < ApplicationRecord
  has_many :doctors
  # has_many :patients, through: :doctor
end
