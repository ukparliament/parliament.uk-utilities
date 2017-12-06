require 'rails_helper'

RSpec.describe SearchHelper, vcr: true do
  context '#filter_hints' do
    context 'hint type is should be visable' do
      it 'will not edit hint_type' do
        result = double(:result, hint_type: 'pdf')

        SearchHelper.filter_hints(result)
        expect(result.hint_type).to eq('pdf')
      end
    end

    context 'hint type should be nil' do
      it 'will set hint_type to nil' do
        result = double(:result, hint_type: 'Test')

        expect(result).to receive(:hint_type=).with(nil)
        SearchHelper.filter_hints(result)
      end
    end
  end
end
