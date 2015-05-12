require 'spec_helper'

describe  RgLibGem::Library do
	before(:all) do
	
		@new_lib = described_class.new("  libRary name\n   ")
		@equiv1 = ["Greg", "Biography"]
		@new_lib.add(RgLibGem::Author.new(@equiv1[0], @equiv1[1]))	
		@new_lib.add(RgLibGem::Author.new("Author94", "bio"))
		@new_lib.add(RgLibGem::Book.new("Book94", "Author94"), RgLibGem::Book.new("Newton", "Auth99"))
		@new_lib.add(RgLibGem::Author.new("First", "bio"), RgLibGem::Author.new("Second", "bio"), RgLibGem::Author.new("Third", "bio"))
		@new_lib.add(RgLibGem::Book.new("AAA", "First"), RgLibGem::Book.new("BBB", "Second"), RgLibGem::Book.new("CCC", "Third"))
		@new_lib.add(RgLibGem::Reader.new("Frank"), RgLibGem::Order.new(1, "CCC", "Third"))
		
	end
	
	it_behaves_like 'a superclass'
		
	describe '.new' do
	
 		it_behaves_like 'not initialized with empty arguments'
  	it_behaves_like 'not initialized with more than one argument'
 		
		context 'with one argument' do
			it_behaves_like 'initialized with one argument'
			it { expect(@new_lib).to respond_to(:name, :add) }
			it { expect(@new_lib).not_to respond_to(:name=) }
			it { expect(@new_lib).to have_attributes(:name => "Library_name") }
			context "with class variable @@#{described_class.name.downcase} that" do
				context 'behaves like a not nil array of unique values' do
					subject (:class_var) { described_class.class_variable_get("@@library") }
					it { expect(class_var).not_to be_nil }
					it { expect(class_var).to be_kind_of(Array) }
					it 'should collect values of instance variables' do
						expect(class_var.first).to eq("Library_name")
					end
					it 'should contain unique values' do
						expect(class_var.length).to eq(class_var.uniq.length)
					end
				end		
			end
			
			describe '#name' do
				subject(:name) {@new_lib.name}
				it { expect(name).to_not include(" ") }
				it { expect(name).to_not match(/\s/) }
				it { expect {described_class.new(" 0Library ")}.to raise_error("Should not start from digit.") }
				it 'should be capitalized' do
					expect(name[0]).to eq("L")
				end
				it 'should not have any other capitalized character' do 
					expect(name[1..-1]).to match("ibrary_name")
				end
				context 'when adding name that already exists' do
					it { expect{described_class.new(name)}.to raise_error("Already exists.") }
				end
			end
			describe '#add' do
				
				context 'when adding author' do
				subject(:in_auth) { @new_lib.instance_variable_get(:@authors) }
					context 'with instance variable @authors' do
						it { expect(in_auth).to be_kind_of(Hash) }
						it 'should not include nil keys' do
							expect(in_auth.keys).to_not include(nil)
						end
						it 'should not include nil values' do
							expect(in_auth.values.flatten).to_not include(nil)
						end
						it 'should collect name as a key and biography as a value' do 
							expect(in_auth[@equiv1[0]]).to eq(@equiv1[1])
						end
						context 'when author name already listed' do
							it { expect{ @new_lib.add(RgLibGem::Author.new(@equiv1[0], @equiv1[1])) }.to raise_error }
						end
						context 'should add more than one author at once' do
							let(:add_bk) { @new_lib.add(RgLibGem::Author.new("Newton", "Aphy"), RgLibGem::Author.new("Isaak", "Biogr")) }		
							it { expect{add_bk}.to_not raise_error }
						end
					end
				end
				
				context 'when adding book' do
				subject(:in_book) { @new_lib.instance_variable_get(:@books) }
					context 'with instance variable @books' do
						it { expect(in_book).to be_kind_of(Hash) }
						it 'should not include nil keys' do
							expect(in_book.keys).to_not include(nil)
						end
						it 'should not include nil values' do
							expect(in_book.values.flatten).to_not include(nil)
						end
						context 'should collect author\'s name as a key, book titles as a value ' do
						let(:add_bk1) { @new_lib.add(Book.new("Book94", "Author94")) }	
							it { expect(in_book["Author94"]).to match("Book94") }
						end
						it 'should add more than one book at once' do
							expect{@new_lib.add(RgLibGem::Book.new("Newton", "Author94"), RgLibGem::Book.new("Isaak", "Author94"))}.to_not raise_error
						end
						context 'should not add existing book again' do
							let(:add_book) { @new_lib.add(RgLibGem::Book.new("Book104", "Author104"), RgLibGem::Book.new("Book104", "Author104")) }
							it { expect{add_book}.to raise_error(/already added/) }
							it { expect(in_book.length).to_not be_zero }
						end
						it 'should collect only unique book names' do
							expect(in_book[@equiv1[0]].length).to eq(in_book[@equiv1[0]].uniq.length)
						end
					end					
				end
					
				context 'when adding reader' do
					subject(:in_reader) { @new_lib.instance_variable_get(:@readers) }
					context 'with instance variable @readers' do
						it { expect(in_reader).to be_kind_of(Hash) }
						it 'should not include nil keys' do
							expect(in_reader.keys).to_not include(nil)
						end
						it 'should not include nil values' do
							expect(in_reader.values.flatten).to_not include(nil)
						end
						context 'should collect reader\'s ID as a key and info as a value ' do 
							it { expect(in_reader.first.last).to match(["Frank", "n/a", "N/a", "N/a", "N/a"]) }
							it { expect(in_reader.length).to_not be_zero }
						end
						it 'should add more than one reader at once' do
							expect{@new_lib.add(RgLibGem::Reader.new("Name126"), RgLibGem::Reader.new("Name127"))}.to_not raise_error
						end
						context 'should not add reader with all matching attributes' do
							it { expect{ 2.times { @new_lib.add(RgLibGem::Reader.new("Fin")) } }.to raise_error(/already exists/) }
						end
					end
				end
			
				context 'when adding order' do
					subject(:in_order) { @new_lib.instance_variable_get(:@orders) }
					context 'with instance variable @orders' do
						it { expect(in_order).to be_kind_of(Hash) }
						it 'should not include nil keys' do
							expect(in_order.keys).to_not include(nil)
						end
						it 'should not include nil values' do
							expect(in_order.values.flatten).to_not include(nil)
						end
						
						context 'should collect order\'s ID as a key and info as a value ' do 
						
							it { expect(in_order.first.last).to match([1, "Ccc", "Third", Time.now.strftime("%Y%m%d")]) }
							it { expect(in_order.length).to_not be_zero }
						end
						it 'should add more than one order at once' do
							expect{ @new_lib.add(RgLibGem::Order.new(1, "AAA", "First"), RgLibGem::Order.new(1, "BBB", "Second")) }.to_not raise_error
						end
						
						context 'while adding order'
							context 'with unlisted author' do
							it { expect{ @new_lib.add(RgLibGem::Order.new(1, "Book94", "Author93"))}.to raise_error(/no such author/)}
						end
						
						context 'with unlisted book' do
							it { expect{ @new_lib.add(RgLibGem::Order.new(1, "Book777", "Author99"))}.to raise_error(/book not listed/) }
						end
						
						context 'with unexisting reader ID' do
							it { expect{ @new_lib.add(RgLibGem::Order.new(9999, "BBB", "Second"))}.to raise_error(/invalid reader ID/) }
						end
						
						context 'should not add order with all matching attributes' do
							it { expect{ 2.times { @new_lib.add(RgLibGem::Order.new(2, "Book94", "Author94")) } }.to raise_error(/order already exists/) }
						end
					end
				end	
									
				context 'when adding object of other classes' do
					it { expect{ @new_lib.add([3, "Book"], 7, :f) }.to raise_error(/Incorrect object/) }
				end
			end
			
			describe '#top_readers' do
				context 'with Fixnum attribute' do
					it { expect{ @new_lib.top_readers("f") }.to raise_error(/Must be Fixnum/)  }
				end
				context 'without attribute' do
					it 'should return array with maximum of 3 reader ID\'s with higher book count' do
						expect(@new_lib.top_readers).to eq([1, 2])
					end
				end	
				context 'with attribute set to 1' do
					it 'should return array with the reader ID with the highest book count' do
						expect(@new_lib.top_readers(1)).to eq([1])
					end
				end
			end
	
			describe '#top_books' do
				context 'with Fixnum attribute' do
					it { expect{ @new_lib.top_books("f") }.to raise_error(/Must be Fixnum/)  }
				end
				context 'without attribute' do
					it 'should return array with the most popular book name' do
						expect(@new_lib.top_books).to eq(["Ccc"])
					end
				end
				context 'with attribute set to 2' do
					it 'should return array with two top rated books' do
						expect(@new_lib.top_books(2)).to eq(["Ccc", "Aaa"])
					end
				end
			end
			
			describe '#bb_readers' do
				context 'with Fixnum attribute' do
					it { expect{ @new_lib.bb_readers("f") }.to raise_error(/Must be Fixnum/)  }
				end
				context 'without attribute' do
					it 'should return array with the readers of maximum 3 top books' do
						expect(@new_lib.bb_readers).to eq([1])
					end
				end
				context 'with attribute set to 2' do
					it 'should return array with two top rated books' do
						expect(@new_lib.bb_readers(2)).to eq([1])
					end
				end
			end		
		end
	end
end


