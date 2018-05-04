require 'rails_helper'

RSpec.describe ResourceController, vcr: true do

  describe 'GET index' do
    it 'should raise a routing error (404)' do
      expect{get :index}.to raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET grom nodes' do
    context 'successfully' do
      before(:each) do
        get :show, params: { resource_id: '1AeEPhYf' }
      end

      it 'assigns @results if grom nodes can be found' do
        assigns(:results).each do |result|
          expect(result).to be_a(Grom::Node)
        end
      end
    end

    context 'unsuccessfully' do
      it 'raises error if no grom nodes can be found (404)' do
        expect{get :show, params: { resource_id: '12345678' }}.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'Handling response' do
    context 'when a route exits' do
      before(:each) do
        get :show, params: { resource_id: '1AeEPhYf' }
      end

      it 'redirects to correct path' do
        expect(response).to redirect_to(person_path('1AeEPhYf'))
      end

      context 'when the uri is a schema' do
        before(:each)do
          get :show, params: { resource_id: 'schema/Person' }
        end

        it 'redirects to correct path' do
          expect(response).to render_template('show')
        end
      end
    end

    context 'when no route exists' do
      before(:each) do
        get :show, params: { resource_id: 'IIQmgtWD' }
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end
  end
end
