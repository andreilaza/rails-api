class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :title, :order, :correct

  def filter(keys)
    if scope.role == User::ROLES[:estudent]
      keys - [:correct]
    else
      keys
    end
  end
end
