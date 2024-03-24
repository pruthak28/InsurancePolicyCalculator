require_relative '../dto/validation_response_dto'
require_relative '../dto/policy_db_dto'

class InsurancePolicyImpl
  def self.validate_policies(policies)
    validation_resp_dto = ValidationResponseDTO.new
    if policies.blank?
      validation_resp_dto.result = false
      validation_resp_dto.msg = TypeValidation.get_mandatory_field_msg("policies")
      return validation_resp_dto
    end

    policies.each do |insured|
      insured_name = insured["insured_name"].strip
      validation_res = TypeValidation.is_valid?("insured_name", insured_name, PERSON_NAME, true)
      unless validation_res.blank?
        validation_resp_dto.result = false
        validation_resp_dto.msg = validation_res
        return validation_resp_dto
      end

      insured_policies = insured["insured_policies"]
      if insured_policies.blank?
        validation_resp_dto.result = false
        validation_resp_dto.msg = "#{TypeValidation.get_mandatory_field_msg("insured_policies")} for Insured: #{insured_name}"
        return validation_resp_dto
      end

      insured_policies.each do |policy|
        validation_res = TypeValidation.is_valid?("premium", policy["premium"], DECIMAL, true)
        unless validation_res.blank?
          validation_resp_dto.result = false
          validation_resp_dto.msg = "#{validation_res} for Insured: #{insured_name}"
          return validation_resp_dto
        end

        validation_res = TypeValidation.is_valid?("tax_fee", policy["tax_fee"], DECIMAL, true)
        unless validation_res.blank?
          validation_resp_dto.result = false
          validation_resp_dto.msg = "#{validation_res} for Insured: #{insured_name}"
          return validation_resp_dto
        end

        validation_res = TypeValidation.is_valid?("due_date", policy["due_date"].strip, DATE, true)
        unless validation_res.blank?
          validation_resp_dto.result = false
          validation_resp_dto.msg = "#{validation_res} for Insured: #{insured_name}"
          return validation_resp_dto
        end
      end
    end

    validation_resp_dto.result = true
    validation_resp_dto
  end

  def self.generate_finance_terms(policies)
    #insert policies data to DB
    policies, insured_hash = InsurancePolicyImpl.create_all(policies)
    if policies.blank?
      Rails.logger.error("#{self} | #{self.__method__} | Error occurred while creating insurance policies")
      return
    end

    # group policies by insured name
    policies_by_insured_id = policies.group_by(&:insureds_id)

    # call finance term calculate and create
    FinanceTermImpl.calculate_and_create(policies_by_insured_id, insured_hash)
  end

  def self.create_all(policies)
    policies_db = Array.new
    insured_hash = Hash.new
    policy_due_hash = Hash.new

    policies.each do |insured|
      policy_db_dto = PolicyDBDTO.new
      insured_name = insured["insured_name"].strip
      insured_db = InsuredImpl.create(insured_name)
      if insured_db.blank?
        Rails.logger.error("#{self} | #{self.__method__} | Error occurred while creating insured record in the DB")
        return
      end
      policy_db_dto.insured_id = insured_db.id

      insured["insured_policies"].each do |policy|
        policy_db_dto.premium = policy["premium"]
        policy_db_dto.tax_fee = policy["tax_fee"]

        policy_db = InsurancePolicy.create(policy_db_dto)
        if policy_db.blank?
          Rails.logger.error("#{self} | #{self.__method__} | Error occurred while creating insurance policy record in the DB")
          return
        end
        policies_db.push(policy_db)
        policy_due_hash[policy_db.id] = policy["due_date"]
      end

      #maintaining a hash for insured_name and poily_id=> due_date to later send it to finance term calc
      # This will help in building response DTO
      # Ex:
      # {
      # 	"<insured_id>"=> {
      # 		"insured_name"=> ""
      # 		"policy_id"=>"<corresp_policy_id_due_date>"
      # 	}
      # }
      insured_info = Hash.new
      insured_info["policy_due_hash"] = policy_due_hash
      insured_info["insured_name"] = insured_name
      insured_hash[insured_db.id] = insured_info
    end

    return policies_db, insured_hash
  end
end