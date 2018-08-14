class MetaController < ApplicationController

  def index
    @meta_routes = []
    Rails.application.routes.routes.each do |route|
      path = route.path.spec.to_s

      next unless path.starts_with?('/meta/')

      path = path.sub(/\(.:format\)/, '')
      translation = path.split('/').last
      @meta_routes << { url: path, translation: translation }
    end

    render 'index'
  end

  def cookie_policy
    render 'cookie_policy'
  end

  def who_should_i_contact_with_my_issue; end
end
