Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "/finance-term"                          => "finance_term#generate_terms",   :defaults => {:format=>:json}
      get  "/finance-terms"                         => "finance_term#get_terms",        :defaults => {:format=>:json}
      patch "/agree-finance-terms/:finance_term_id" => "finance_term#agree_term",      :defaults => {:format=>:json}
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
