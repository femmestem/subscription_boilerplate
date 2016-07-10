class Sale < ActiveRecord::Base
  belongs_to :product
  include AASM
  has_paper_trail

  aasm column: 'state' do
    state :pending, initial: true
    state :processing
    state :finished
    state :errored

    event :process, after: :charge_card do
      transitions from: :pending, to: :processing
    end

    event :finish do
      transitions from: :processing, to: :finished
    end

    event :fail do
      transitions from: :processing, to: :errored
    end
  end

  before_save :populate_guid
  validates_uniqueness_of :guid

private
  def populate_guid
    if new_record?
      while !valid? || self.guid.nil?
        self.guid = SecureRandom.random_number(1_000_000_000).to_s(36)
      end
    end
  end

  def charge_card
    begin
      save!
      charge = Stripe::Charge.create(
        amount: self.amount,
        currency: "usd",
        source: self.stripe_token,
        description: self.email
      )

      balance = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)
      exp_year = charge.source.exp_year
      exp_month = charge.source.exp_month

      self.update(
        stripe_id: charge.id,
        card_expiration: Date.new(exp_year, exp_month, 1),
        fee_amount: balance.fee
      )
      self.finish!
    rescue Stripe::StripeError => e
      # card has been declined or an error occurred
      self.update(error: e.message)
      self.fail!
    end
  end
end
