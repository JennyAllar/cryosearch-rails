require 'rails_helper'

RSpec.describe 'Banks API', type: :request do
# initialize test data 
  let!(:banks) { create_list(:bank, 10) }
  let(:bank_id) { banks.first.id }

  # Test suite for GET /banks
  describe 'GET /banks' do
    before { get '/banks' }

    it 'returns banks' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /banks/:id
  describe 'GET /banks/:id' do
    before { get "/banks/#{bank_id}" }

    context 'when the record exists' do
      it 'returns the bank' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(bank_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:bank_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("{\"message\":\"Couldn't find Bank with 'id'=100\"}")
      end
    end
  end

  # Test suite for POST /banks
  describe 'POST /banks' do
    let(:valid_attributes) { { name: 'Learn Elm', state: 'lorem' } }

    context 'when the request is valid' do
      before { post '/banks', params: valid_attributes }

      it 'creates a bank' do
        expect(json['name']).to eq('Learn Elm')
        expect(json['state']).to eq('lorem')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/banks', params: { name: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"message\":\"Validation failed: State can't be blank\"}")
      end
    end
  end

  # Test suite for PUT /banks/:id
  describe 'PUT /banks/:id' do
    let(:valid_attributes) { { name: 'Shopping' } }

    context 'when the record exists' do
      before { put "/banks/#{bank_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /banks/:id
  describe 'DELETE /banks/:id' do
    before { delete "/banks/#{bank_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end