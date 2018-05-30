require 'rails_helper'

RSpec.describe 'statutory_instruments/index', vcr: true do
  before do
    render
  end

  context 'header' do
    it 'will render the correct page heading' do
      expect(rendered).to match(/Statutory instruments/)
    end
  end

  context 'section one' do
    it 'will render the correct heading in section 1' do
      expect(rendered).to match(/Find a statutory instrument/)
    end
  end

  context 'section two' do
    it 'will render the correct heading in section 2' do
      expect(rendered).to match(/More information/)
    end
  end
end
