require 'rails_helper'

RSpec.describe 'search/empty_search', vcr: true do
  before do
    render
  end

  context 'headers' do
    it 'will render the correct header' do
      expect(rendered).to match(/Search/)
    end
  end

  context 'partials' do
    it 'will render search/_empty_search' do
      expect(response).to render_template(partial: '_empty_search')
    end
  end

  context 'results' do
    it 'will render the empty search message' do
      expect(rendered).to match(/Please enter a search term/)
    end
  end
end
