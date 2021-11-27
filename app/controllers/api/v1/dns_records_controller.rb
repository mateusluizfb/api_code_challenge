module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        # TODO: Implement this action
      end

      # POST /dns_records
      def create
        dns = CreateDnsService.call(
          dns_attributes: dns_params,
          hostnames_attributes: hostnames_params
        )

        byebug
        return render json: { id: dns.id }, status: 201 if dns.valid?

        render json: { errors: dns.errors }, status: 400
      end

      private

      def dns_params
        params.require(:dns_records).permit(:ip)
      end

      def hostnames_params
        params
          .require(:dns_records)
          .permit(hostnames_attributes: [:hostname])['hostnames_attributes']
      end
    end
  end
end
