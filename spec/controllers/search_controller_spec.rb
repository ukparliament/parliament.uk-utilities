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

      context '<br> tag in search results' do
        before(:each) do
          get :index, params: { q: 'banana' }
        end

        context 'with summary body' do
          it 'should strip <br> tag' do
            assigns(:results).entries.each do |entry|
              expect(entry.summary).not_to include('<br>')
              expect(entry.title).not_to include('<br>')
            end
          end
        end

        context 'with content body' do
          it 'should strip <br> tag' do
            assigns(:results).entries.each do |entry|
              expect(entry.content).not_to include('<br>')
              expect(entry.title).not_to include('<br>')
            end
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

      context 'setting up Parliament Opensearch with a connection refused error' do
        before(:each) do
          allow(Parliament::Request::OpenSearchRequest).to receive(:description_url=).and_raise(Errno::ECONNREFUSED)
        end

        it 'should raise an error' do
          expect { get :index }.to raise_error(StandardError)
        end
      end
    end
  end
end
