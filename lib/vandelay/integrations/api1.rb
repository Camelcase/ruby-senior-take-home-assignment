require 'vandelay/integrations/base'

module Vandelay
  module Integrations
    class Api1 < Vandelay::Integrations::Base

      attr_reader :base_url, :auth_id, :auth_token, :auth_path, :records_path,:record_path

      def initialize
        @auth_path =  "/auth"
        @auth_id =  "1" # in real life auth_id would come from either config or be passed down
        @records_path = "/patients/"
        @record_path = "/patients/"
        @token_ident = "token"
        @base_url =  Vandelay.config["integrations"]["vendors"]["one"]["api_base_url"]
        @auth_token = fetch_auth_token
      end

      def get_mapped_record(id)
        data=self.get_record(id)
        {
          "patient_id": data["id"],
          "province": data["province"],
          "allergies": data["allergies"],
          "num_medical_visits": data["recent_medical_visits"]
        }
       end
    end
  end
end