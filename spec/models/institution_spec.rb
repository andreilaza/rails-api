require 'spec_helper'

describe Institution, type: :model do
  let(:institution) { FactoryGirl.build :institution }

  it { should respond_to(:title) }
  it { should respond_to(:image) }
  it { should respond_to(:description) }

  it { should validate_presence_of :title }  
end
