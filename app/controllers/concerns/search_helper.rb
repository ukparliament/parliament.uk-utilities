module SearchHelper
  ALLOWED_HINTS = %(pdf Word Excel PowerPoint)

  def self.sanitize_query(params)
    Sanitize.fragment(params, Sanitize::Config::RELAXED)
  end

  def self.filter_hints(result)
    result.hint_type = nil unless ALLOWED_HINTS.include?(result.hint_type.to_s)
  end
end
