module HoroscopesHelper
  def random_horoscope
    if signs = Horoscopes::Parser.new.parse and signs.any?
      render(
        :partial  => "horoscopes/random_sign",
        :locals   => { :sign => signs[rand(signs.size)] }
      )
    end
  end
end