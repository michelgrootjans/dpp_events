Rails.application.routes.draw do
  resources :articles
  put 'articles/:id/finish', to: 'articles#finish', as: :finish_article
  put 'articles/:id/recall', to: 'articles#recall', as: :recall_article
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
