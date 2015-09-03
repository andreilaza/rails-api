require 'spec_helper'

describe Asset, type: :model do
  let(:asset) { FactoryGirl.build :asset }

  it { should respond_to(:entity_id) }  
  it { should respond_to(:entity_type) }
  it { should respond_to(:path) }
  it { should respond_to(:definition) }
  
end
