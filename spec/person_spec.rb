require './lib/person'
require './lib/atm'

describe Person do
  subject { described_class.new(name: 'Emi') }
  it 'is expected to have a :name on initialize' do
    expect(subject.name).not_to be nil
  end
  it 'is expected to raise an error if no name is set' do
    expect { described_class.new }.to raise_error 'A name is required'
  end
  it 'is expected to have an attribute :cash with a value of 0 on initialize' do
    expect(subject.cash).to eq 0
  end
  it 'is expected to have an :account attribute' do
    expect(subject.account).to be nil
  end

  describe 'can create an account' do
    before { subject.create_account }
    it 'of Account class' do
      expect(subject.account).to be_an_instance_of Account
    end
    it 'with himself as an owner' do
      expect(subject.account.owner).to be subject
    end
  end

  describe 'can manage funds if account been created' do
    let(:atm_kista) { Atm.new }
    before { subject.create_account }
    it 'can deposit funds' do
      expect(subject.deposit(100)).to be_truthy
    end
    it 'funds are added to the account balance and deducted from cash' do
      subject.cash = 100
      subject.deposit(100)
      expect(subject.account.balance).to be 100
      expect(subject.cash).to be 0
    end

    it 'can withdraw funds' do
      command = -> { subject.withdraw(amount: 100, pin: subject.account.pin_code, account: subject.account, atm: atm_kista) }
      expect(command.call).to be_truthy
    end
    it 'withdraw is expected to raise error if no ATM is passed in' do
      command = -> { subject.withdraw(amount: 100, pin: subject.account.pin_code, account: subject.account) }
      expect { command.call }.to raise_error 'An ATM is required'
    end
    it 'money is added to cash and deducted from account balance' do
      subject.cash = 50
      subject.deposit(50)
      subject.withdraw(amount: 50, pin: subject.account.pin_code, account: subject.account, atm: atm_kista)
      expect(subject.account.balance).to eq 0
      expect(subject.cash).to eq 50
    end
  end

  describe 'can not manage funds if account have not been created' do
    it 'cannot deposit funds' do
      expect { subject.deposit(100) }.to raise_error(RuntimeError, 'No account present')
    end
  end
end
