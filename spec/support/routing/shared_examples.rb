RSpec.shared_examples 'index route' do |controller|
  context 'index' do
    it "GET #{controller}#index" do
      expect(get: "/#{controller}").to route_to(
        controller: controller,
        action:     'index'
      )
    end
  end
end

# e.g. people#show - people/12341234
RSpec.shared_examples 'nested routes with an id' do |controller, id, routes, action|
  it "GET #{controller}##{action}" do
    expect(get: "/#{controller}/#{id}/#{routes.join('/')}").to route_to(
      controller:                     controller,
      action:                         action,
      "#{controller.singularize}_id": id
    )
  end
end

# e.g. people#postcode_lookup - POST /people/postcode_lookup
RSpec.shared_examples 'top level POST routes' do |controller, action|
  it "GET #{controller}##{action}" do
    expect(post: "/#{controller}/#{action}").to route_to(
                                                  controller: controller,
                                                  action:     action
                                                )
  end
end

# e.g. postcodes#show - postcodes/SW1A-2AA
RSpec.shared_examples 'nested routes with a postcode' do |controller, postcode, routes, action|
  it "GET #{controller}##{action}" do
    expect(get: "/#{controller}/#{postcode}/#{routes.join('/')}").to route_to(
                                                                       controller:                     controller,
                                                                       action:                         action,
                                                                       "#{controller.singularize}":    postcode
                                                                     )
  end
end
