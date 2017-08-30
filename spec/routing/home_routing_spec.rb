require 'rails_helper'

RSpec.describe 'home', type: :routing do
  describe 'HomeController' do
    it 'GET home#index' do
      expect(get: '/').to route_to(
        controller: 'home',
        action:     'index'
      )
    end

    it 'GET home#mps' do
      expect(get: '/mps').to route_to(
        controller: 'home',
        action:     'mps'
      )
    end

    it 'GET home#find_your_constituency' do
      expect(get: '/find-your-constituency').to route_to(
        controller: 'home',
        action:     'find_your_constituency'
      )
    end

  end
end
