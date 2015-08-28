require 'spec_helper'

describe Answer, type: :model do
  let(:answer) { FactoryGirl.build :answer }

  it { should respond_to(:title) }  
  it { should respond_to(:question_id) }
  it { should respond_to(:order) }
  it { should respond_to(:correct) }
  
end
