require_relative '../../../rails_helper'
require_relative '../../../spec_helper'

RSpec.describe Api::V1::FinanceTermController, type: :controller do
  include RSpec::Rails::ControllerExampleGroup
  describe 'GET /finance-terms' do

    context 'with invalid attributes' do
      it 'returns error JSON & 400 status code for finance terms because of i/p error' do
        get :get_terms, params: {"downpayment_op": nil, "downpayment": "100"}
        puts response
        expect(response).to have_http_status(400)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with valid attributes' do

      it 'returns a 200 status code' do
        get :get_terms, params: {"downpayment_op": "gt", "downpayment": "100"}
        puts response
        expect(response).to have_http_status(200)
      end
    end
  end
end

