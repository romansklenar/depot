require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  fixtures :users


  def setup
    @controller = AdminController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end


  def test_index_without_user
    get :index
    assert_redirected_to :controller => :admin, :action => :login
    assert_equal "Please log in", flash[:notice]
  end


  def test_index_with_user
    get :index, {}, { :user_id => users(:dave).id }
    assert_response :success
    assert_template :index
  end


  def test_login
    dave = users(:dave)
    post :login, :name => dave.name, :password => 'secret'

    assert_redirected_to :controller => :admin, :action => :index
    assert_equal dave.id, session[:user_id]
  end


  def test_bad_password
    dave = users(:dave)
    post :login, :name => dave.name, :password => 'wrong'

    assert !session[:user_id]
    assert_template :login
  end


  def test_user_is_redirected_once_authenticated
    @request.session[:original_uri] = users_path
    dave = users(:dave)
    post :login, :name => dave.name, :password => 'secret'

    assert_redirected_to users_path
  end


  def test_user_gets_logged_out
    @request.session[:user_id] = users(:dave).id
    get :logout

    assert_redirected_to :controller => :admin, :action => :login
    assert !@response.session[:user_id]
    assert_equal @response.flash[:notice], "Logged out"
  end

end