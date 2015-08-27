require 'spec_helper'

describe Question, type: :model do
  let(:question) { FactoryGirl.build :question }

  it { should respond_to(:title) }  
  it { should respond_to(:section_id) }
  it { should respond_to(:order) }
  it { should respond_to(:question_type) }
  it { should respond_to(:score) }
end
