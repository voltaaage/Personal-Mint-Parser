require 'minitest/autorun'
require './monthlyBreakdown.rb'

# describe 'create_csv_row' do
#     before do
#         @transaction = {
#             date: '1/1/2001',
#             description: 'test description',
#             category: 'test category',
#             original_description: 'test og description',
#             notes: 'test note'
#         }
#     end

#     it 'creates an array from the transaction' do
#         amount = 10
#         result = create_csv_row(@transaction, amount)
#         expected = [
#            '1/1/2001',
#            'test description',
#            10,
#            'test category',
#            'test og description',
#            'test note'
#         ]

#         assert_equal(expected, result)
#     end
# end
