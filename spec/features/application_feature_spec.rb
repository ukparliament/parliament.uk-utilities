require 'rails_helper.rb'

RSpec.describe 'trailing slashes', vcr: true, :type => :feature do
  it 'removes trailing slashes from url' do
    visit '/mps/'
    expect(current_path).to eq('/mps')
  end

  it 'does not add trailing slash' do
    visit '/mps'
    expect(current_path).to eq('/mps')
  end
end
