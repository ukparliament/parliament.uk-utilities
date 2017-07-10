require 'rails_helper'

RSpec.describe 'search/index', vcr: true do
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
end