require 'CSV'
require './categories'

# Setup parameters
file = './transactions.csv'
START_DATE = "06/01/2018"
END_DATE = "06/30/2018"


def main(file)
  CSV.open("./results.csv", "wb") # New file
  transactions = read_file(file)
  transactions.shift # removes the header from the mint export

  sum = 0
  CATEGORIES.each do |title, categories|
    category_sum = parse_transactions(transactions, title, categories)
    sum = sum + category_sum
  end

  CSV.open("./results.csv", "a") do |csv|
    csv << [""]
    csv << ["Total of all Transactions: ", sum]
  end
end

def parse_transactions(transactions, title, category)
  sorted_transactions = transactions.select{|transaction|
    category.include?(transaction[:category])
  }.sort_by{|t| t[:date]}

  CSV.open("./results.csv", "a") do |csv|
    category_sum = process_category_data(title, sorted_transactions, csv)
  end
end

def process_category_data(title, transactions, csv)
  group_header(title, csv)
  sum = process(transactions, csv)
  sum
end

def group_header(name, csv)
  puts "\n#{name}"
  csv << [""]
  csv << [name]
end

def read_file(file)
  transactions = []
  CSV.foreach(file) do |row|
    # Core Info
    date = row[0]
    description = row[1]
    amount = row[3]
    category = row[5]
    transaction_type = row[4]

    # Additional Info
    original_description = row[2]
    notes = row[8]

    transactions << {
      date: date,
      description: description,
      amount: amount,
      category: category,
      original_description: original_description,
      notes: notes,
      transaction_type: transaction_type
    }
  end
  transactions
end

def process(transaction_group, csv)
  puts "Date|Description|Amount|Category|Original_Description|Notes"
  csv << [ "Date", "Description", "Amount", "Category", "Original_Description", "Notes"]

  sum = 0
  transaction_group.each do |transaction|
    amount = processing(transaction, csv)
    sum = sum + amount.to_f
    sum = sum.round(2)
  end

  puts "Total: $#{sum}"
  csv << ["Total: ", "#{sum}"]
  sum
end

def processing(transaction, csv)
  internal_start_date = Date.strptime(START_DATE, '%m/%d/%Y')
  internal_end_date = Date.strptime(END_DATE, '%m/%d/%Y')

  internal_transaction_date = Date.strptime(transaction[:date], '%m/%d/%Y')

  if internal_transaction_date >= internal_start_date && internal_transaction_date <= internal_end_date
    amount = transaction[:amount].to_f

    if transaction[:transaction_type] == "credit"
      amount = amount * -1
    end

    csv_row = []
    csv_row << transaction[:date]
    csv_row << transaction[:description]
    csv_row << amount
    csv_row << transaction[:category]
    csv_row << transaction[:original_description]
    csv_row << transaction[:notes]
    puts csv_row.join("|")
    csv << csv_row

    amount
  end
end

main(file)
