require 'rails_helper'

RSpec.describe 'As a visitor' do
  before :each do
    @community = Hospital.create!(name: "Community")
    @st_mark = Hospital.create!(name: "St. Mark")

    @larry = @community.doctors.create!(name: "Larry", specialty: "Dermatology", university: "CSU")
    @mary = @st_mark.doctors.create!(name: "Mary", specialty: "Surgery", university: "Cornell")

    @stan = Patient.create(name: "Stan", age: "33") #doc 1 only

    @fran = Patient.create(name: "Fran", age: "42") #both docs

    @mike = Patient.create(name: "Mike", age: "25") #doc 2 only

    @billy = Patient.create(name: "Billy", age: "15") #doc 1 child patient
    @lilly = Patient.create(name: "Lilly", age: "14") #doc 2 child patient

    DoctorPatient.create(doctor_id: @larry.id, patient_id: @stan.id)
    DoctorPatient.create(doctor_id: @larry.id, patient_id: @fran.id)
    DoctorPatient.create(doctor_id: @larry.id, patient_id: @billy.id)
    DoctorPatient.create(doctor_id: @mary.id, patient_id: @fran.id)
    DoctorPatient.create(doctor_id: @mary.id, patient_id: @mike.id)
    DoctorPatient.create(doctor_id: @mary.id, patient_id: @lilly.id)
  end

  describe "When I visit the patient index page" do
    it "I see the names of all adult patients (age is greater than 18)" do
      visit patients_path

      expect(page).to have_content(@mike.name)
      expect(page).to have_content(@fran.name)
      expect(page).to have_content(@stan.name)
      expect(page).to_not have_content(@lilly.name) #child patient
      expect(page).to_not have_content(@billy.name) #child patient
    end

    it "And I see the names are in ascending alphabetical order" do
      visit patients_path

      expect(@fran.name).to appear_before(@mike.name)
      expect(@mike.name).to appear_before(@stan.name)
    end
  end
end
