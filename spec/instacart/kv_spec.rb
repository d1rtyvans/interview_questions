require 'spec_helper'

RSpec.describe KV do
  let(:kv)    { described_class.new }
  let(:key)   { 'a' }
  let(:value) { 'val' }

  subject(:get) { kv.get(key) }
  subject(:set) { kv.set(key, value) }


  describe '#get' do
    subject { get }
    before  { @timestamp = set }

    it 'Looks up value by key' do
      is_expected.to eq(value)
    end

    context 'When key does not exist' do
      subject(:set) { }
      it { is_expected.to be_nil }
    end

    context 'Keys with multiple values' do
      context 'When timestamp argument is not given' do
        it 'Returns the latest value stored in key' do
          kv.set(key, 'right')
          expect(kv.get(key)).to eq('right')
        end
      end

      context 'When timestamp argument is given' do
        it 'Returns value stored in key matching the timestamp' do
          kv.set(key, 'wrong')
          expect(kv.get(key, @timestamp)).to eq(value)
        end

        context 'And value does not exist at that exact timestamp' do
          it 'Finds the latest value before that timestamp' do
            # Skip forward 2 days
            Timecop.travel(Time.now + 2*24*60*60) do
              kv.set(key, 'right')
              expect(kv.get(key, @timestamp + 1000)).to eq(value)
            end
          end

          context 'And no value exists prior to that timestamp' do
            subject(:get) { kv.get(key, timestamp) }
            let(:timestamp) { (Time.now - 100*24*60*60).to_f }

            it { is_expected.to be_nil }
          end
        end
      end
    end
  end

  describe '#set' do
    subject { set }

    it 'Returns a timestamp' do
      Timecop.freeze do
        timestamp = subject
        expect(timestamp).to eq(Time.now.to_f)
      end
    end
  end
end
