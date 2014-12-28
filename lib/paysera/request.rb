class Paysera::Request
  def self.build_request(paysera_params)
    # Ensure that all key will be symbols
    attributes                 = Hash[paysera_params.map { |k, v| [k.to_sym, v] }]

    # Set default attributes
    attributes[:version]       = Paysera::API_VERSION
    attributes[:project_id]    ||= 'TODO'
    attributes[:sign_password] ||= 'TODO'

    # Validate attributes
    validate_data(attributes)
  end

  private

  def self.validate_data(attributes)
    Paysera::Attributes::REQUEST.each do |k, v|
      raise e("'#{k}' is required but missing") if v[:required] and attributes[k].nil?

      unless attributes[k].nil?
        # raise "#{attributes[k]} lasd"
        raise e("'#{k}' value '#{attributes[k]}' is too long, #{v[:maxlen]} characters allowed.") if v[:maxlen] and attributes[k].length > v[:maxlen]
        # raise e("'#{k}' value '#{attributes[k]}' invalid.") if '' != v[:regex] and attributes[k].to_s.match(v[:regex])
        raise e("'#{k}' value '#{attributes[k]}' invalid.") unless v[:regex].nil? and attributes[k].to_s.match(v[:regex])
      end
    end
  end

  def self.e(msg)
    Exception.new msg
  end
end