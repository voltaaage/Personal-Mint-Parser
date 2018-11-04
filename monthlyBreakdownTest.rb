require 'minitest/autorun'
require './monthlyBreakdown.rb'

DATE_FORMAT = '%m/%d/%Y'
MONTH_FORMAT = '%m/%Y'

describe 'process_amount' do
    before do
        @transaction = {
            amount: 10,
            transaction_type: 'credit'
        }
    end

    it 'returns a negative amount if transaction is a credit type' do
        result = process_amount(@transaction)
        expected = -10
        assert_equal(expected, result)
    end

    it 'returns a positive amount if transaction is a debit type' do
        @transaction[:transaction_type] = 'debit'
        result = process_amount(@transaction)
        expected = 10
        assert_equal(expected, result)
    end
end

describe 'create_csv_row' do
    before do
        @transaction = {
            date: '1/1/2001',
            description: 'test description',
            amount: 10,
            category: 'test category',
            original_description: 'test og description',
            notes: 'test note'
        }
    end

    it 'creates an array from the transaction' do
        amount = -10
        result = create_csv_row(@transaction, amount)
        expected = [
           '1/1/2001',
           'test description',
           -10,
           'test category',
           'test og description',
           'test note'
        ]

        assert_equal(expected, result)
    end
end
