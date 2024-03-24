class FinanceTerm < ActiveRecord::Base
  self.table_name = "finance_terms"
  belongs_to :insurance_policy, optional: true

  def self.create(finance_term_dto)
    finance_term = nil
    begin
      finance_term = FinanceTerm.find_or_initialize_by(insurance_policies_id: finance_term_dto.policy_id)
      finance_term.downpayment = finance_term_dto.downpayment
      finance_term.amt_financed = finance_term_dto.amt_financed
      finance_term.due_date = finance_term_dto.due_date
      finance_term.is_accepted = false
      finance_term.save!
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.error("")#TODO:Prutha
      return finance_term
    rescue ActiveRecord::RecordNotSaved
      Rails.logger.error("")#TODO:Prutha
      return finance_term
    end

    finance_term
  end

  def self.get_by_id(finance_term_id)
    finance_term = nil
    begin
      finance_term = FinanceTerm.find(finance_term_id)
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("")#TODO:Prutha
      return finance_term
    end

    finance_term
  end

  def self.update_term_accepted(finance_term, is_accepted)
    begin
      finance_term.is_accepted = is_accepted
      finance_term.save!
    rescue ActiveRecord::RecordNotSaved
      Rails.logger.error("")#TODO:Prutha
      return false
    end
  end

  def self.get_all
    FinanceTerm.all
  end
end