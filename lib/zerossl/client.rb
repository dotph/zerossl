module ZeroSSL
  class Client
    def initialize
      @config = ZeroSSL::Setup.config
      @http   = HTTP.new
    end

    def certificates
      @http.get('certificates')
    end

    def create(opts = {})
      attributes = %w[
        certificate_domains
        certificate_validity_days
        certificate_csr
      ]

      options = opts.transform_keys(&:to_s).slice(*attributes)
      domains = options['certificate_domains']

      if domains.is_a?(Array)
        options['certificate_domains'] = domains.join(',')
      end
      @http.post('certificates', options)
    end

    def verify(id, validation_method)
      opts = { validation_method: validation_method }
      @http.post("certificates/#{id}/challenges", opts)
    end

    def status(id)
      !!@http.get("certificates/#{id}/status")&.body['validation_completed']
    end

    def download(id)
      @http.get("certificates/#{id}/download/return")&.body
    end

    def cancel(id)
      @http.post("certificates/#{id}/cancel")&.body
    end

    def revoke(id)
      @http.post("certificates/#{id}/revoke")&.body
    end

    def certificate(id)
      @http.get("certificates/#{id}")
    end

  end
end