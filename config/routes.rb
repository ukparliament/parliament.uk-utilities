Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/search', to: 'search#index'
  get '/', to: 'home#index'
  get 'mps', to: 'home#mps'

  # Links to external routes

  get '/houses/:house_id/members/current/a-z/:letter', to: redirect('http://localhost:3030/houses/:house_id/members/current/a-z/:letter'), as: 'house_members_current_a_z_letter'

  get '/constituencies/current/a-z/:letter', to: redirect('http://localhost:3030/constituencies/current/a-z/:letter'), as: 'constituencies_current_a_z_letter'

  get '/houses/:house_id/parties/current', to: redirect('http://localhost:3030/houses/:house_id/parties/current'), as: 'house_parties_current'
end
