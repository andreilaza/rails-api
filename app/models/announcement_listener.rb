class AnnouncementListener
  def deliver_announcement(announcement)
    notification = Notification.new
    notification.entity_id = announcement.id
    notification.notification_type = Notification::TYPE[:system]
    notification.message = announcement.announcement
    notification.save

    estudents = User.where(:role => User::ROLES[:estudent]).all

    estudents.each do |estudent|
      user_notification = UserNotification.new
      user_notification.user_id = estudent.id
      user_notification.notification_id = notification.id
      user_notification.status = 0

      user_notification.save
    end
  end
end