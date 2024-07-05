require 'spec_helper'
require 'vandelay/services/patient_records'
require 'vandelay/util/cache'

RSpec.describe Vandelay::Services::PatientRecords do
  describe '#fetch_data' do
    let(:service) { described_class.new }

    context 'when API returns data and vendor api one was used'  do
      let(:id) { 2 }
      let(:sample_auth_data) {
        {
        "id": "1",
        "token": "129e8ry23uhj23948rhu23"
        }
      }
      let(:sample_record_data_api1) {
        {
          "id": "743",
          "full_name": "Cosmo Kramer",
          "dob": "1987-03-18",
          "province": "QC",
          "allergies": [
            "work",
            "conformity",
            "paying taxes"
          ],
          "recent_medical_visits": 1
        }
      }

      before do
        # Mocking the API call
        stub_request(:get, "http://mock_api_one/auth/1")
          .to_return(status: 200, body: sample_auth_data.to_json, headers: { 'Content-Type': 'application/json' })

        stub_request(:get, "http://mock_api_one/patients/743")
          .to_return(status: 200, body: sample_record_data_api1.to_json, headers: { 'Content-Type': 'application/json' })
      end

      it 'fetches data from the API' do
        data = service.retrieve_record_for_patient(id)
        expect(data[:province]).to eq("QC")
        expect(data[:allergies]).to eq([ "work", "conformity", "paying taxes"])
        expect(data[:patient_id]).to eq("743")
      end
    end

    context 'when API returns data and vendor api two was used'  do
      let(:id) { 3 }
      let(:sample_auth_data) {
        {
        "id": "1",
        "token": "129e8ry23uhj23948rhu23"
        }
      }
      let(:sample_record_data_api1) {
        {
          "id"=>"16",
          "name"=>"George Costanza",
          "birthdate"=>"1984-09-07",
          "province_code"=>"ON",
          "clinic_id"=>"7",
          "allergies_list"=>["hair", "mean people", "paying the bill"],
          "medical_visits_recently"=>17}
      }

      before do
        # Mocking the API call
        stub_request(:get, "http://mock_api_two/auth_tokens/1")
          .to_return(status: 200, body: sample_auth_data.to_json, headers: { 'Content-Type': 'application/json' })

        stub_request(:get, "http://mock_api_two/records/16")
          .to_return(status: 200, body: sample_record_data_api1.to_json, headers: { 'Content-Type': 'application/json' })
      end

      it 'fetches data from the API' do
        data = service.retrieve_record_for_patient(id)
        expect(data[:province]).to eq("ON")
        expect(data[:allergies]).to eq(["hair", "mean people", "paying the bill"])
        expect(data[:patient_id]).to eq("16")
      end
    end

    context 'when incorrect id was queried'  do
      let(:id) { 456 }

      it 'raises a error' do
        expect {service.retrieve_record_for_patient(id)}.to raise_error("Entry with ID 456 not found")
      end
    end
  end
end
