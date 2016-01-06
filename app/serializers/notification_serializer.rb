class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :entity_id, :notification_type, :course, :announcement, :seen#, :message

  def filter(keys)
    if object.notification_type == Notification::TYPE[:system]
      keys - [:course]
    else      
      keys - [:announcement]
    end
  end

  def notification_type
    if object.notification_type == Notification::TYPE[:system]
      return 'system'
    end

    if object.notification_type == Notification::TYPE[:course]
      return 'course'
    end
  end

  def course
    course = Course.find(object.entity_id)
  end

  def announcement
    announcement = Announcement.find(object.entity_id)  
  end

  def seen
    user_notification = UserNotification.where('user_id' => scope.id, 'notification_id' => object.id).first
    user_notification.status

    return user_notification.status == 1
  end
end
