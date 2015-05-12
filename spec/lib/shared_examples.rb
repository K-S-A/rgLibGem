shared_examples 'a unique object' do

  before(:all) do
    @new = described_class.new("\ntitle  ", "  auThor  ")
    @equiv = described_class == RgLibGem::Book ? ["Title", "Author"] : ["Title", "AuThor"]
   end
   
   describe '.new' do
    it_behaves_like 'not initialized with empty arguments'
    it_behaves_like 'not initialized with one argument'
    it_behaves_like 'not initialized with more than two arguments'
     
    describe 'with two arguments' do
      it { expect(@new).to be_instance_of(described_class) }
      
      mtds_arr = described_class == RgLibGem::Book ? [:title, :author] : [:name, :biography]
      
      mtds_arr.each_with_index do |mtd, index|
        equiv = described_class == RgLibGem::Book ? ["Title", "Author"] : ["Title", "AuThor"]
        it { expect(@new).to respond_to(mtd) }
        it { expect(@new).not_to respond_to("#{mtd}=") }
        it { expect(@new).to have_attributes(mtd => equiv[index]) }
      end
      it_behaves_like 'a not nil string', described_class == RgLibGem::Book ? [:title, :author] : [:name, :biography]
    end
  end
end

shared_examples 'a counter with numeric value' do |class_var, count, instn|
  7.times { instn }
  subject(:class_i) { described_class.class_variable_get(class_var) }
  it { expect(class_i).to be_kind_of(Fixnum) }
  it 'should contain number of instances' do
    expect(class_i).to eq(count)
  end
end


shared_examples 'a subclass' do
  let(:parent) { described_class == RgLibGem::Book ?  RgLibGem::Author : RgLibGem::Library }
     it { expect(described_class).to be < parent }
end

shared_examples 'a superclass' do
  sub_class = described_class == RgLibGem::Library ? [RgLibGem::Author, RgLibGem::Reader, RgLibGem::Order, RgLibGem::Book] : [RgLibGem::Book]
  sub_class.each do |klass|
     it { expect(described_class).to be > klass }
  end
end

shared_examples 'not initialized with empty arguments' do
      it { expect{described_class.new}.to raise_error }
end

shared_examples 'not initialized with one argument' do
  it { expect{described_class.new("var3")}.to raise_error }
end

shared_examples 'not initialized with more than two arguments' do
  it { expect{described_class.new("val", "val", "val")}.to raise_error }
end

shared_examples 'initialized with more than two arguments' do
  it { expect(@new).to be_instance_of(described_class) }
end

shared_examples 'an array of ID\'s' do |numbr|
  subject (:rdr_id) { described_class.class_variable_get("@@#{described_class.name.downcase}_id") }
  it { expect(rdr_id).not_to be_nil }
  it { expect(rdr_id).to be_kind_of(Array) }
  it 'should collect ID\'s of readers' do
    expect(rdr_id.last).to eq(numbr)
  end
  
  context 'should contain unique values' do
    it { expect(rdr_id.length).to_not be_zero }
    it { expect(rdr_id.length).to eq(rdr_id.uniq.length) }
  end
end

shared_examples 'not initialized with more than one argument' do
  it { expect{described_class.new("val", "val")}.to raise_error }  
end

shared_examples 'initialized with one argument' do
  subject(:inst) {described_class.new("Library_name1")}
  it { expect(inst).to be_instance_of(described_class) }
end

shared_examples 'a not nil string' do |list|
  list.each do |methd|
    context "##{methd}" do
      subject(:name) { @new.send(methd) }
      it { expect(name).not_to be_nil }
      it { expect{described_class.new(3, :s) }.to raise_error("Attributes should take only string values.") }
      it 'should be capitalized' do
        expect(name[0].gsub!(/[[:lower:]]/, "")).to be_nil
      end
    end
  end
end

shared_examples 'a hash with counter as key and array of attributes as value' do
  subject (:class_rdr) { described_class.class_variable_get("@@#{described_class.name.downcase}") }
  it { expect(class_rdr).not_to be_nil }
  it { expect(class_rdr).to be_kind_of(Hash) }
  it 'should collect values of instance variables' do
    expect(class_rdr[1]).to match(["Name", "email", "City", "Street", "77"])
  end
end
