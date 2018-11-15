class HomeController < ApplicationController
  before_action :disable_status_banner
  before_action :data_check, :build_request, except: %i[index]

  before_action :enable_status_banner
  before_action :enable_pingdom, only: :mps

  ROUTE_MAP = {
    mps:                         proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_mps },
    find_your_constituency:      proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.find_your_constituency },
    find_a_statutory_instrument: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.laying_body_index }
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

  def find_a_statutory_instrument
    @laying_bodies = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'LayingBody')

    @laying_bodies = @laying_bodies.sort_by(:groupName)
  end
end
