require 'rails_helper'

RSpec.describe PaginationHelper do
  subject do
    Class.new { include PaginationHelper }
  end

  before(:each) do
    @test_class = subject.new
    @test_class.instance_variable_set(:@start_index, 31)
    @test_class.instance_variable_set(:@count, 10)
  end

  context '#current_page' do
    it 'calculates the current page' do
      expect(@test_class.current_page).to eq(4)
    end
  end

  context '#first_page' do
    it 'calculates the first page when the current page is less than 7' do
      expect(@test_class.first_page).to eq(1)
    end

    it 'calculates the first page when the current page is more than 7' do
      @test_class.instance_variable_set(:@start_index, 81)
      expect(@test_class.first_page).to eq(5)
    end

    it 'calculates the first page when the current page is greater than or equal to 7' do
      @test_class.instance_variable_set(:@start_index, 531)
      @test_class.instance_variable_set(:@results_total, 536)
      expect(@test_class.first_page).to eq(47)
    end
  end

  context '#last_page' do
    it 'calculates the last page when the results_total is less than the count * 10' do
      @test_class.instance_variable_set(:@results_total, 25)
      expect(@test_class.last_page).to eq(3)
    end

    it 'calculates the last page when the current page is less than 7' do
      @test_class.instance_variable_set(:@results_total, 154)
      expect(@test_class.last_page).to eq(8)
    end

    it 'calculates the last page when the current page is more than 7 and the results_total / count is more than 4 above the current page' do
      @test_class.instance_variable_set(:@start_index, 81)
      @test_class.instance_variable_set(:@results_total, 154)
      expect(@test_class.last_page).to eq(12)
    end

    it 'calculates the last page when the current page is more than 7 and the results_total / count is less than 4 above the current page' do
      @test_class.instance_variable_set(:@start_index, 81)
      @test_class.instance_variable_set(:@results_total, 114)

      expect(@test_class.last_page).to eq(12)
    end
  end

  context '#page_range' do
    it 'calculates the page_range' do
      @test_class.instance_variable_set(:@results_total, 154)
      expect(@test_class.page_range).to eq([1, 2, 3, 4, 5, 6, 7, 8])
    end
  end

  context '#next_page' do
    it 'calculates the next_page' do
      expect(@test_class.next_page).to eq(5)
    end
  end

  context '#previous_page' do
    it 'calculates the previous_page' do
      expect(@test_class.previous_page).to eq(3)
    end
  end

  context '#start_page' do
    it 'calculates the start_page' do
      expect(@test_class.start_index(5)).to eq(41)
    end
  end

  context '#active_tile' do
    it 'checks if active page is tile 3' do
      @test_class.instance_variable_set(:@start_index, 21)
      @test_class.instance_variable_set(:@results_total, 536)
      expect(@test_class.active_tile).to eq(3)
    end

    it 'checks if active page is tile 6' do
      @test_class.instance_variable_set(:@start_index, 61)
      @test_class.instance_variable_set(:@results_total, 536)
      expect(@test_class.active_tile).to eq(7)
    end

    it 'checks if active page is tile 8' do
      @test_class.instance_variable_set(:@start_index, 511)
      @test_class.instance_variable_set(:@results_total, 536)
      expect(@test_class.active_tile).to eq(8)
    end
  end
end
