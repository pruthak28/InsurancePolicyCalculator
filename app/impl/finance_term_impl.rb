require_relative '../dto/finance_term_db_dto'
require_relative '../dto/finance_term_op_dto'
require_relative '../models/finance_term'

class FinanceTermImpl

  DOWNPAYMENT_MULTIPLIER = 0.20

  def self.calculate_and_create(policies_by_insured_id, insured_hash)
    finance_terms = Array.new

    policies_by_insured_id.each do |insured_id, policies|
      insured = insured_hash[insured_id]
      if insured.blank?
        Rails.logger.error("#{self} | #{self.__method__} | Error occurred while fetching insured policy and due date details")
        return
      end
      policy_due_hash = insured["policy_due_hash"]
      if policy_due_hash.blank?
        Rails.logger.error("#{self} | #{self.__method__} | Error occurred while fetching insured policy and due date details")
        return
      end

      finance_term_dtos = FinanceTermImpl.calculate(policies, policy_due_hash)
      FinanceTermImpl.create(finance_term_dtos, finance_terms, insured)
    end

    finance_terms
  end

  def self.calculate(policies, policy_due_hash)
    finance_term_arr = Array.new

    policies.each do |policy|
      downpayment = (policy.premium * FinanceTermImpl::DOWNPAYMENT_MULTIPLIER) + policy.tax_fee #(premium * 0.20) + tax fee
      total_payable_per_policy = (policy.premium + policy.tax_fee)

      finance_term_dto = FinanceTermDBDTO.new
      finance_term_dto.policy_id = policy.id
      finance_term_dto.downpayment = downpayment
      finance_term_dto.amt_financed = (total_payable_per_policy - downpayment)
      finance_term_dto.due_date = policy_due_hash[policy.id]
      finance_term_arr.push(finance_term_dto)
    end

    finance_term_arr
  end

  def self.create(finance_term_dtos, finance_terms, insured)
    finance_term_dtos.each do |finance_term_dto|
      finance_term = FinanceTerm.create(finance_term_dto)
      if finance_term.blank?
        return
      end

      finance_terms.push(FinanceTermOPDTO.new(finance_term, insured))
    end
  end

  def self.get_by_id(finance_term_id)
    FinanceTerm.get_by_id(finance_term_id)
  end

  def self.accept_term(finance_term_id)
    FinanceTerm.update_term_accepted(finance_term_id, true)
  end

  def self.get_all(filters_dto = nil)
    finance_terms = FinanceTerm.get_all

    if filters_dto.blank?
      return finance_terms
    end

    FinanceTermImpl.filter_data(finance_terms, filters_dto)
  end

  def self.filter_data(terms, filters_dto)
    if !filters_dto.downpayment.blank? and !filters_dto.downpayment_op.blank?
      terms = terms.where("downpayment #{DOWNPAYMENT_OPS[filters_dto.downpayment_op]} ?", filters_dto.downpayment)
    end

    if !filters_dto.is_accepted.blank?
      terms = terms.where(is_accepted: filters_dto.is_accepted)
    end

    if !filters_dto.sort_by.blank? and !filters_dto.sort_order.blank?
      terms = terms.order(filters_dto.sort_by => filters_dto.sort_order)
    end

    return terms
  end
end