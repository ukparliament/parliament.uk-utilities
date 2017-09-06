module SearchHelper
  def self.sanitize_query(params)
    Sanitize.fragment(params, Sanitize::Config::RELAXED)
  end
end
