require 'test_helper'

class InternetAddressesControllerTest < ActionController::TestCase
  setup do
    @internet_address = internet_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:internet_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create internet_address" do
    assert_difference('InternetAddress.count') do
      post :create, :internet_address => { :number => @internet_address.number, :version => @internet_address.version }
    end

    assert_redirected_to internet_address_path(assigns(:internet_address))
  end

  test "should show internet_address" do
    get :show, :id => @internet_address
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @internet_address
    assert_response :success
  end

  test "should update internet_address" do
    put :update, :id => @internet_address, :internet_address => { :number => @internet_address.number, :version => @internet_address.version }
    assert_redirected_to internet_address_path(assigns(:internet_address))
  end

  test "should destroy internet_address" do
    assert_difference('InternetAddress.count', -1) do
      delete :destroy, :id => @internet_address
    end

    assert_redirected_to internet_addresses_path
  end
end
