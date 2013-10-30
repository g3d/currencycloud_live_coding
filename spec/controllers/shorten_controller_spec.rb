require 'spec_helper'

describe ShortenController do
  let(:valid_attrs) { {url: 'http://google.com'} }
  let(:invalid_attrs) { {url: ''} }

  describe 'GET index' do
    before do
      @shorten_1 = Shorten.create(slug: 'wret', url: 'http://github.com/g3d')
      @shorten_2 = Shorten.create(slug: 'wtet', url: 'http://google.com/')
    end
    it 'render existing shortens' do
      get :index

      expect(response.status).to eq 200
      expect(assigns(:shortens)).to match_array [@shorten_1, @shorten_2]
    end
  end

  describe 'GET show/:id' do
    let(:shorten) { Shorten.create(slug: 'rH4v5', url: 'http://github.com/g3d')}

    it 'redirect to correct uri' do
      get :show, id: shorten.slug

      expect(response.status).to eq 302
      expect(response).to redirect_to(shorten.url)
    end

    it 'redirect to homepage when item not exist with message' do
      get :show, id: 'fgfgg'

      expect(response.status).to eq 302
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq 'Item destroyed long time ago'
    end
  end

  describe 'POST create' do
    it 'creates a new Shorten' do
      expect {
        post :create, {shorten:  valid_attrs }
      }.to change(Shorten, :count).by 1
      expect(Shorten.last.url).to eq valid_attrs[:url]
    end

    it 'not creates new Shorten if link exist' do
      shorten_first = Shorten.create(valid_attrs)
      expect {
        post :create, {shorten:  valid_attrs }
      }.to change(Shorten, :count).by(0)
      expect(Shorten.last.slug).to eq shorten_first.slug
    end

    it 'redirect to index after creating' do
      post :create, {shorten: valid_attrs }
      expect(response.status).to eq 302
      expect(response.status).to redirect_to(root_path)
    end

    context 'notice' do
      it 'show sucess notice on create' do
        post :create, {shorten: valid_attrs}
        expect(flash[:notice]).to eq 'Shorten created'
      end

      it 'show failure notice on error' do
        post :create, {shorten: invalid_attrs}
        expect(flash[:notice]).to eq 'Url can\'t be blank. Url is not a valid URL'
      end
    end
  end
end
