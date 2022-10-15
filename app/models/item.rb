class Item < ApplicationRecord
  ## 消費税を求めるメソッド
  def with_tax_price
    (price * 1.1).floor
  end
  
  validates :image, presence: {message: 'を選択してください'}
  validates :name, presence: true
  validates :description, presence: true

  belongs_to :genre

  validates :price, presence: true,
                    numericality: { only_integer: true,
                                    greater_than_or_equal_to: 0
                                  }

  validates :is_sale, inclusion: {in: [true, false]}
  has_many :cart_items, dependent: :destroy

  #attachment :image
  
end
