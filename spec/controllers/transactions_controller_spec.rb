require 'stripe_mock'

describe TransactionsController, type: :controller do
  let(:demo_product) { Product.create!(name: "Demo Product", permalink: "demo_link", price: 100) }
  # Using StripeMock doesn't touch Stripe's servers nor the internet!
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  describe 'POST #create' do
    context 'with valid credit card number, exp date, and CVVS code' do
      it "creates a sale"
      it "processes the transaction with Stripe"
      it "sends an order email to the customer"
      it "redirects to pickup_url(guid: @sale.guid)"
    end

    context 'with an expired credit card' do
      it "mocks an expired credit card error" do
        StripeMock.prepare_card_error(:expired_card)
        expect { Stripe::Charge.create(amount: 100, currency: 'usd') }.to raise_error { |e|
            expect(e).to be_a Stripe::CardError
            expect(e.http_status).to eq(402)
            expect(e.code).to eq('expired_card')
          }
      end

      it "renders the :new template" do
        StripeMock.prepare_card_error(:expired_card)
        post :create, :permalink => demo_product.permalink
        expect(response).to render_template :new
      end
    end

    context 'with a valid credit card and invalid CVVS/CVC code' do
      it "mocks an invalid CVVS/CVC code error" do
        StripeMock.prepare_card_error(:invalid_cvc)
        expect { Stripe::Charge.create(amount: 100, currency: 'usd') }.to raise_error { |e|
            expect(e).to be_a Stripe::CardError
            expect(e.http_status).to eq(402)
            expect(e.code).to eq('invalid_cvc')
          }
      end

      it "renders the :new template" do
        StripeMock.prepare_card_error(:invalid_cvc)
        post :create, :permalink => demo_product.permalink
        expect(response).to render_template :new
      end
    end

    context 'with a credit card that is declined' do
      it "mocks a declined card error" do
        StripeMock.prepare_card_error(:card_declined)
        expect { Stripe::Charge.create(amount: 100, currency: 'usd') }.to raise_error { |e|
            expect(e).to be_a Stripe::CardError
            expect(e.http_status).to eq(402)
            expect(e.code).to eq('card_declined')
          }
      end

      it "renders the :new template" do
        StripeMock.prepare_card_error(:card_declined)
        post :create, :permalink => demo_product.permalink
        expect(response).to render_template :new
      end
    end
  end

end
