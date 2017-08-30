require 'rails_helper'

RSpec.describe 'meta', type: :routing do
  describe 'MetaController' do
    include_examples 'index route', 'meta'

    context 'cookie policy' do
      it 'GET meta#cookie_policy' do
        expect(get: '/meta/cookie-policy').to route_to(
          controller: 'meta',
          action:     'cookie_policy'
        )
      end
    end

    context 'Who should I contact with my issue?' do
      it 'GET meta#who_should_i_contact_with_my_issue' do
        expect(get: '/who-should-i-contact-with-my-issue').to route_to(
          controller: 'meta',
          action:     'who_should_i_contact_with_my_issue'
        )
      end
    end

  end
end
