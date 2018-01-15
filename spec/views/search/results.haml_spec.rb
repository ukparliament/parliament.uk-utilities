require 'rails_helper'

RSpec.describe 'search/results', vcr: true do
  context 'with a valid search term' do
    before do
      controller.params = { q: 'banana' }

      assign(:results_total, 1)
      assign(:start_index, 1)
      assign(:count, 1)
      assign(:results, double(:results,
        entries: [double(:entry,
          title: 'Title 1',
          url: 'Url 1',
          hint_types: ['Hint 1'],
          formatted_url: 'FormattedUrl 1',
          content: 'Content 1')
        ]))

      render
    end

    context 'headers' do
      it 'will render the correct header' do
        expect(rendered).to match(/Search/)
      end
    end

    context 'results' do
      it 'will render the title, url and summary for each entry' do
        expect(rendered).to match(/Title 1/)
        expect(rendered).to match(/Url 1/)
        expect(rendered).to match(/Hint 1/)
        expect(rendered).to match(/FormattedUrl 1/)
        expect(rendered).to match(/Content 1/)
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
      assign(:results_total, 0)
      assign(:escaped_query_parameter, 'fsdfs')

      controller.params = { q: 'fsdfs' }

      render
    end

    context 'headers' do
      it 'will render the correct header' do
        expect(rendered).to match(/Search/)
      end
    end

    context 'results' do
      it 'will render the no results message' do
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
