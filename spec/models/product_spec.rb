require 'spec_helper'

describe Product do
  before do
    Product.allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
    @product = FactoryGirl.create :product
  end
end
