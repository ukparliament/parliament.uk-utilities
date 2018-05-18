module PaginationHelper
  def current_page
    @start_index / @count + 1
  end

  def first_page
    # Set first_page value to 1 when current_page is less-than or equal-to 6.
    return 1 if current_page <= 6

    # Stop page_range from scrolling when current_page is greater-than the last 4.
    if (current_page > last_page - (10 - 6) && last_page > 10)
      return last_page - (10 - 1)
    end

    # Set first_page to current_page minus 5.
    current_page - (6 - 1)
  end

  def last_page
    if @results_total.to_i < 10 * @count
      (@results_total.to_f / @count).ceil
    elsif current_page < 7
      10
    else
      current_page + 4 < (@results_total.to_f / @count).ceil ? current_page + 4 : (@results_total.to_f / @count).ceil
    end
  end

  def page_range
    (first_page...current_page).to_a.concat((current_page..last_page).to_a)
  end

  def next_page
    current_page + 1
  end

  def previous_page
    current_page - 1
  end

  # Generate a start index for a given page number
  def start_index(page)
    (page - 1) * @count + 1
  end

  def active_tile
    if (current_page > (@count / 2) && current_page < @count - (@count / 2 - 1))
      6
    elsif (current_page > @count - (@count / 2 - 1))
      @count - (last_page - current_page)
    else
      current_page
    end
  end
end
