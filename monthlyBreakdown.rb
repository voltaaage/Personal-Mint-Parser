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
puts START_DATE

# Unknown: Can csv create different excel sheet tabs?

def main(file)
  CSV.open(FILENAME, "wb") # New file
  transactions = read_file(file)

  # TODO: split transactions in months and category here
  months = collect_months(transactions)
  months.each do |month|
      puts
      puts "================================================================"
      puts "MONTH: #{month}"
      CATEGORIES.each do |title, categories|
          monthly_group_data = all_transactions_in_month_and_category(transactions, title, month, categories)
          CSV.open(FILENAME, "a") do |csv|
              monthly_group_data.each do |data|
                  csv << data
              end
          end
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

def all_transactions_in_month_and_category(transactions, title, month, category)
    sorted_transactions = transactions.select{|transaction|
        start_of_month = Date.strptime(month, MONTH_FORMAT).at_beginning_of_month
        end_of_month = Date.strptime(month, MONTH_FORMAT).at_end_of_month
        transaction_date = Date.strptime(transaction[:date], DATE_FORMAT)

        transaction_date >= start_of_month &&
            transaction_date <= end_of_month &&
            category.include?(transaction[:category])
    }.sort_by{|t| t[:date]}

    monthly_category_transactions_in_csv(title, sorted_transactions)
end

def monthly_category_transactions_in_csv(title, transactions)
  monthly_transactions_group = get_monthly_transaction_group(transactions)
  monthly_transactions_group.unshift([title])
  monthly_transactions_group << [""]
  output_monthly_transactions(monthly_transactions_group)
  monthly_transactions_group
end

def output_monthly_transactions(monthly_transactions_group)
    monthly_transactions_group.each do |group|
        puts group.join('|')
    end
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

def get_monthly_transaction_group(transaction_group)
    monthly_transaction_group = []
    monthly_transaction_group << group_table_headers_csv_output

    sum = 0
    transaction_group.each do |transaction|
        amount = process_amount(transaction)
        if transaction_within_date_range(transaction)
            monthly_transaction_group << create_csv_row(transaction, amount)
            sum = sum + amount.to_f
        end
    end
    sum = sum.round(2)
    monthly_transaction_group << ["Total", " #{sum}"]
    monthly_transaction_group
end

# def group_table_headers_console_output
#   "Date|Description|Amount|Category|Original_Description|Notes"
# end

def group_table_headers_csv_output
  [ "Date", "Description", "Amount"] # , "Category", "Original_Description", "Notes"]
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
    # csv_row << transaction[:category]
    # csv_row << transaction[:original_description]
    # csv_row << transaction[:notes]
    csv_row
end

main(file)
