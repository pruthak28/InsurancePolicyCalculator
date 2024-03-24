class TypeValidation

  def self.get_mandatory_field_msg(name)
    return "#{name} is a mandatory field"
  end

  def self.get_invalid_value_msg(name, value)
    return "Invalid Value: #{name} - #{value}"
  end

  def self.is_valid?(name, value, type, is_required)
    if is_required and value.blank?
      return TypeValidation.get_mandatory_field_msg(name)
    end

    case type
    when PERSON_NAME
      TypeValidation.is_person_name?(name, value)
    when INT
      TypeValidation.is_integer?(name, value)
    when DECIMAL
      TypeValidation.is_decimal?(name, value)
    when DATE
      TypeValidation.is_date?(name, value)
    else
      Rails.logger.error("Datatype validation not supported")
    end
  end

  def self.is_decimal?(name, value)
    begin
      unless !!Kernel.Float(value)
        return TypeValidation.get_invalid_value_msg(name, value)
      end
    rescue TypeError, ArgumentError
      return TypeValidation.get_invalid_value_msg(name, value)
    end
  end

  def self.is_integer?(name, value)
    unless value.match?(/\A-?\d+\Z/)
      return TypeValidation.get_invalid_value_msg(name, value)
    end
  rescue RegexpError
    return TypeValidation.get_invalid_value_msg(name, value)
  end

  def self.is_person_name?(name, value)
    unless value.match?(/\w+\s\w+/)
      return TypeValidation.get_invalid_value_msg(name, value)
    end
  rescue RegexpError
    return TypeValidation.get_invalid_value_msg(name, value)
  end

  def self.is_date?(name, value)
      DateTime.parse(value)

      return nil
  rescue ArgumentError
    return TypeValidation.get_invalid_value_msg(name, value)
  end

end