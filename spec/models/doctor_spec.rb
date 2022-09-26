require 'rails_helper'

RSpec.describe Doctor do
  describe 'relationships' do
    it { should belong_to :hospital }
    it { should have_many :doctor_patients }
    it { should have_many(:patients).through(:doctor_patients) }
  end

  describe 'methods' do
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

    describe 'patient_count' do
      it "returns the number of patients a doc has" do
        expect(@larry.patient_count).to eq(3)
        expect(@mary.patient_count).to eq(3)

        #add another patient to mary
        DoctorPatient.create(doctor_id: @mary.id, patient_id: @stan.id)
        
        expect(@mary.patient_count).to eq(4)
      end
    end
  end
end
