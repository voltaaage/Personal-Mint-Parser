require 'CSV'
require "active_support/core_ext/date"
require "active_support/core_ext/time"

require './categories'

file = './transactions.csv'
FILENAME = "./results_monthly_breakdown.csv"
DATE_FORMAT = '%m/%d/%Y'
MONTH_FORMAT = '%m/%Y'

END_DATE = Date.today
START_DATE = END_DATE - 90

# Unknown: Can csv create different excel sheet tabs?

def main(file)
  CSV.open(FILENAME, "wb") # New file
  transactions = read_file(file)

  months = collect_months(transactions)
  months.each do |month|
      puts "MONTH: #{month}"
      sum = 0
      monthly_transactions = collect_month_transactions(transactions, month)
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
        Date.strptime(date, DATE_FORMAT).strftime(MONTH_FORMAT) if date
    end

    months.uniq
end

def collect_month_transactions(transactions, month)
      month_transactions = transactions.select do |transaction|

          start_of_month = Date.strptime(month, MONTH_FORMAT).at_beginning_of_month
          end_of_month = Date.strptime(month, MONTH_FORMAT).at_end_of_month
          transaction_date = Date.strptime(transaction[:date], DATE_FORMAT)

          transaction_date >= start_of_month && transaction_date <= end_of_month
      end
      month_transactions
end

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

    if (date != 'Date' && date_within_date_range(date))
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
  end
  transactions
end

def process(transaction_group, csv)
    puts group_table_headers_console_output
    csv << group_table_headers_csv_output

  sum = 0
  transaction_group.each do |transaction|
    amount = process_amount(transaction)
    csv << create_csv_row(transaction, amount) if transaction_within_date_range(transaction)
    sum = sum + amount.to_f
  end

  sum = sum.round(2)
  puts "Total: $#{sum}"
  csv << ["Total: ", "#{sum}"]
  sum
end

def group_table_headers_console_output
  "Date|Description|Amount|Category|Original_Description|Notes"
end

def group_table_headers_csv_output
  [ "Date", "Description", "Amount", "Category", "Original_Description", "Notes"]
end

def date_within_date_range(date)
  transaction_date = Date.strptime(date, DATE_FORMAT)
  transaction_date >= START_DATE && transaction_date <= END_DATE
end

def transaction_within_date_range(transaction)
    date_within_date_range(transaction[:date])
end

def process_amount(transaction)
    amount = transaction[:amount].to_f
    amount = amount * -1 if transaction[:transaction_type] == "credit"
    amount
end

def create_csv_row(transaction, amount)
    csv_row = []
    csv_row << transaction[:date]
    csv_row << transaction[:description]
    csv_row << amount
    csv_row << transaction[:category]
    csv_row << transaction[:original_description]
    csv_row << transaction[:notes]
    puts csv_row.join("|")
    csv_row
end

main(file)
