# Require gem to sanitize html to ensure safe postcode search
require 'sanitize'

class PostcodesController < ApplicationController
  before_action :data_check, :build_request, only: :show

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies.postcode_lookup(params[:postcode]) }
  }.freeze

  def index; end

  def show
    @postcode = Parliament::Utils::Helpers::PostcodeHelper.unhyphenate(Sanitize.fragment(params[:postcode], Sanitize::Config::RELAXED))

    begin
      response = Parliament::Utils::Helpers::PostcodeHelper.lookup(@postcode)

      @constituency, @person = response.filter('http://id.ukpds.org/schema/ConstituencyGroup', 'http://id.ukpds.org/schema/Person')

      @constituency = @constituency.first

      if Parliament::Utils::Helpers::PostcodeHelper.previous_path == url_for(action: 'mps', controller: 'home')
        if @person.empty?
          flash[:error] = "#{I18n.t('error.no_mp')} #{@constituency.name}."

          redirect_to(Parliament::Utils::Helpers::PostcodeHelper.previous_path) && return
        else
          redirect_to(person_path(@person.first.graph_id)) && return
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
    Parliament::Utils::Helpers::PostcodeHelper.previous_path = previous_path

    return redirect_to Parliament::Utils::Helpers::PostcodeHelper.previous_path, flash: { error: I18n.t('error.postcode_invalid').capitalize } if raw_postcode.gsub(/\s+/, '').empty?

    hyphenated_postcode = Parliament::Utils::Helpers::PostcodeHelper.hyphenate(raw_postcode)

    redirect_to postcode_path(hyphenated_postcode)
  end
end
