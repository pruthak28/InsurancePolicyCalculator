require_relative '../models/insured'

class InsuredImpl

  def self.create(insured_name)
    Insured.create(insured_name)
  end
end