require 'parliament'
require 'parliament/open_search'
require 'pugin/helpers/controller_helpers'
require 'parliament/utils'

class ApplicationController < ActionController::Base
  include Pugin::Helpers::ControllerHelpers
  include ResourceHelper
  include Parliament::Utils::Helpers::ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'pugin/layouts/pugin'

  # Controller helper methods available from Pugin::Helpers::ControllerHelpers
  #
  # Used to turn Pugin Features on and off at a controller level
  before_action :populate_request_id, :reset_bandiera_features, :enable_top_navigation, :enable_global_search, :enable_status_banner, :reset_alternates, :disable_pingdom

  # Rescues from a Parliament::ClientError and raises an ActionController::RoutingError
  rescue_from Parliament::ClientError do |error|
    raise ActionController::RoutingError, error.message
  end

  # Rescues from a Parliament::NoContentResponseError and raises an ActionController::RoutingError
  rescue_from Parliament::NoContentResponseError do |error|
    raise ActionController::RoutingError, error.message
  end
end
