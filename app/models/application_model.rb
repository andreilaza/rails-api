class ApplicationModel < ActiveRecord::Base
  self.abstract_class = true  

  def find(param)
    if is_number? param
      super(param[:id])
    else
          
    end
  end

  def is_number? string
    true if Float(string) rescue false
  end
end
