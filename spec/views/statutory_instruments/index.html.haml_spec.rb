require 'rails_helper'

RSpec.describe 'statutory_instruments/index', vcr: true do
  context 'header' do
    xit 'will render the correct header' do
      expect(rendered).to match(/'SI Landing Page'/)
    end
  end
end
