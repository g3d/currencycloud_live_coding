require 'spec_helper'

describe Shorten do
  it { should validate_presence_of :url }
  it { should validate_uniqueness_of :slug }

  it { should have_db_column(:slug).of_type(:string) }
  it { should have_db_column(:url).of_type(:string) }
  it { should have_db_column(:visits).of_type(:integer) }

  describe '.strip_url' do
    let(:short) { Shorten.new(slug: 'test1', url: 'http://google.com/   ') }
    it 'trigger strip_url on save' do
      short.should_receive(:strip_url)
      short.save
    end
    context 'when url not stripped' do
      it 'should strip url' do
        short.save
        expect(short.url).to eq 'http://google.com/'
      end
    end
  end

  describe '.set_slug' do
    let(:short) { Shorten.new(url: 'http://viter.in/') }
    let(:short_with_slug) { Shorten.new(slug: 'rHDfv', url: 'http://betterspecs.org')}

    it 'trigger set_slug on save' do
      short.should_receive(:set_slug)
      short.save
    end

    context 'without slug' do
      it 'should generate slug with 5 characters' do
        short.save
        expect(short.slug).to_not eq nil
        expect(short.slug).to have(5).characters
      end
    end

    context 'with slug' do
      it 'not rewrite existing slug' do
        short_with_slug.save
        expect(short_with_slug.slug).to_not eq nil
        expect(short_with_slug.slug).to eq 'rHDfv'
      end
    end
  end
end
