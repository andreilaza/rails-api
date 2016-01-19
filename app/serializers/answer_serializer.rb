class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :title, :order, :correct

  def filter(keys)
    if (scope.role == User::ROLES[:estudent])
      if scope.allow_correct_answer === true && scope.question_id == object.question_id
        keys
      else
        keys - [:correct]
      end
    else
      keys
    end
  end  
end
