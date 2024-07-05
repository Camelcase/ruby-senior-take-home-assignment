require 'vandelay/integrations/base'

module Vandelay
  module Integrations
    class Api2 < Vandelay::Integrations::Base

      attr_reader :base_url,  :auth_id, :auth_token, :auth_path, :records_path,:record_path

      def initialize
        @auth_path =  "/auth_tokens"
        @records_path = "/records/"
        @auth_id =  "1" # in real life auth_id would come from either config or be passed down
        @record_path = "/records/"
        @token_ident = "auth_token"
        @base_url =  Vandelay.config["integrations"]["vendors"]["two"]["api_base_url"]
        @auth_token = fetch_auth_token
      end

      def get_mapped_record(id)
        data=get_record(id)
        {
          "patient_id": data["id"],
          "province": data["province_code"],
          "allergies": data["allergies_list"],
          "num_medical_visits": data["medical_visits_recently"]
        }
       end
    end
  end
end