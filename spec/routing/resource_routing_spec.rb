require 'rails_helper'

RSpec.describe 'resource', type: :routing do
  describe ResourceController do
    context 'resources' do
      include_examples  'index route', 'resource'
    end

    context 'resource' do
      # postcodes#show
      include_examples 'nested routes with an id', 'resource', 'xP2kB45W', [], 'show'
    end
  end
end
