require 'CSV'
require './categories'

# Setup parameters
file = './transactions_example.csv'
START_DATE = "01/01/2016"
END_DATE = "05/30/2017"
FILENAME = "./results-7-17.csv"

# TODO: switch the start and end date to be 2014 -> today
# TODO: Organize into each month
# Unknown: Can csv create different excel sheet tabs?


def main(file)
  CSV.open(FILENAME, "wb") # New file
  transactions = read_file(file)
  transactions.shift # removes the header from the mint export

  months = collect_months(transactions)
  months.each do |month|
      puts "MONTH: #{month}"
      sum = 0
      monthly_transactions = collect_month_transactions(transactions, month)
      # puts monthly_transactions
      # require 'byebug'; byebug
      CATEGORIES.each do |title, categories|
          category_sum = parse_transactions(monthly_transactions, title, categories)
          sum = sum + category_sum
      end

      CSV.open(FILENAME, "a") do |csv|
          csv << [""]
          csv << ["Total of all Transactions: ", sum]
      end
  end
end

def collect_months(transactions)
    months = transactions.map do |transaction|
        date = transaction[:date]
        Date.strptime(date, '%m/%d/%Y').strftime('%m/%Y') if date
    end

    months.uniq
end

def collect_month_transactions(transactions, month)
      month_transactions = transactions.select do |transaction|

          start_of_month = Date.strptime(month, '%m/%Y').strftime('%m/%d/%Y')
          start_of_month = Date.strptime(start_of_month, '%m/%d/%Y')
          end_of_month = Date.strptime(month, '%m/%Y').next_month.strftime('%m/%d/%Y')
          end_of_month = Date.strptime(end_of_month, '%m/%d/%Y')
          transaction_date = Date.strptime(transaction[:date], '%m/%d/%Y')

          # puts transaction_date
          # puts  start_of_month
          # puts  end_of_month
          # puts transaction_date >= start_of_month && transaction_date <= end_of_month
          transaction_date >= start_of_month && transaction_date <= end_of_month
      end
      month_transactions
end

# def testing
#     require 'Date'
#     month = '02/2017'
#     start_of_month = Date.strptime(month, '%m/%Y').strftime('%m/%d/%Y')
#     end_of_month = Date.strptime(month, '%m/%Y').next_month.strftime('%m/%d/%Y')
# end

def parse_transactions(transactions, title, category)
  sorted_transactions = transactions.select{|transaction|
    category.include?(transaction[:category])
  }.sort_by{|t| t[:date]}

  CSV.open(FILENAME, "a") do |csv|
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
  start_date = Date.strptime(START_DATE, '%m/%d/%Y')
  end_date = Date.strptime(END_DATE, '%m/%d/%Y')

  transaction_date = Date.strptime(transaction[:date], '%m/%d/%Y')

  # puts transaction_date
  # puts  start_date
  # puts  end_date
  # puts transaction_date >= start_date && transaction_date <= end_date
  if transaction_date >= start_date && transaction_date <= end_date
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

def create_csv_row

end

main(file)