module SearchHelper
  def self.sanitize_query(params)
    Sanitize.fragment(params, Sanitize::Config::RELAXED)
  end

  def self.save_query_parameters(params)
    session[:query_parameters] = params
  end

  def self.load_query_parameters
    session[:query_parameters]
  end
end
