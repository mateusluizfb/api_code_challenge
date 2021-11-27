module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        dns_records = DomainNameSystem.page(params[:page])
        hostnames_count = dns_records.flat_map(&:hostnames).map(&:name).tally

        render json: {
          total_records: dns_records.size,
          records: dns_records.map { |dns| { id: dns.id, ip_address: dns.ip } },
          related_hostnames: hostnames_count.map { |name, count| { hostname: name, count: count } }
        }
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
