module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        result = FindDnsRecordsService.call(
          included_hostnames: params[:included],
          page: params[:page]
        )

        render json: result, status: 200
      end

      # POST /dns_records
      def create
        dns = CreateDnsService.call(
          dns_attributes: dns_params,
          hostnames_attributes: hostnames_params
        )

        return render json: { id: dns.id }, status: 201 if dns.valid?

        render json: { errors: dns.errors.full_messages }, status: 400
      end

      private

      def dns_params
        params.require(:dns_records).permit(:included, :ip)
      end

      def hostnames_params
        params
          .require(:dns_records)
          .permit(hostnames_attributes: [:hostname])['hostnames_attributes']
      end
    end
  end
end
