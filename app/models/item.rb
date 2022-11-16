class Item < ApplicationRecord
  ## 消費税を求めるメソッド
  def with_tax_price
    (price * 1.1).floor
  end
  
  validates :image, presence: {message: 'を選択してください'}
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      #image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
  validates :name, presence: true
  validates :introduction, presence: true

  belongs_to :genre

  validates :price, presence: true,
                    numericality: { only_integer: true,
                                    greater_than_or_equal_to: 0
                                  }

  validates :is_active, inclusion: {in: [true, false]}
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  
  has_one_attached :image
  

 
end
