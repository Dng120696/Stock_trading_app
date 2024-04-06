require "test_helper"

class Trader::TransactionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get trader_transaction_index_url
    assert_response :success
  end

  test "should get create" do
    get trader_transaction_create_url
    assert_response :success
  end

  test "should get new" do
    get trader_transaction_new_url
    assert_response :success
  end

  test "should get show" do
    get trader_transaction_show_url
    assert_response :success
  end
end
