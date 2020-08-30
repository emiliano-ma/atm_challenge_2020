require './lib/account'
require 'pry'

class Person
  attr_accessor :name, :cash, :account

  def initialize(attrs = {})
    @name = set_name(attrs[:name])
    @cash = 0
    @account = nil
  end

  def create_account
    @account = Account.new(owner: self)
  end

  def deposit(amount)
    @account.nil? ? missing_account : deposit_money(amount)
  end

  def withdraw(args = {})
    account.nil? ? missing_account : withdraw_money(args)
  end

  private

  def deposit_money(amount)
    @cash -= amount
    @account.balance += amount
  end

  def withdraw_money(args)
    args[:atm].nil? ? missing_atm : atm = args[:atm]
    account = @account
    amount = args[:amount]
    pin = args[:pin]
    response = atm.withdraw(amount, pin, account)
    response[:status] == true ? increase_cash(response) : response
    
  end

  def increase_cash(response)
    @cash += response[:amount]
  end

  def missing_atm
    raise RuntimeError, 'An ATM is required'
  end

  def missing_account
    raise 'No account present'
  end

  def set_name(name)
    name.nil? ? missing_name : name
  end

  def missing_name
    raise ArgumentError, 'A name is required'
  end
end