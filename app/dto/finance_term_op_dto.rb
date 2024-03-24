class FinanceTermOPDTO
  attr_accessor :id,
                :policy_id,
                :insured_name,
                :downpayment,
                :amt_financed,
                :due_date,
                :is_accepted

  def initialize(finance_term, insured)
    return if finance_term.nil?
    @id = finance_term.id
    @insured_name = insured["insured_name"]
    @policy_id = finance_term.insurance_policies_id
    @downpayment = finance_term.downpayment
    @amt_financed = finance_term.amt_financed
    @due_date = finance_term.due_date.strftime("%m/%d/%Y")
  end
end

