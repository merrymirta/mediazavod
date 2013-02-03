module ShortiesHelper
  def shorty_preview_options(*args)
    {
      :format => :full,
      :meta => {:section => false}
    }
  end
end