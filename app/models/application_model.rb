class ApplicationModel < ActiveRecord::Base
  self.abstract_class = true

  def is_number? string
    true if Float(string) rescue false
  end
end
