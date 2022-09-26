require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe 'relationships' do
    it { should have_many :doctor_patients }
    it { should have_many(:doctors).through(:doctor_patients) }
  end

  describe 'methods' do
    before :each do
      @lilly = Patient.create(name: "Lilly", age: "14")  #child
      @stan = Patient.create(name: "Stan", age: "33")
      @fran = Patient.create(name: "Fran", age: "42")
      @billy = Patient.create(name: "Billy", age: "15") #child
      @mike = Patient.create(name: "Mike", age: "25")
    end
    
    describe 'sorted_adult_patients' do
      it "sorts adult (18+) patients by name" do
        patients = Patient.all

        expect(patients.sorted_adult_patients).to eq([@fran, @mike, @stan])
        expect(patients.sorted_adult_patients).not_to eq([@lilly, @stan, @fran, @billy, @mike]) #all
        expect(patients.sorted_adult_patients).not_to eq([@stan, @fran, @mike]) #all adults unsorted
      end
    end
  end
end
