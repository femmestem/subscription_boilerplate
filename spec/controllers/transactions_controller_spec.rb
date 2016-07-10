require 'stripe_mock'

describe TransactionsController, type: :controller do
  let(:demo_product) { create(:product) }
  # Using StripeMock doesn't touch Stripe's servers nor the internet!
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  describe 'POST #create' do
    context 'with valid credit card' do
      let(:stripe_charge) do
        Stripe::Charge.create(
          amount: demo_product.price,
          currency: "usd",
          source: stripe_helper.generate_card_token,
          description: ""
        )
      end
      let(:demo_product_sale) do
        demo_product.sales.create!(
          email: "",
          stripe_id: stripe_charge.id
        )
      end

      it "creates a sale" do
        expect(demo_product_sale.id).to_not eq(nil)
      end

      it "is processed by Stripe" do
        expect(stripe_charge.id).to_not eq(nil)
      end

      it "notifies the customer via email"

      it "redirects to pickup_url(guid: @sale.guid)" do
        post :create, :permalink => demo_product.permalink
        expect(response).to redirect_to(pickup_url(guid: Sale.last.guid))
      end
    end

    context 'with expired credit card' do
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

    context 'with invalid credit card CVVS/CVC code' do
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

    context 'with declined credit card' do
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
