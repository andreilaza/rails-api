require 'spec_helper'

describe Course, type: :model do
  let(:course) { FactoryGirl.build :course }

  it { should respond_to(:title) }  
  it { should respond_to(:description) }
  it { should respond_to(:published) }

  it { should validate_presence_of :title }  
  it { should not_be_published }
end
