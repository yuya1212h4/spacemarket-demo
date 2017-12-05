# Space

## association
- has_many :categories, through: :category_spaces
- has_many :categories_spaces
- has_many :payments, through: :payment_spaces
- has_many :payment_spaces
- has_many :space_images
- has_many :space_movies
- has_many :prices
- belongs_to :host
- has_one :address

## columns
- title           :string
- description     :text
- equipment       :text
- size            :integer
- capacity        :integer
- business_hours  :integer
- attachment      :string
- important_point :text
- contact         :text
- host            :references

# category_space
## association
- belongs_to :space
- belongs_to :category

## columns
- space     references
- category  references



# category
## association
- has_many :category_spaces
- has_many :spaces, through: :category_spaces

## columns
- event_type   :string, null: false


# payment_space
## association
- belongs_to :space
- belongs_to :payment

## columns
- space    :references
- payment  :references


# payment
## association
- has_many :spaces, through: :payment_spaces
- has_many :payment_spaces

## columns
- payment_way   :string


# space_image
## association
- belongs_to :space

## columns
- image     :string, null: false
- image_type   :integer { main: 0, sub: 1}, null: false
- space     :references


# space_movie
## association
- belongs_to :space

## columns
- movie    :string, null: false
- space    :references


# price
## association
- belongs_to :space

## columns
- amount   :integer, null: false
- title    :string, null: false
- description  :text


# host
## association
- has_many :spaces

## columns
- name  :stringm null :false
- description :text, null: false


# address
## association
- belongs_to :space

## columns
- street_address   :string, null: false
- latitude         :double
- longitude        :double
- access           :string
- spaces           :references
