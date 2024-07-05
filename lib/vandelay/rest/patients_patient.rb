require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.registered(app)
        app.get '/patients/patient/:patient_id' do
          begin
            json(Vandelay::Services::Patients.new.retrieve_one(params[:patient_id]))
          rescue
            halt 404, json({ error: 'Record not found' })
          end
        end

        app.get '/patients/:patient_id/record' do
          begin
            result = {}
            results=Vandelay::Services::PatientRecords.new.retrieve_record_for_patient(params[:patient_id])
            JSON(results)
          rescue
            halt 404, json({ error: 'Record not found' })
          end
        end
      end
    end
  end
end
