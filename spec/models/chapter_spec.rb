require 'spec_helper'

describe Chapter, type: :model do
  let(:chapter) { FactoryGirl.build :chapter }

  it { should respond_to(:title) }
  it { should respond_to(:image) }
  it { should respond_to(:description) }
  it { should respond_to(:course_id) }
end
