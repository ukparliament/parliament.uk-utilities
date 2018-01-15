# -*- coding: utf-8 -*-
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
          expect(assigns(:start_index)).to eq(1)
        end

        it 'assigns @count' do
          expect(assigns(:count)).to eq(10)
        end

        it 'assigns @results' do
          expect(assigns(:results)).to be_a(Feedjira::Parser::Atom)
        end

        it 'filters hints' do
          expect(assigns(:results).entries.first.hint_type).to eq('pdf')
          expect(assigns(:results).entries.last.hint_type).to eq(nil)
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

      context 'with an empty string' do
        before(:each) do
          get :index, params: { q: '' }
        end

        it 'should have a response with http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the empty search template' do
          expect(response).to render_template('empty_search')
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

      context 'new search opt out' do
        context 'has external referer' do
          before(:each) do
            request.headers['HTTP_REFERER'] = 'https://www.parliament.uk/search/results/?new-search-opt'
            cookies[:new_search_opt_out] = true
            get :index, params: { q: 'Test' }
          end

          it 'will redirect' do
            expect(response).to redirect_to("https://www.parliament.uk/search/results/?new-search-opt-out=true&q=Test")
          end
        end

        context 'does not have external referer' do
          before(:each) do
            cookies[:new_search_opt_out] = true
            get :index, params: { q: 'Test' }
          end

          it 'will not redirect' do
            expect(response).not_to redirect_to("https://www.parliament.uk/search/results/?new-search-opt-out=true&q=Test")
          end
        end
      end

      context 'with no count or start_index value' do
        before(:each) do
          get :index, params: { q: 'Matt Rayner', count: '', start_index: '' }
        end

        it 'should have a response with http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'should set count to the default value' do
          expect(controller.instance_variable_get(:@count)).to eq(10)
        end

        it 'should set start_index to the default value' do
          expect(controller.instance_variable_get(:@start_index)).to eq(1)
        end
      end
    end
  end

  describe 'GET redirect' do
    before(:each) do
      get :redirect, params: { q: 'Test' }
    end

    it 'will set a cookie' do
      expect(cookies[:new_search_opt_out]).to eq('true')
    end

    it 'will get query' do
      expect(controller.instance_variable_get(:@query_parameter)).to eq('Test')
    end

    it 'will redirect to old search' do
      expect(response).to redirect_to("https://www.parliament.uk/search/results/?new-search-opt-out=true&q=Test")
    end
  end

  describe 'GET opensearch' do
    before(:each) do
      get :opensearch
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the expected XML' do
      xml_file=<<XML
<?xml version="1.0" encoding="UTF-8"?>
<OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
  <ShortName>UK Parliament</ShortName>
  <Description>Search UK Parliament online content</Description>
  <Image height="16" width="16" type="image/x-icon">http://test.host/favicon.ico</Image>
  <Url type="text/html" template="http://test.host/search?q={searchTerms}&amp;start_index={startIndex?}&amp;count={count?}" />
</OpenSearchDescription>
XML

      expect(response.body).to eq(xml_file)
    end

    it 'uses the expected content-type header' do
      expect(response.headers['Content-Type']).to eq('application/opensearchdescription+xml; charset=utf-8')
    end
  end
end
