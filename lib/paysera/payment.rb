class Paysera::Payment
  def build_request(paysera_params)
    # Ensure that all key will be symbols
    attributes                 = Hash[paysera_params.map { |k, v| [k.to_sym, v] }]

    # Set default attributes
    attributes[:version]       = Paysera::API_VERSION
    attributes[:project_id]    = 'TODO'
    attributes[:sign_password] = 'TODO'

    # Validate attributes
    validate_data(attributes)
  end

  private

  def validate_data(attributes)
    Paysera::Attributes::REQUEST.each do |k, v|
      raise("'%s' is required but missing.", k) if v[:required] and attributes[k].nil?

      unless attributes[k].nil?
        raise("'%s' value '%s' is too long, %d characters allowed.", k, attributes[k], v[:length]) if v[:length] and attributes[k] > v[:length]
        raise("'%s' value '%s' invalid.", k, attributes[k]) if '' != v[:regex] and attributes[k] =~ v[:regex]
      end
    end
  end
end