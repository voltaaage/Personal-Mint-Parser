require 'CSV'

file = './transactions.csv'
start_date = "11/01/2016"

def main(file, start_date)

  puts "Date|Description|Amount|Original_Description|Notes"

  results = read_file(file)
  results.shift # removes the header from the mint export

  results.each do |result|
    processing(result, start_date)
  end
end

def read_file(file)
  results = []
  CSV.foreach(file) do |row|
    # Core Info
    date = row[0]
    description = row[1]
    amount = row[3]
    category = row[5]

    # Additional Info
    original_description = row[2]
    notes = row[8]

    results << {
      date: date,
      description: description,
      amount: amount,
      category: category,
      original_description: original_description,
      notes: notes
    }
  end
  results
end

def processing(result, start_date)
  internal_start_date = Date.strptime(start_date, '%m/%d/%Y')

  if result[:category] == "Income" || result[:category] == "Paycheck"
    result[:amount] = "-#{result[:amount]}"
  end

  internal_transaction_date = Date.strptime(result[:date], '%m/%d/%Y')
  # puts internal_transaction_date.inspect

  if internal_transaction_date > internal_start_date
    puts "#{result[:date]}|#{result[:description]}|#{result[:amount]}|#{result[:original_description]}|#{result[:notes]}"
  end
end

main(file, start_date)
