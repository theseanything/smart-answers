Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "smart_answers#index"

  get "healthcheck", to: proc { [200, {}, [""]] }

  mount GovukPublishingComponents::Engine, at: "/component-guide"

  constraints id: /[a-z0-9-]+/i, started: /y/ do
    get "/:id/y/visualise(.:format)", to: "smart_answers#visualise", as: :visualise

    get "/:id(/:started(/*responses))",
        to: "smart_answers#show",
        as: :smart_answer,
        format: false
  end

  get "/:id/:node_name", to: "smart_answers#session_show", as: :session_flow
end
