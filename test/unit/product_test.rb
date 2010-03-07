require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  

  def test_invalid_with_empty_attributes
    product = Product.new
    assert !product.valid?
    assert product.errors.invalid?(:title)
    assert product.errors.invalid?(:description)
    assert product.errors.invalid?(:price)
    assert product.errors.invalid?(:image_url)
  end


  def test_positive_price
    product = Product.new(:title => "My Book Title", :description => "yyy", :image_url => "zzz.jpg")
    product.price = -1
    assert !product.valid?
    assert_equal "should be at least 0.01" , product.errors.on(:price)

    product.price = 0
    assert !product.valid?
    assert_equal "should be at least 0.01" , product.errors.on(:price)
    
    product.price = 0.001
    assert !product.valid?
    assert_equal "should be at least 0.01" , product.errors.on(:price)

    product.price = 0.01
    assert product.valid?
    assert_nil product.errors.on(:price)

    product.price = 1
    assert product.valid?
    assert_nil product.errors.on(:price)
  end


  def test_image_url
    ok  = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    product = Product.new(:title => "My Book Title", :description => "yyy", :price => 1)

    ok.each do |name|
      product.image_url = name
      assert product.valid?, product.errors.full_messages
    end

    bad.each do |name|
      product.image_url = name
      assert !product.valid?, "saving #{name}"
    end
  end


  def test_unique_title
    product = Product.new(
      :title       => products(:ruby_book).title,
      :description => "yyy",
      :price       => 1,
      :image_url   => "fred.gif"
    )
    assert !product.save
    assert_equal "has already been taken", product.errors.on(:title)
    # assert_equal ActiveRecord::Errors.default_error_messages[:taken], product.errors.on(:title) # deprecated
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors.on(:title)
  end

end