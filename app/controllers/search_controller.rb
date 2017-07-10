class SearchController < ApplicationController

  def index
    # Setup Parliament Opensearch
    begin
      Parliament::Request::OpenSearchRequest.description_url = ENV['OPENSEARCH_DESCRIPTION_URL']
    rescue Errno::ECONNREFUSED => e
      raise StandardError, "There was an error getting the description file from OPENSEARCH_DESCRIPTION_URL environment variable value: '#{ENV['OPENSEARCH_DESCRIPTION_URL']}' - #{e.message}"
    end

    @query_parameter = params[:q] || nil

    # Show the index page if there is no query passed
    return render 'index' unless @query_parameter

    # Escape @query_parameter that replaces all 'unsafe' characters with a UTF-8 hexcode which is safer to use when making an OpenSearch request
    @query_parameter = Sanitize.fragment(@query_parameter, Sanitize::Config::RELAXED)
    escaped_query_parameter = CGI.escape(@query_parameter)[0, 2048]
    @start_page = params[:start_page] || Parliament::Request::OpenSearchRequest.open_search_parameters[:start_page]
    @start_page = @start_page.to_i
    @count = Parliament::Request::OpenSearchRequest.open_search_parameters[:count]

    request = Parliament::Request::OpenSearchRequest.new(headers: { 'Accept' => 'application/atom+xml',
                                                                    'Ocp-Apim-Subscription-Key' => ENV['OPENSEARCH_AUTH_TOKEN']},
                                                         builder: Parliament::Builder::OpenSearchResponseBuilder)

    begin
      logger.info "Making a query for '#{@query_parameter}' => '#{escaped_query_parameter}' using the base_url: '#{request.base_url}'"
      @results = request.get({ query: escaped_query_parameter, start_page: @start_page })
      @results.entries.each { |result| result.summary.gsub!(/<br>/, '') if result.summary }

      @results_total = @results.totalResults

      return render 'results'
    rescue Parliament::ServerError => e
      logger.warn "Server error caught from search request: #{e.message}"
      return render 'no_results'
    end
  end
end