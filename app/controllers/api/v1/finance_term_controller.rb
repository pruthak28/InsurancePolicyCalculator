require_relative '../../../dto/finance_term_filters_dto'

module Api
  module V1
    class FinanceTermController < ApplicationController
      protect_from_forgery with: :null_session

      #api to generate finance terms based on input insurance policy data in following JSON format
      # {
      # 	"policies": [
      #         {
      #             "insured_name": "Pru Kul",
      # 			"insured_policies": [
      #                 {
      #                     "premium": 200,
      #                     "tax_fee": 50,
      #                     "due_date": "12/12/2023"
      #                 },
      #                 {
      #                     "premium": 300,
      #                     "tax_fee": 50,
      #                     "due_date": "12/12/2023"
      #                 }
      #             ]
      #         }
      #   ]
      # }
      def generate_terms
        policies = params[:policies]

        begin
          validation_res = InsurancePolicyImpl.validate_policies(policies)
          unless validation_res.result
            Rails.logger.error("#{self} | #{self.__method__} | error: #{validation_res.msg}")
            return send_error_response(nil, nil, validation_res.msg, INPUT_ERROR,:bad_request)
          end

          finance_terms = InsurancePolicyImpl.generate_finance_terms(policies)
          if finance_terms.blank?
            error_msg = "Error occurred while calculating finance terms"
            Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
            return send_error_response(nil, nil, error_msg , nil,:internal_server_error)
          end

          return send_success_response(finance_terms, :created)
        rescue Exception
          error_msg = "Something went wrong"
          Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
          return send_error_response(nil, nil, error_msg, nil,:internal_server_error)
        end
      end

      #api to update the system if user accepts the finance terms with the help of finance term id
      def agree_term
        finance_term_id = params[:finance_term_id]
        begin
          validation_res = TypeValidation.is_integer?("finance_term_id", finance_term_id.strip)
          unless validation_res.blank?
            Rails.logger.error("#{self} | #{self.__method__} | error: #{validation_res.msg}")
            return send_error_response(nil, nil, validation_res.msg, INPUT_ERROR,:bad_request)
          end

          finance_term = FinanceTermImpl.get_by_id(finance_term_id)
          if finance_term.blank?
            error_msg = "Finance term with id #{finance_term_id} not found"
            Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
            return send_error_response(nil, nil, error_msg, INPUT_ERROR,:not_found)
          end

          res = FinanceTermImpl.accept_term(finance_term)
          unless res
            error_msg = "Error occurred while accepting finance term for id: #{finance_term_id}"
            Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
            return send_error_response(nil, nil, error_msg, nil,:internal_server_error)
          end

          return send_success_response(res, :ok)
        rescue Exception
          error_msg = "Something went wrong"
          Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
          return send_error_response(nil, nil, error_msg, nil,:internal_server_error)
        end
      end

      #api to get all the generated finance terms in the system with(out) filters
      # Ex: /finance-terms?downpayment_op=gt&downpayment=0&is_accepted=False&sort_by=due_date&order=asc
      def get_terms
        begin
          filters_dto = FinanceTermFiltersDTO.new(params)

          if !filters_dto.downpayment.blank?
            if filters_dto.downpayment_op.blank? || DOWNPAYMENT_OPS.keys.exclude?(filters_dto.downpayment_op)
              error_msg = "Invalid operator #{filters_dto.downpayment_op} for downpayment amount"
              Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
              return send_error_response(nil, nil, error_msg, nil,:bad_request)
            end

            validation_res = TypeValidation.is_integer?("downpayment", filters_dto.downpayment)
            unless validation_res.blank?
              Rails.logger.error("#{self} | #{self.__method__} | error: #{validation_res.msg}")
              return send_error_response(nil, nil, validation_res.msg, nil,:bad_request)
            end
          end

          if !filters_dto.is_accepted.blank? and [TRUE, FALSE].exclude?(filters_dto.is_accepted)
            error_msg = "Invalid value #{filters_dto.is_accepted} for is_accepted"
            Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
            return send_error_response(nil, nil, error_msg, nil,:bad_request)
          end

          if !filters_dto.sort_by.blank?
            if FINANCE_TERM_SORT_BY.exclude?(filters_dto.sort_by)
              error_msg = "Sorting not supported for field: #{filters_dto.sort_by}"
              Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
              return send_error_response(nil, nil, error_msg, nil,:bad_request)
            end

            if SORT_ORDER.exclude?(filters_dto.sort_order)
              error_msg = "Sorting not supported for order: #{filters_dto.sort_order}"
              Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
              return send_error_response(nil, nil, error_msg, nil,:bad_request)
            end
          end

          finance_terms = FinanceTermImpl.get_all(filters_dto)
          return send_success_response(finance_terms, :ok)
        rescue Exception
          error_msg = "Something went wrong"
          Rails.logger.error("#{self} | #{self.__method__} | error: #{error_msg}")
          return send_error_response(nil, nil, error_msg, nil,:internal_server_error)
        end
      end

    end
  end
end