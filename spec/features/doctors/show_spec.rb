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

  describe "When I visit a doctor's show page" do
    it "I see all of that doctor's information including:
     - name
     - specialty
     - university where they got their doctorate" do

      visit doctor_path(@larry)

      expect(page).to have_content("Doctor Name: #{@larry.name}")
      expect(page).to have_content("Specialty: #{@larry.specialty}")
      expect(page).to have_content("University: #{@larry.university}")

      expect(page).to_not have_content("Doctor Name: #{@mary.name}")
      expect(page).to_not have_content("Specialty: #{@mary.specialty}")
      expect(page).to_not have_content("University: #{@mary.university}")

      visit doctor_path(@mary)

      expect(page).to have_content("Doctor Name: #{@mary.name}")
      expect(page).to have_content("Specialty: #{@mary.specialty}")
      expect(page).to have_content("University: #{@mary.university}")

      expect(page).to_not have_content("Doctor Name: #{@larry.name}")
      expect(page).to_not have_content("Specialty: #{@larry.specialty}")
      expect(page).to_not have_content("University: #{@larry.university}")
    end

    it "And I see the name of the hospital where this doctor works" do
      visit doctor_path(@larry)

      expect(page).to have_content(@larry.hospital.name)
      expect(page).to_not have_content(@mary.hospital.name)

      visit doctor_path(@mary)

      expect(page).to have_content(@mary.hospital.name)
      expect(page).to_not have_content(@larry.hospital.name)
    end

    it "And I see the names of all of the patients this doctor has" do
      visit doctor_path(@larry)

      expect(page).to have_content(@stan.name)
      expect(page).to have_content(@fran.name)
      expect(page).to have_content(@billy.name)
      expect(page).not_to have_content(@mike.name)
      expect(page).not_to have_content(@lilly.name)

      visit doctor_path(@mary)

      expect(page).to have_content(@fran.name)
      expect(page).to have_content(@mike.name)
      expect(page).to have_content(@lilly.name)
      expect(page).not_to have_content(@billy.name)
      expect(page).not_to have_content(@stan.name)
    end

    it "Next to each patient's name, I see a button to remove that patient from that doctor's caseload" do
      visit doctor_path(@larry)

      expect(page).to have_link("delete #{@stan.name}")
      expect(page).to have_link("delete #{@fran.name}")
      expect(page).to have_link("delete #{@billy.name}")
      expect(page).not_to have_link("delete #{@mike.name}")
      expect(page).not_to have_link("delete #{@lilly.name}")

      visit doctor_path(@mary)

      expect(page).to have_link("delete #{@fran.name}")
      expect(page).to have_link("delete #{@mike.name}")
      expect(page).to have_link("delete #{@lilly.name}")
      expect(page).to_not have_link("delete #{@stan.name}")
      expect(page).to_not have_link("delete #{@billy.name}")
    end

    describe 'When I click that button for one patient' do
      it "I'm brought back to the Doctor's show page" do
        visit doctor_path(@larry)

        click_link("delete #{@stan.name}")

        expect(page.current_path).to eq(doctor_path(@larry))

        visit doctor_path(@mary)

        click_link("delete #{@mike.name}")

        expect(page.current_path).to eq(doctor_path(@mary))

      end
      it "And I no longer see that patient's name listed" do
        visit doctor_path(@larry)

        click_link("delete #{@stan.name}")

        expect(page.current_path).to eq(doctor_path(@larry))
        expect(page).not_to have_content(@stan.name)
        expect(page).to_not have_link("delete #{@stan.name}")


        visit doctor_path(@mary)

        click_link("delete #{@mike.name}")

        expect(page.current_path).to eq(doctor_path(@mary))
        expect(page).not_to have_content(@mike.name)
        expect(page).to_not have_link("delete #{@mike.name}")
      end
    end
  end
end
