require 'spec_helper'

describe Section, type: :model do
  let(:section) { FactoryGirl.build :section }

  it { should respond_to(:title) }  
  it { should respond_to(:description) }
  it { should respond_to(:chapter_id) }
  it { should respond_to(:order) }
end
