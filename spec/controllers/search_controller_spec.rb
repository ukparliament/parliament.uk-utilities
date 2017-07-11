require 'rails_helper'

RSpec.describe SearchController, vcr: true do
  describe 'GET index' do
    context 'with no query' do
      before(:each) do
        get :index
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end
    end

    context 'with a query' do
      context 'with a valid search' do
        before(:each) do
          get :index, params: { q: 'banana' }
        end

        it 'should have a response with http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'assigns @query_parameter' do
          expect(assigns(:query_parameter)).to eq('banana')
        end

        it 'assigns @start_page' do
          expect(assigns(:start_page)).to eq(1)
        end

        it 'assigns @count' do
          expect(assigns(:count)).to eq(10)
        end

        it 'assigns @results' do
          expect(assigns(:results)).to be_a(Feedjira::Parser::Atom)
        end

        it 'renders the results template' do
          expect(response).to render_template('results')
        end
      end

      context 'an invalid search' do
        before(:each) do
          get :index, params: { q: 'fdsfsd' }
        end

        it 'should have a response with http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the results template' do
          expect(response).to render_template('results')
        end
      end

      context 'search for a non-ascii character' do
        it 'should have a response with http status ok (200)' do
          get :index, params: { q: 'Ü' }

          expect(response).to have_http_status(:ok)
        end
      end

      context 'very long query' do
        before(:each) do
          get :index, params: { q: File.read('spec/fixtures/strings/long_search_string') }
        end

        it 'should cut query to maximum 2048 characters' do
          expect(WebMock).to have_requested(:get, "https://apidataparliament.azure-api.net/search?pagesize=10&q=#{File.read('spec/fixtures/strings/escaped_parameter_string')}&start=1")
                                 .with(headers: {'Accept'=>['*/*', 'application/atom+xml'], 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Ocp-Apim-Subscription-Key'=>ENV['OPENSEARCH_AUTH_TOKEN'], 'User-Agent'=>'Ruby'}).once
        end
      end

      context '<br> tag in search results' do
        before(:each) do
          get :index, params: { q: 'banana' }
        end

        it 'should strip <br> tag' do
          assigns(:results).entries.each do |entry|
            expect(entry.summary).not_to include('<br>')
            expect(entry.title).not_to include('<br>')
          end
        end
      end

      context 'prevents xss on search' do
        before(:each) do
          get :index, params: { q: '<script>alert(document.cookie)</script>'}
        end

        it 'should prevent xss on search' do
          expect(response.body).not_to include('<script>alert(document.cookie)</script>')
        end

        it 'should sanitize the search term' do
          expect(response.body).to include('alert(document.cookie)')
        end
      end
    end
  end
end