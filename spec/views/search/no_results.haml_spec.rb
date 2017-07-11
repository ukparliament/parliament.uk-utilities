require 'rails_helper'

RSpec.describe 'search/no_results', vcr: true do
  before do
    render
  end

  context 'headers' do
    it 'will render the correct header' do
      expect(rendered).to match(/Search/)
    end
  end

  context 'partials' do
    it 'will render search/_search_box' do
      expect(response).to render_template(partial: '_search_box')
    end
  end

  context 'results' do
    it 'will render the no results message' do
      expect(rendered).to match(/There are no results for your search./)
    end
  end
end