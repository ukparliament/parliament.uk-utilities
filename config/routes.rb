Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/search', to: 'search#index'
  get '/', to: 'home#index'
  get 'mps', to: 'home#mps'
  get '/meta', to: 'meta#index'
  get '/meta/cookie-policy', to: 'meta#cookie_policy'
  get '/postcodes', to: 'postcodes#index'
  post '/postcodes/lookup', to: 'postcodes#lookup'
  get '/postcodes/:postcode', to: 'postcodes#show', as: 'postcode'
  get '/resource', to: 'resource#index'
  get '/resource/:resource_id', to: 'resource#show', resource_id: /\w{8}/

  # Links to external routes

  get '/houses/:house_id/members/current/a-z/:letter', to: redirect('http://localhost:3030/houses/:house_id/members/current/a-z/:letter'), as: 'house_members_current_a_z_letter'

  get '/houses/:house_id/parties/current', to: redirect('http://localhost:3030/houses/:house_id/parties/current'), as: 'house_parties_current'

  get '/houses/:house_id/parties/:party_id/members/current/a-z/:letter', to: redirect('http://localhost:3030/houses/:house_id/parties/:party_id/members/current/a-z/:letter'), as: 'house_parties_party_members_current_a_z_letter'

  get '/constituencies/current/a-z/:letter', to: redirect('http://localhost:3030/constituencies/current/a-z/:letter'), as: 'constituencies_current_a_z_letter'

  get '/constituencies/:constituency_id', to: redirect('http://localhost:3030/constituencies/:constituency_id'), as: 'constituency'

  get '/constituencies/current', to: redirect('http://localhost:3030/constituencies/current'), as: 'constituencies_current'

  get '/people/:person_id', to: redirect('http://localhost:3030/people/:person_id'), as: 'person'

  get '/parliaments/:parliament_id/members/a-z/:letter', to: redirect('http://localhost:3030/parliaments/:parliament_id/members/a-z/:letter'), as: 'parliament_members_a_z_letter'

  get '/parliaments', to: redirect('http://localhost:3030/parliaments'), as: 'parliaments'


end
