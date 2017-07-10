require 'rails_helper'

RSpec.describe 'search/results', vcr: true do
  context 'with a valid search term' do
    before do
      controller.params = { q: 'banana' }

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

  context 'with an invalid search term' do
    before do
      controller.params = { q: 'fsdfs' }

      render
    end

    context 'headers' do
      it 'will render the correct header' do
        expect(rendered).to match(/Search/)
      end
    end

    context 'results' do
      it 'will render the correct results message' do
        expect(rendered).to match(/There are no results for your search./)
      end
    end

    context 'partials' do
      it 'will render search/_search_box' do
        expect(response).to render_template(partial: '_search_box')
      end
    end
  end
end