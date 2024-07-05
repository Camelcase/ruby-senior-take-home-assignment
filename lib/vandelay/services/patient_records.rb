require_relative '../../vandelay/util/cache'
require 'vandelay/integrations/api1'
require 'vandelay/integrations/api2'

module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient_id)
        result = {}

        caching = Vandelay::Util::Cache.new
        result = caching.fetch_and_cache(patient_id) do
          patient=Vandelay::Services::Patients.new.retrieve_one(patient_id)
          api_to_use = nil
          api_to_use_id = patient.records_vendor || ""
          vendor_id = patient.vendor_id

          api_to_use = Vandelay::Integrations::Api1.new if api_to_use_id == "one"
          api_to_use = Vandelay::Integrations::Api2.new if api_to_use_id == "two"

          result = api_to_use.get_mapped_record(vendor_id) if api_to_use
        end
        result
      end
    end
  end
end