class ApplicationModel < ActiveRecord::Base
  self.abstract_class = true

  def append_assets
  end
end
