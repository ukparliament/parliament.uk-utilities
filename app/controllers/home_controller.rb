class HomeController < ApplicationController
  before_action :disable_top_navigation, :disable_status_banner
  before_action :data_check, :build_request, except: :index

  ROUTE_MAP = {
    mps: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_mps },
    find_your_constituency: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.find_your_constituency }
  }.freeze


  def index; end

  def mps
    enable_top_navigation
    enable_status_banner

    @parliaments, @parties, @speaker = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/Party',
        'http://id.ukpds.org/schema/Person'
    )

    @parties = @parties.multi_direction_sort({ member_count: :desc, name: :asc })
  end

  def find_your_constituency
    enable_top_navigation
    enable_status_banner

    @regions = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion'
    )

    @regions = @regions.sort_by(:gss_code)
  end

end
