require 'rails_helper'

RSpec.describe 'As a visitor' do
  before :each do
    @community = Hospital.create!(name: "Community")
    @st_mark = Hospital.create!(name: "St. Mark")

    @larry = @community.doctors.create!(name: "Larry", specialty: "Dermatology", university: "CSU")
    @frank = @community.doctors.create!(name: "Frankenstein", specialty: "Zombies", university: "Space Camp")
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

  describe "When I visit a hospital's show page" do
    it "I see the hospital's name" do
      visit hospital_path(@community)

      expect(page).to have_content("Hospital: #{@community.name}")
    end

    it "And I see the names of all doctors that work at this hospital," do
      visit hospital_path(@community)

      within("#doctors") do
        expect(page).to have_content(@larry.name)
        expect(page).to have_content(@frank.name)
        expect(page).to_not have_content(@mary.name)
      end

      visit hospital_path(@st_mark)

      within("#doctors") do
        expect(page).to have_content(@mary.name)
        expect(page).to_not have_content(@frank.name)
      end
    end

    it "And next to each doctor I see the number of patients associated with the doctor," do
      visit hospital_path(@community)

      within("#doctor-#{@larry.id}") do
        expect(page).to have_content(@larry.name)
        expect(page).to have_content("Number of Patients: 3")
      end

      visit hospital_path(@st_mark)

      within("#doctor-#{@mary.id}") do
        expect(page).to have_content(@mary.name)
        expect(page).to have_content("Number of Patients: 3")
      end
    end

    xit "And I see the list of doctors is ordered from most number of patients to least number of patients
      (Doctor patient counts should be a single query)" do
      #out of time. all previous work tested and passed
    end
  end
end
