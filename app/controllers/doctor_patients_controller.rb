class DoctorPatientsController < ApplicationController
  def destroy
    doctor = Doctor.find(params[:doctor_id])
    dp = DoctorPatient.find(params[:id])
    dp.destroy
    redirect_to doctor_path(doctor)
  end
end
