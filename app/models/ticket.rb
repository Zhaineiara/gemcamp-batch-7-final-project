class Ticket < ApplicationRecord
  include AASM

  before_create :deduct_coins
  before_create :generate_serial_number
  before_create  :check_coin_user
  before_destroy :refund_coins

  belongs_to :user
  belongs_to :item

  aasm column: :state do
    state :pending, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :pending, to: :won
    end

    event :lose do
      transitions from: :pending, to: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled, after: :refund_coins
    end
  end

  def refund_coins
    Rails.logger.debug "Refunding coins for user #{user.id}"
    if state == 'cancelled'
      cancelled_tickets = user.tickets.where(state: 'cancelled')
      cancelled_tickets_count = cancelled_tickets.count

      cancelled_tickets.each do |ticket|
        ticket.user.update!(coins: ticket.user.coins + 1)
      end

      user.update!(coins: user.coins + cancelled_tickets_count)
    end
  end

  private

  def check_coin_user
    if user.coins < coins
      errors.add(:base, "Insufficient coins")
      throw(:abort)
    end
  end

  def deduct_coins
    user.update(coins: user.coins - coins)
  end

  def generate_serial_number
    number_count = Ticket.where(item_id: item.id).count + 1
    number_count = number_count.to_s.rjust(4, '0')

    self.serial_number = "#{Time.current.strftime('%y%m%d')}-#{item.id}-#{item.batch_count}-#{number_count}"
  end
end
