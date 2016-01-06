class RailsWisper
  def self.subscribe(obj)
    unless listeners.include? obj.class.name
      Wisper.subscribe(obj)
    end
  end

  private

  def self.listeners
    Wisper::GlobalListeners.listeners.map { |l| l.class.name.to_s }
  end
end

# Global wisper listeners
RailsWisper.subscribe(AnnouncementListener.new)