require 'rails_helper'

RSpec.describe 'search', type: :routing do
  describe ResourceController do
    context 'search' do
      include_examples  'index route', 'search'
    end
  end
end
