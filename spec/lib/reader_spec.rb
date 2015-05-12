require 'spec_helper'

describe RgLibGem::Reader do
  before(:all) do
    @new = described_class.new(" nAme ", "email" , "city", "street", "45")
    @equiv = %w[Name email City Street 45]
  end
  it_behaves_like 'a subclass'
  describe '.new' do
    it_behaves_like 'not initialized with empty arguments'
    it_behaves_like 'initialized with one argument'
    it_behaves_like 'initialized with more than two arguments'

    var_arr = [:name, :email, :city, :street, :house]

    context 'with instance variables' do
      var_arr.each do |i_var|
        it { expect(@new.instance_variables).to include("@#{i_var}".to_sym) }
      end
    end
    
    context 'with attr_readers' do
      var_arr.each do |mtd|
        it { expect(@new).to respond_to(mtd) }
      end
    end
    
    context 'with no attr_writers' do
      var_arr.each do |mtd|
        it { expect(@new).not_to respond_to("#{mtd}=") }
      end
    end
    
    context 'with attributes' do
      var_arr.each_with_index do |atr, index|
        it { expect(@new).to have_attributes(atr => @equiv[index]) }
      end
    end
    
    context 'with no trailing spaces and blank attributes' do
      subject(:inst) { described_class.new("  name  ") }
      it { expect(inst.name).to eq("Name") }
      it { expect(inst.house).to eq("N/a") }
    end    
  end
end
