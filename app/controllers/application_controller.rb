require 'parliament'
require 'parliament/open_search'

require 'pugin/helpers/controller_helpers'

class ApplicationController < ActionController::Base
  include Pugin::Helpers::ControllerHelpers

  protect_from_forgery with: :exception

  layout 'pugin/layouts/pugin'
end
