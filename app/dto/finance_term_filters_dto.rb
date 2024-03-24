class FinanceTermFiltersDTO
  attr_accessor :downpayment,
                :downpayment_op,
                :is_accepted,
                :sort_by,
                :sort_order

  def initialize(params)
    @downpayment = nil
    @downpayment_op = nil
    @is_accepted = nil
    @sort_by = nil
    @sort_order = nil

    if !params[:downpayment].blank?
      @downpayment = params[:downpayment].strip
    end

    if !params[:downpayment_op].blank?
      @downpayment_op = params[:downpayment_op].strip
    end

    if !params[:is_accepted].blank?
      @is_accepted = params[:is_accepted].strip.downcase
    end

    if !params[:sort_by].blank?
      @sort_by = params[:sort_by].strip.downcase
    end

    if !params[:order].blank?
      @sort_order = params[:order].strip.downcase
    end
  end
end