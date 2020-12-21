#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

class Day21
  attr_accessor :id, :locked, :lines
  def initialize(name)
    @products = File.read(name).split("\n").map do |data|
      m = data.match(/^(.*)\((.*)\)/)
      {
        ingredients: m[1].split(' '),
        allergens: m[2].split(', ').map {|s| s.gsub('contains ', '')}
      }
    end
  end

  def resolve_1
    cache_allergens = allergens
    @products.map do |product|
      (product[:ingredients] - cache_allergens).count
    end.sum
  end

  def resolve_2
    allergens_hash.sort_by { |key, value| key }.to_h.values.join(',')
  end

  def allergens_hash
    compile_allergens
    reduce_allergens

    @allergens
  end

  def compile_allergens
    @allergens = {}
    @products.each do |product|
      product[:allergens].each do |allergen|
        @allergens[allergen] ||= product[:ingredients]
        @allergens[allergen] =  @allergens[allergen] & product[:ingredients] #INTERSECTION
      end
    end

    @allergens
  end

  def reduce_allergens    
    piles = @allergens.select { |key, value| value.count == 1 }.values
    piles.each do |tab|
      @allergens.select { |key, value| value.count > 1 }.each do |key, value|
        @allergens[key] = value - tab
        piles << value if @allergens[key].count == 1
      end
    end
  end

  def allergens
    allergens_hash.values.flatten
  end
end

class Day21Test < Test::Unit::TestCase
  def test_star_1
    day = Day21.new('data_test.txt')
    assert_equal 5, day.resolve_1
  end

  def test_star_1_final
    day = Day21.new('data.txt')
    assert_equal 1958, day.resolve_1
  end

  def test_star_2
    day = Day21.new('data_test.txt')
    assert_equal "mxmxvkd,sqjhc,fvjkl", day.resolve_2
  end

  def test_star_2_final
    day = Day21.new('data.txt')
    assert_equal "xxscc,mjmqst,gzxnc,vvqj,trnnvn,gbcjqbm,dllbjr,nckqzsg", day.resolve_2
  end
end
