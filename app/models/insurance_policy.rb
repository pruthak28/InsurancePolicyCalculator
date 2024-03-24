class InsurancePolicy < ActiveRecord::Base
  self.table_name = "insurance_policies"
  belongs_to :insured, optional: true
  has_one :finance_term

  def self.create(policy_db_dto)
    insurance_policy = nil
    begin
      insurance_policy = InsurancePolicy.find_or_initialize_by(insureds_id: policy_db_dto.insured_id,
                                                            premium: policy_db_dto.premium,
                                                            tax_fee: policy_db_dto.tax_fee)
      insurance_policy.save!
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.error("")#TODO:Prutha
      return insurance_policy
    rescue ActiveRecord::RecordNotSaved
      Rails.logger.error("")#TODO:Prutha
      return insurance_policy
    end

    insurance_policy
  end
end