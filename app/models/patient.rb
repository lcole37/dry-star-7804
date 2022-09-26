class Patient < ApplicationRecord
  has_many :doctor_patients
  has_many :doctors, through: :doctor_patients

  def self.alpha_adult_patients
    Patient.where('age >= ?', 18).order(:name)
  end
end
