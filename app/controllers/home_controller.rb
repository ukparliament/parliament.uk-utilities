class HomeController < ApplicationController
  before_action :disable_status_banner
  before_action :data_check, :build_request, except: :index

  before_action :enable_status_banner
  before_action :enable_pingdom, only: :mps

  ROUTE_MAP = {
    mps: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_mps },
    find_your_constituency: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.find_your_constituency }
  }.freeze


  def index; end

  def mps
    @parliaments, @parties, @speaker = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ParliamentPeriod', 'Party', 'Person')

    @parties = @parties.multi_direction_sort({ member_count: :desc, name: :asc })
  end

  def find_your_constituency
    @places = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ordnance')

    @places = @places.sort_by(:gss_code)
  end

end
