class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :wallet
  after_create :initialize_wallet
  has_one_attached :avatar

  private

  def initialize_wallet
    create_wallet(balance: 1000)  # ustalamy domyślne saldo np. 1000 żetonów
  end
end