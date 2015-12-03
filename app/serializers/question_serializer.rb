class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :section_id, :order, :score, :question_type, :completed
  
  has_many :answers
  has_many :question_hints

  def filter(keys)
    if scope.role == User::ROLES[:estudent]
      keys
    else
      keys - [:completed]
    end
  end

  def completed
    students_question = StudentsQuestion.where(user_id: scope.id, question_id: object.id).first
    if students_question
      students_question.completed
    else
      false
    end
  end
end
