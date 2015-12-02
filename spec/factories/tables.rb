FactoryGirl.define do
  factory :table do
    title 'MyString'
    lounge nil
    seats 1
  end

  factory :table_ext do
    _idrref { 2.times.map{ 20 + Random.rand(11) }.join().bytes.join('\\') }
    _version 0
    _marked false
    _ismetadata false
    _owneridrref 0
    _code { rand(1..3000).to_s }
    _description 'круглый'
    _fld402 0
    _fld403 0
    _fld404 0
    _fld405 0
    _fld406 0
  end

  factory :reserv_status_ext do
    _idrref { SecureRandom.hex[0..5].bytes }
    _enumorder 1
  end
end
