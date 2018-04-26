# Require gem to sanitize html to ensure safe postcode search
require 'sanitize'

class PostcodesController < ApplicationController
  before_action :data_check, :build_request, only: :show

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request(@app_insights_request_id).constituency_lookup_by_postcode.set_url_params({ postcode: params[:postcode] }) }
  }.freeze

  def index; end

  def show
    @postcode = Parliament::Utils::Helpers::PostcodeHelper.unhyphenate(Sanitize.fragment(params[:postcode], Sanitize::Config::RELAXED))

    # Handle redirects if we are coming from the MPs or Find My Constituency pages
    previous_path = session[:postcode_previous_path].dup
    session.delete(:postcode_previous_path)

    begin
      response = Parliament::Utils::Helpers::PostcodeHelper.lookup(@postcode)

      @constituency, @person = response.filter(Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ConstituencyGroup'), Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('Person'))

      @constituency = @constituency.first

      # Set our flash message if no MP is found for this postcode
      if @person.empty? && previous_path == mps_url
        flash[:error] = "#{I18n.t('error.no_mp')} #{@constituency.name}."

        return redirect_to(previous_path)
      end

      # If the user has come from a specific path, send them on their way
      return redirect_to(person_path(@person.first.graph_id)) if previous_path == mps_url
      return redirect_to(constituency_path(@constituency.graph_id)) if previous_path == find_your_constituency_url
    rescue Parliament::Utils::Helpers::PostcodeHelper::PostcodeError => error
      flash[:error] = error.message
      flash[:postcode] = @postcode
      redirect_to(previous_path)
    end

    # Instance variable for single MP pages
    @single_mp = true
  end

  def lookup
    raw_postcode = params[:postcode]
    previous_controller = params[:previous_controller]
    previous_action = params[:previous_action]
    previous_path = url_for(controller: previous_controller, action: previous_action)
    session[:postcode_previous_path] = previous_path

    return redirect_to previous_path, flash: { error: I18n.t('error.postcode_invalid').capitalize } if raw_postcode.gsub(/\s+/, '').empty?

    hyphenated_postcode = Parliament::Utils::Helpers::PostcodeHelper.hyphenate(raw_postcode)

    redirect_to postcode_path(hyphenated_postcode)
  end
end
