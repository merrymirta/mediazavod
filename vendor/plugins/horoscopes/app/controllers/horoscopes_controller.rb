class HoroscopesController < ApplicationController
  def index
    @signs = Horoscopes::Parser.new.parse
  end
end