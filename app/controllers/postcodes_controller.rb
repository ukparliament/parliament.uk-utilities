# Require gem to sanitize html to ensure safe postcode search
require 'sanitize'

class PostcodesController < ApplicationController
  before_action :data_check, :build_request, only: :show

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_lookup_by_postcode.set_url_params({ postcode: params[:postcode] }) }
  }.freeze

  def index; end

  def show
    @postcode = Parliament::Utils::Helpers::PostcodeHelper.unhyphenate(Sanitize.fragment(params[:postcode], Sanitize::Config::RELAXED))

    begin
      response = Parliament::Utils::Helpers::PostcodeHelper.lookup(@postcode)

      @constituency, @person = response.filter('http://id.ukpds.org/schema/ConstituencyGroup', 'http://id.ukpds.org/schema/Person')

      @constituency = @constituency.first

      if session[:postcode_previous_path] == url_for(action: 'mps', controller: 'home')
        p 'GOT HERE'
        if @person.empty?
          flash[:error] = "#{I18n.t('error.no_mp')} #{@constituency.name}."

          redirect_to(Parliament::Utils::Helpers::PostcodeHelper.previous_path) && return
        else
          redirect_to(person_path(@person.first.graph_id)) && return
        end
      elsif session[:postcode_previous_path] == url_for(action: 'find_your_constituency', controller: 'home')
        p 'GOT HERE 2'
        if @person.empty?
          flash[:error] = "#{I18n.t('error.no_mp')} #{@constituency.name}."

          redirect_to(session[:postcode_previous_path]) && return
        else
          redirect_to(constituency_path(@constituency.graph_id)) && return
        end
      end
    rescue Parliament::Utils::Helpers::PostcodeHelper::PostcodeError => error
      flash[:error] = error.message
      flash[:postcode] = @postcode
      redirect_to(Parliament::Utils::Helpers::PostcodeHelper.previous_path)
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
