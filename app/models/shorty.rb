class Shorty < Material
  def first_sentence
    "#{self.excerpt.to_s.split(".").first}."
  end

  def filter
    self[:filter] ||= Rails.configuration.idfix.default_markup
  end

  def first_sentence_or_excerpt
    if self.excerpt =~ /^(.*)<!--\s*more\s*-->/
      return $1
    else
      return first_sentence
    end
  end

  # Temporary method beeded to migrate shorty to materials
  def text=(value)
    self.excerpt = value
  end
end