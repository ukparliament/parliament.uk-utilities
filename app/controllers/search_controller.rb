class SearchController < ApplicationController

  def index
    disable_top_navigation

    # Setup Parliament Opensearch
    begin
      Parliament::Request::OpenSearchRequest.description_url = ENV['OPENSEARCH_DESCRIPTION_URL']
    rescue Errno::ECONNREFUSED => e
      raise StandardError, "There was an error getting the description file from OPENSEARCH_DESCRIPTION_URL environment variable value: '#{ENV['OPENSEARCH_DESCRIPTION_URL']}' - #{e.message}"
    end

    @query_parameter = params[:q] || nil

    # Show the index page if there is no query passed
    return render 'index' if @query_parameter.nil?

    # Show empty search page if user searches for an empty string
    return render 'empty_search' if @query_parameter.empty?

    # Escape @query_parameter that replaces all 'unsafe' characters with a UTF-8 hexcode which is safer to use when making an OpenSearch request
    @query_parameter = Sanitize.fragment(@query_parameter, Sanitize::Config::RELAXED)
    escaped_query_parameter = CGI.escape(@query_parameter)[0, 2048]
    @start_index = params[:start_index] || Parliament::Request::OpenSearchRequest.open_search_parameters[:start_index]
    @start_index = @start_index.to_i
    @count = params[:count] || Parliament::Request::OpenSearchRequest.open_search_parameters[:count]
    @count = @count.to_i

    request = Parliament::Request::OpenSearchRequest.new(headers: { 'Accept' => 'application/atom+xml',
                                                                    'Ocp-Apim-Subscription-Key' => ENV['OPENSEARCH_AUTH_TOKEN']},
                                                         builder: Parliament::Builder::OpenSearchResponseBuilder)

    begin
      logger.info "Making a query for '#{@query_parameter}' => '#{escaped_query_parameter}' using the base_url: '#{request.base_url}'"
      @results = request.get({ query: escaped_query_parameter, start_index: @start_index, count: @count })

      # Remove <br> characters from results
      @results.entries.each do |result|
        %w(summary content).each do |content_method|
          result[content_method].gsub!(/(<br>|<br\/>|<br \/>)/, '') if result[content_method]
        end
      end

      @results_total = @results.totalResults

      return render 'results'
    rescue Parliament::ServerError => e
      logger.warn "Server error caught from search request: #{e.message}"
      return render 'no_results'
    end
  end


  def opensearch
    description_file = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
  <ShortName>#{I18n.t('pugin.layouts.pugin.website_brand')}</ShortName>
  <Description>Search #{I18n.t('pugin.layouts.pugin.website_brand')} online content</Description>
  <Image height="16" width="16" type="image/x-icon">#{root_url}favicon.ico</Image>
  <Url type="text/html" template="#{search_url}?q={searchTerms}&amp;start_index={startIndex?}&amp;count={count?}" />
</OpenSearchDescription>
XML
    render xml: description_file, content_type: 'application/opensearchdescription+xml', layout: false
  end
end
