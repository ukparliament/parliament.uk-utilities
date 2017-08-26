require 'rails_helper'

RSpec.describe 'resource/show' do
  before(:each) do
    subject1 = double('subject', uri?: true, to_s: 'http://example.com/1' )
    subject2 = double('subject', uri?: true, to_s: 'http://example.com/2' )

    predicate1 = double('subject', uri?: true, to_s: 'http://example.com/schema/name' )
    predicate2 = double('subject', uri?: true, to_s: 'http://example.com/schema/hasLink' )

    object1 = double('subject', uri?: false, to_s: 'Matt Rayner' )
    object2 = double('subject', uri?: true, to_s: 'http://example.com/1' )

    @statements = [ [subject1, predicate1, object1], [subject2, predicate2, object2] ]
    render
  end

  context 'table headings' do
    it 'displays the correct titles' do
      thead = <<HTML
<thead>
<tr>
<th>Subject</th>
<th>Predicate</th>
<th>Object</th>
</tr>
</thead>
HTML
      expect(rendered).to include(thead)
    end
  end

  it 'displays the correct markup for row 1' do
    row1 = <<HTML
<tr>
<td>
<a href="http://example.com/1">http://example.com/1</a>
</td>
<td>
<a href="http://example.com/schema/name">http://example.com/schema/name</a>
</td>
<td>
Matt Rayner
</td>
</tr>
HTML
    expect(rendered).to include(row1)
  end

  it 'displays the correct markup for row 2' do
    row1 = <<HTML
<tr>
<td>
<a href="http://example.com/2">http://example.com/2</a>
</td>
<td>
<a href="http://example.com/schema/hasLink">http://example.com/schema/hasLink</a>
</td>
<td>
<a href="http://example.com/1">http://example.com/1</a>
</td>
</tr>
HTML
    expect(rendered).to include(row1)
  end
end
