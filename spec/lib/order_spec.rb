require 'spec_helper'

describe RgLibGem::Order do
  before(:all) do
    @new_order = described_class.new(0, "  utopia  ", "  mOre  ")
    @ord_equiv = [ 0, "Utopia", "More", Time.now.strftime("%Y%m%d")]
  end
  it_behaves_like 'a subclass'
  describe '.new' do
    it_behaves_like 'not initialized with empty arguments'
    it_behaves_like 'not initialized with one argument'
    context 'with three arguments initialized' do
      it { expect{described_class.new(0, "  Utopia ", "more")}.to_not raise_error }
    end
    
    order_var = [:reader_id, :book, :author, :date]
      
    context 'with instance variables' do
      order_var.each do |mtd|
        it { expect(@new_order.instance_variables).to include("@#{mtd}".to_sym) }
        it { expect(@new_order.send(mtd)).to_not be_nil }
        if order_var[1..3].include?(mtd)
          it 'should not have blank trailing spaces' do
            expect(@new_order.send(mtd).length).to eq(@new_order.send(mtd).strip.length)
          end
        else
          it { expect(@new_order.send(mtd)).to be_kind_of(Fixnum) }
        end
      end
    end
    context 'with attr_readers' do
      order_var.each do |mtd|
        it { expect(@new_order).to respond_to(mtd) }
      end
    end
    context 'with no attr_writers' do
      order_var.each do |mtd|
        it { expect(@new_order).not_to respond_to("#{mtd}=") }
      end
    end
    context 'with not assigned attribute :date' do
      it 'should set it to current date' do
        expect(@new_order.date).to match(Time.now.strftime("%Y%m%d"))
      end
    end
    context 'with attributes' do
      order_var.each_with_index do |atr, index|
        it { expect(@new_order).to have_attributes(atr => @ord_equiv[index]) }
      end
    end  
    context 'with assigning reader_id as not Fixnum' do
      it { expect{ described_class.new("1", "Title", "Author") }.to raise_error }
    end
    context 'with assigning book title as not String' do
      it { expect{ described_class.new(1, 3, "More") }.to raise_error }
    end
    context 'with assigning author\'s name as not String' do
      it { expect{ described_class.new(1, "Utopia", 5.2) }.to raise_error }
    end
    context 'while assigning date' do
      context 'with not String or Date' do
        it { expect{ described_class.new(0, "Utopia", "More", 3) }.to raise_error }
      end
      it 'should convert Date format to String ("%Y%m%d")' do
        expect(described_class.new(0, "Utopia", "More", Date.parse(Time.now.to_s)).date).to eq (Time.now.strftime("%Y%m%d"))
      end
      context 'with date that greater than current' do
        it { expect{ described_class.new(0, "Title", "Author", "30000101") }.to raise_error }
      end
    end
  end
end

